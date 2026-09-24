import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_hr_service.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/status_filter_bar.dart';
import '../../../app/localization/t.dart';
import '../views/widgets/report_asset_sheet.dart';

/// Company assets issued to the signed-in salesman.
///
/// Issuing an asset stays an admin job — this screen never creates one. What
/// the salesman can do is report on an asset they hold: that it is lost or
/// damaged, or that they want to hand it back.
class AssetsController extends RemoteModuleController {
  AssetsController(this._api)
    : super(
        title: t('assets.salesman_assets'),
        subtitle: t('assets.company_assets_issued_to_you_laptop'),
        actionLabel: t('assets.report_issue'),
        actionIcon: Icons.report_gmailerrorred_outlined,
      );

  final SalesmanHrService _api;

  /// The three things a salesman may report. `return_request` is not a status
  /// — the server only stamps the request and leaves the asset issued until
  /// an admin confirms it was handed back.
  static const issueTypes = <String>['return_request', 'damaged', 'lost'];

  /// Which state is being listed; empty is "all".
  final statusFilter = ''.obs;

  /// The asset the report sheet is about, and what it says.
  final selectedAssetId = 0.obs;

  final selectedIssue = 'return_request'.obs;

  final remarksController = TextEditingController();

  final isSaving = false.obs;

  /// Every asset, kept so changing the filter re-maps what is already here
  /// rather than going back to the network. Only a chip change reads it —
  /// [load] always drops it first.
  List<Map<String, dynamic>>? _cache;

  /// Only an asset the salesman still holds can be reported on.
  List<Map<String, dynamic>> get reportableAssets => (_cache ?? [])
      .where((asset) => asset['status'] != 'returned')
      .toList();

  List<StatusFilterOption> get filterOptions => [
    (value: '', label: t('common.all')),
    (value: 'issued', label: t('assets.issued')),
    (value: 'returned', label: t('assets.returned')),
    (value: 'lost', label: t('assets.lost')),
    (value: 'damaged', label: t('assets.damaged')),
  ];

  @override
  void onClose() {
    remarksController.dispose();
    super.onClose();
  }

  /// A refresh must really go back to the server. Assets are issued by an
  /// admin, so a newly issued one is the one thing this screen cannot learn
  /// about any other way — reusing the cache here left a pull-to-refresh
  /// redrawing the same stale list.
  @override
  Future<void> load() {
    _cache = null;

    return super.load();
  }

  void selectStatus(String value) {
    if (statusFilter.value == value) return;

    statusFilter.value = value;
    _refilter();
  }

  /// Re-maps the assets already held for the newly picked chip. [fetch] finds
  /// the cache warm, so this never hits the network.
  Future<void> _refilter() async {
    final data = await fetch();

    rows.assignAll(data.rows);
    stats.assignAll(data.stats);
  }

  /// Opens the report form. `RemoteModuleView` wires this to the screen's
  /// primary button because [actionLabel] is set; a row's own tap opens the
  /// same sheet with that asset already chosen.
  @override
  void primaryAction({int? assetId}) {
    final holdings = reportableAssets;

    if (holdings.isEmpty) {
      Get.snackbar(
        t('assets.nothing_to_report'),
        t('assets.you_hold_no_asset_right_now'),
      );
      return;
    }

    selectedAssetId.value =
        assetId ?? ModuleRowMapper.toInt(holdings.first['id']);
    selectedIssue.value = issueTypes.first;
    remarksController.clear();

    Get.bottomSheet<void>(
      ReportAssetSheet(controller: this),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  String assetLabel(int assetId) {
    final match = (_cache ?? []).where(
      (asset) => ModuleRowMapper.toInt(asset['id']) == assetId,
    );

    if (match.isEmpty) return '#$assetId';

    final asset = match.first;
    final serial = asset['serial_no']?.toString() ?? '';
    final name = asset['asset_name']?.toString() ?? t('common.asset');

    return serial.isEmpty ? name : '$name ($serial)';
  }

  String issueLabel(String issue) => t('assets.issue_$issue');

  Future<void> submitReport() async {
    if (isSaving.value) return;

    if (selectedAssetId.value <= 0) {
      Get.snackbar(
        t('assets.asset_required'),
        t('assets.choose_the_asset_you_are_reporting'),
      );
      return;
    }

    isSaving.value = true;

    try {
      await _api.reportAsset(
        assetId: selectedAssetId.value,
        issue: selectedIssue.value,
        remarks: remarksController.text,
      );

      Get.back<void>();
      Get.snackbar(
        t('assets.report_sent'),
        t('assets.the_admin_can_now_see_your_report'),
      );

      await load();
    } catch (failure) {
      Get.snackbar(
        t('assets.report_not_sent'),
        failure.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isSaving.value = false;
    }
  }

  /// Every asset, not just the first page — the endpoint now paginates 20 at
  /// a time. Pages are capped so a bad `last_page` can never loop.
  Future<List<Map<String, dynamic>>> _allAssets() async {
    final all = <Map<String, dynamic>>[];

    for (var page = 1; page <= 50; page++) {
      final response = await _api.assets(page: page);
      final rows = ModuleRowMapper.listFrom(response, 'assets');

      all.addAll(rows);

      final paginator = ModuleRowMapper.mapFrom(response, 'assets');
      final lastPage = ModuleRowMapper.toInt(paginator['last_page']);

      if (rows.isEmpty || page >= (lastPage == 0 ? 1 : lastPage)) break;
    }

    return all;
  }

  @override
  Future<ModuleData> fetch() async {
    // Only the first load — and the one after a report — goes to the network;
    // changing the filter re-reads this list.
    final all = _cache ??= await _allAssets();

    final filter = statusFilter.value;
    final assets = filter.isEmpty
        ? all
        : all.where((asset) => asset['status'] == filter).toList();

    // The tiles count every asset, not the filtered ones: they are what the
    // chips are chosen from, so narrowing them with the chips would leave the
    // selected state reading its own count and every other one zero.
    final issued = all.where((a) => a['status'] == 'issued').length;
    final returned = all.where((a) => a['status'] == 'returned').length;

    return (
      rows: assets.map((asset) {
        final status = asset['status']?.toString() ?? 'issued';
        final assetId = ModuleRowMapper.toInt(asset['id']);
        final canReport = status != 'returned' && assetId > 0;

        return ModuleRowMapper.row(
          title: asset['asset_name']?.toString() ?? t('common.asset'),
          // The raw code (`sim`, `mobile`) read badly as a bare value.
          titleTrailing: ModuleRowMapper.statusLabel(
            asset['asset_type']?.toString() ?? '',
          ),
          subtitle: _detailLine(asset),
          trailing: '',
          icon: _iconFor(asset['asset_type']?.toString()),
          status: status,
          onTap: canReport ? () => primaryAction(assetId: assetId) : null,
        );
      }).toList(),
      stats: [
        ModuleRowMapper.stat(
          title: t('assets.issued'),
          value: issued.toString(),
          icon: Icons.inventory_2,
          color: AppColors.primary,
          subtitle: t('common.assets'),
        ),
        ModuleRowMapper.stat(
          title: t('assets.returned'),
          value: returned.toString(),
          icon: Icons.keyboard_return,
          color: AppColors.info,
          subtitle: t('common.assets'),
        ),
        ModuleRowMapper.stat(
          title: t('common.total'),
          value: all.length.toString(),
          icon: Icons.list_alt,
          color: AppColors.success,
          subtitle: t('common.records'),
        ),
      ],
    );
  }

  /// Serial, the dates that apply to this asset's state, its condition, and
  /// the salesman's own last report.
  String _detailLine(Map<String, dynamic> asset) {
    final serial = asset['serial_no']?.toString() ?? '';
    final issuedOn = asset['issued_on']?.toString() ?? '';
    final returnedOn = asset['returned_on']?.toString() ?? '';
    final requestedAt = asset['return_requested_at']?.toString() ?? '';
    final condition = asset['condition']?.toString() ?? '';
    final remarks = asset['salesman_remarks']?.toString() ?? '';

    return [
      if (serial.isNotEmpty) '${t('assets.serial')} $serial',
      if (issuedOn.isNotEmpty)
        '${t('assets.issued')} ${ModuleRowMapper.date(issuedOn)}',
      if (returnedOn.isNotEmpty)
        '${t('assets.returned')} ${ModuleRowMapper.date(returnedOn)}',
      if (returnedOn.isEmpty && requestedAt.isNotEmpty)
        '${t('assets.return_requested')} ${ModuleRowMapper.date(requestedAt)}',
      if (condition.isNotEmpty) condition,
      if (remarks.isNotEmpty) remarks,
    ].join(' • ');
  }

  IconData _iconFor(String? type) {
    return switch (type) {
      'mobile' => Icons.phone_android,
      'laptop' => Icons.laptop_mac,
      'sim' => Icons.sim_card,
      'vehicle' => Icons.two_wheeler,
      _ => Icons.work_outline,
    };
  }
}
