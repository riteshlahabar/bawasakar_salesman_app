import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../app/data/models/summary_card_model.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_attendance_service.dart';
import '../../../app/data/services/salesman_dashboard_service.dart';
import '../../../app/data/services/auth_storage.dart';
import 'dashboard_response_parser.dart';
import '../../../app/localization/t.dart';

class DashboardController extends GetxController {
  final SalesmanDashboardService _api = Get.find<SalesmanDashboardService>();

  final SalesmanAttendanceService _attendanceApi =
      Get.find<SalesmanAttendanceService>();

  final AuthStorage _storage = Get.find<AuthStorage>();

  final isLoading = false.obs;

  final salesmanName = 'Sales Executive'.obs;

  final employeeCode = ''.obs;

  final assignedDealers = 0.obs;

  final pendingOrders = 0.obs;

  final todayCollections = 0.0.obs;

  final totalOutstanding = 0.0.obs;

  final monthTarget = Rxn<double>();

  final monthAchieved = Rxn<double>();

  final todayVisits = 0.obs;

  final monthIncentive = Rxn<double>();

  final pendingTasks = 0.obs;

  final summaries = <SummaryCardModel>[].obs;

  final isPunching = false.obs;

  final checkedInAt = ''.obs;

  final checkedOutAt = ''.obs;

  final checkInAddress = ''.obs;

  final onBreak = false.obs;

  /// Today's finished break time, as returned by the dashboard API.
  final breakMinutes = 0.obs;

  /// Set while a break/resume call is in flight, so the button can't be
  /// double-tapped into two open breaks.
  final isBreakBusy = false.obs;

  bool get hasCheckedInToday => checkedInAt.value.isNotEmpty;

  bool get hasCheckedOutToday => checkedOutAt.value.isNotEmpty;

  @override
  void onReady() {
    super.onReady();

    loadDashboard();
  }

  Future<void> loadDashboard() async {
    if (isLoading.value) {
      return;
    }

    isLoading.value = true;

    try {
      final response = await _api.dashboard();

      final data = DashboardResponseParser.data(response);

      assignedDealers.value = ModuleRowMapper.toInt(data['assigned_dealers']);

      pendingOrders.value = ModuleRowMapper.toInt(data['pending_orders']);

      todayCollections.value = ModuleRowMapper.toDouble(
        data['today_collections'],
      );

      totalOutstanding.value = ModuleRowMapper.toDouble(
        data['total_outstanding'],
      );

      monthTarget.value = data['month_target'] == null
          ? null
          : ModuleRowMapper.toDouble(data['month_target']);

      monthAchieved.value = data['month_achieved'] == null
          ? null
          : ModuleRowMapper.toDouble(data['month_achieved']);

      todayVisits.value = ModuleRowMapper.toInt(data['today_visits']);

      monthIncentive.value = data['month_incentive'] == null
          ? null
          : ModuleRowMapper.toDouble(data['month_incentive']);

      pendingTasks.value = ModuleRowMapper.toInt(data['pending_tasks']);

      final profile = DashboardResponseParser.parseProfile(data);

      if (profile.name.isNotEmpty) {
        salesmanName.value = profile.name;
      }

      if (profile.employeeCode.isNotEmpty) {
        employeeCode.value = profile.employeeCode;
      }

      // Save fallback profile data if
      // dashboard relation is absent.
      if (salesmanName.value == 'Sales Executive') {
        final storedName = _storage.name;

        if (storedName.trim().isNotEmpty) {
          salesmanName.value = storedName;
        }
      }

      if (employeeCode.value.isEmpty) {
        employeeCode.value = _storage.employeeCode;
      }

      final todayAttendance = DashboardResponseParser.parseTodayAttendance(
        data,
      );

      checkedInAt.value = todayAttendance.checkInAt;
      checkedOutAt.value = todayAttendance.checkOutAt;
      onBreak.value = todayAttendance.onBreak;
      breakMinutes.value = todayAttendance.breakMinutes;

      if (hasCheckedInToday) {
        unawaited(
          _resolveAddress(
            todayAttendance.checkInLatitude,
            todayAttendance.checkInLongitude,
          ),
        );
      }

      _buildCards();
    } catch (error) {
      Get.snackbar(
        t('common.dashboard'),
        DashboardResponseParser.errorMessage(error),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _buildCards() {
    summaries.assignAll(
      DashboardResponseParser.buildSummaries(
        todayCollections: todayCollections.value,
        assignedDealers: assignedDealers.value,
        pendingOrders: pendingOrders.value,
        totalOutstanding: totalOutstanding.value,
        monthTarget: monthTarget.value,
        monthAchieved: monthAchieved.value,
        todayVisits: todayVisits.value,
        monthIncentive: monthIncentive.value,
        pendingTasks: pendingTasks.value,
      ),
    );
  }

  Future<void> checkIn() async {
    if (isPunching.value || hasCheckedInToday) return;

    isPunching.value = true;

    try {
      final position = await _currentPosition();
      final response = await _attendanceApi.checkIn(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      final attendance = ModuleRowMapper.mapFrom(response, 'attendance');

      checkedInAt.value =
          attendance['check_in_at']?.toString() ??
          DateTime.now().toIso8601String();

      await _resolveAddress(position.latitude, position.longitude);
    } catch (error) {
      Get.snackbar(
        t('common.attendance'),
        DashboardResponseParser.errorMessage(error),
      );
    } finally {
      isPunching.value = false;
    }
  }

  Future<void> checkOut() async {
    if (isPunching.value || !hasCheckedInToday || hasCheckedOutToday) return;

    isPunching.value = true;

    try {
      final position = await _currentPosition();
      final response = await _attendanceApi.checkOut(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      final attendance = ModuleRowMapper.mapFrom(response, 'attendance');

      checkedOutAt.value =
          attendance['check_out_at']?.toString() ??
          DateTime.now().toIso8601String();
    } catch (error) {
      Get.snackbar(
        t('common.attendance'),
        DashboardResponseParser.errorMessage(error),
      );
    } finally {
      isPunching.value = false;
    }
  }

  /// Starts or ends a break on today's attendance log. Each break is a real
  /// row on the server, so it shows up in the admin attendance record and is
  /// deducted from the day's working minutes at check-out.
  Future<void> toggleBreak() async {
    if (isBreakBusy.value || !hasCheckedInToday || hasCheckedOutToday) return;

    isBreakBusy.value = true;
    final wasOnBreak = onBreak.value;

    try {
      // GPS is optional for a break, so a failed lookup should not block it.
      Position? position;
      try {
        position = await _currentPosition();
      } catch (_) {
        position = null;
      }

      final response = wasOnBreak
          ? await _attendanceApi.resumeBreak(
              latitude: position?.latitude,
              longitude: position?.longitude,
            )
          : await _attendanceApi.startBreak(
              latitude: position?.latitude,
              longitude: position?.longitude,
            );

      onBreak.value = !wasOnBreak;

      if (wasOnBreak) {
        final minutes = ModuleRowMapper.toDouble(
          (response['data'] as Map?)?['break_minutes'],
        ).round();
        if (minutes > 0) breakMinutes.value = minutes;
      }
    } catch (error) {
      Get.snackbar(
        t('common.attendance'),
        DashboardResponseParser.errorMessage(error),
      );
    } finally {
      isBreakBusy.value = false;
    }
  }

  Future<Position> _currentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw t('dashboard.location_services_are_disabled');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw t('dashboard.location_permission_is_required');
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  Future<void> _resolveAddress(double latitude, double longitude) async {
    if (latitude == 0 && longitude == 0) return;

    try {
      final placemarks = await Geocoding().placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (placemarks.isEmpty) return;

      final place = placemarks.first;
      checkInAddress.value = [
        place.subLocality,
        place.locality,
        place.administrativeArea,
      ].where((part) => (part ?? '').trim().isNotEmpty).join(', ');
    } catch (_) {
      // Reverse geocoding is best-effort — the GPS check-in itself already
      // succeeded, so a lookup failure here should not surface as an error.
    }
  }
}
