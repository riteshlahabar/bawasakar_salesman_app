import '../../config/api_config.dart';
import 'api_client.dart';

/// Non-financial HR records: leave, company assets, holidays, shifts,
/// announcements, personal documents and performance reviews.
class SalesmanHrService {
  SalesmanHrService(this._client);

  final ApiClient _client;

  Future<Map<String, dynamic>> leaves() => _client.getJson(ApiConfig.leaves);

  Future<Map<String, dynamic>> applyLeave(Map<String, dynamic> payload) =>
      _client.postJson(ApiConfig.leaves, payload);

  Future<Map<String, dynamic>> leaveBalance() =>
      _client.getJson(ApiConfig.leaveBalance);

  Future<Map<String, dynamic>> assets() => _client.getJson(ApiConfig.assets);

  Future<Map<String, dynamic>> holidays({String? year}) => _client.getJson(
        ApiConfig.holidays,
        query: {if (year != null && year.isNotEmpty) 'year': year},
      );

  Future<Map<String, dynamic>> shifts() => _client.getJson(ApiConfig.shifts);

  Future<Map<String, dynamic>> announcements({int page = 1}) =>
      _client.getJson(ApiConfig.announcements, query: {'page': page});

  Future<Map<String, dynamic>> documents() =>
      _client.getJson(ApiConfig.documents);

  Future<Map<String, dynamic>> performance() =>
      _client.getJson(ApiConfig.performance);
}
