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

  Future<Map<String, dynamic>> attendance({String? month}) => _client.getJson(
        ApiConfig.attendance,
        query: <String, dynamic>{
          if (month != null && month.isNotEmpty) 'month': month,
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
