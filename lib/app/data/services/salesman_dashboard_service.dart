import '../../config/api_config.dart';
import 'api_client.dart';

/// Dashboard summary and the salesman's assigned dealer list.
class SalesmanDashboardService {
  SalesmanDashboardService(this._client);

  final ApiClient _client;

  Future<Map<String, dynamic>> dashboard() =>
      _client.getJson(ApiConfig.dashboard);

  Future<Map<String, dynamic>> dealers({int page = 1, int perPage = 100}) {
    return _client.getJson(
      ApiConfig.dealers,
      query: {'page': page, 'per_page': perPage},
    );
  }

  Future<Map<String, dynamic>> notifications({int page = 1}) =>
      _client.getJson(ApiConfig.notifications, query: {'page': page});

  Future<Map<String, dynamic>> markNotificationsRead(List<int> ids) =>
      _client.postJson(ApiConfig.notificationsRead, {'ids': ids});
}
