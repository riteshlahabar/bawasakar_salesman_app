import '../../config/api_config.dart';
import 'api_client.dart';

/// Non-financial HR records: leave, company assets, holidays, shifts,
/// announcements, personal documents and performance reviews.
class SalesmanHrService {
  SalesmanHrService(this._client);

  final ApiClient _client;

  Future<Map<String, dynamic>> leaves({int page = 1}) =>
      _client.getJson(ApiConfig.leaves, query: {'page': page});

  Future<Map<String, dynamic>> applyLeave(Map<String, dynamic> payload) =>
      _client.postJson(ApiConfig.leaves, payload);

  Future<Map<String, dynamic>> leaveBalance() =>
      _client.getJson(ApiConfig.leaveBalance);

  Future<Map<String, dynamic>> assets({int page = 1}) =>
      _client.getJson(ApiConfig.assets, query: {'page': page});

  /// What the salesman can say about an asset they hold: `lost`, `damaged`
  /// or `return_request`. Only the first two move the asset's status — a
  /// return is confirmed by the admin.
  Future<Map<String, dynamic>> reportAsset({
    required int assetId,
    required String issue,
    String? remarks,
  }) {
    return _client.postJson('${ApiConfig.assets}/$assetId/report', {
      'issue': issue,
      if (remarks != null && remarks.trim().isNotEmpty)
        'remarks': remarks.trim(),
    });
  }

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

  Future<Map<String, dynamic>> tasks({String? status}) => _client.getJson(
    ApiConfig.tasks,
    query: {if (status != null && status.isNotEmpty) 'status': status},
  );

  Future<Map<String, dynamic>> updateTask(
    int id,
    Map<String, dynamic> payload,
  ) => _client.postJson(ApiConfig.taskUpdate(id), payload);

  Future<Map<String, dynamic>> skills() => _client.getJson(ApiConfig.skills);

  Future<Map<String, dynamic>> trainings() =>
      _client.getJson(ApiConfig.trainings);

  Future<Map<String, dynamic>> resignation() =>
      _client.getJson(ApiConfig.resignation);

  Future<Map<String, dynamic>> submitResignation(
    Map<String, dynamic> payload,
  ) => _client.postJson(ApiConfig.resignation, payload);
}
