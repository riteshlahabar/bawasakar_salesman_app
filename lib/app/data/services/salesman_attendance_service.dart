import '../../config/api_config.dart';
import 'api_client.dart';

/// GPS attendance, dealer visits and tour plans.
class SalesmanAttendanceService {
  SalesmanAttendanceService(this._client);

  final ApiClient _client;

  Future<Map<String, dynamic>> checkIn({
    required double latitude,
    required double longitude,
  }) {
    return _client.postJson(ApiConfig.checkIn, {
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  Future<Map<String, dynamic>> checkOut({
    required double latitude,
    required double longitude,
  }) {
    return _client.postJson(ApiConfig.checkOut, {
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  /// Starts a break on today's attendance log. GPS is optional here — unlike
  /// check-in/out, the server does not require it.
  Future<Map<String, dynamic>> startBreak({
    double? latitude,
    double? longitude,
  }) {
    return _client.postJson(ApiConfig.startBreak, {
      'latitude': ?latitude,
      'longitude': ?longitude,
    });
  }

  Future<Map<String, dynamic>> resumeBreak({
    double? latitude,
    double? longitude,
  }) {
    return _client.postJson(ApiConfig.resumeBreak, {
      'latitude': ?latitude,
      'longitude': ?longitude,
    });
  }

  /// The attendance sheet. `from`+`to` (`YYYY-MM-DD`) ask for an explicit
  /// range and win over `month` (`YYYY-MM`) server-side; sending neither gives
  /// the current month.
  Future<Map<String, dynamic>> attendance({
    String? month,
    String? from,
    String? to,
  }) => _client.getJson(
    ApiConfig.attendance,
    query: <String, dynamic>{
      if (month != null && month.isNotEmpty) 'month': month,
      if (from != null && from.isNotEmpty) 'from': from,
      if (to != null && to.isNotEmpty) 'to': to,
    },
  );

  Future<Map<String, dynamic>> visits({int page = 1}) =>
      _client.getJson(ApiConfig.visits, query: {'page': page});

  Future<Map<String, dynamic>> saveVisit({
    required int dealerId,
    String? purpose,
    String? remarks,
    double? latitude,
    double? longitude,
  }) {
    return _client.postJson(ApiConfig.visits, {
      'dealer_id': dealerId,
      if (purpose != null && purpose.trim().isNotEmpty)
        'purpose': purpose.trim(),
      if (remarks != null && remarks.trim().isNotEmpty)
        'remarks': remarks.trim(),
      'latitude': ?latitude,
      'longitude': ?longitude,
    });
  }

  Future<Map<String, dynamic>> tourPlans() =>
      _client.getJson(ApiConfig.tourPlans);
}
