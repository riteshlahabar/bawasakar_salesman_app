import '../../config/api_config.dart';
import 'api_client.dart';

/// Order capture, forwarding and the dealer-priced product catalogue.
class SalesmanOrderService {
  SalesmanOrderService(this._client);

  final ApiClient _client;

  Future<Map<String, dynamic>> orders({
    int page = 1,
    int perPage = 100,
  }) {
    return _client.getJson(
      ApiConfig.orders,
      query: {'page': page, 'per_page': perPage},
    );
  }

  Future<Map<String, dynamic>> createDealerOrder({
    required int dealerId,
    required List<Map<String, dynamic>> items,
    String? notes,
  }) {
    return _client.postJson(ApiConfig.orders, {
      'dealer_id': dealerId,
      'items': items,
      if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
    });
  }

  Future<Map<String, dynamic>> forwardOrderToAdmin(int orderId) =>
      _client.postJson(ApiConfig.forwardOrder(orderId), const {});

  Future<Map<String, dynamic>> rejectOrder(int orderId, String reason) =>
      _client.postJson(ApiConfig.rejectOrder(orderId), {'reason': reason});

  Future<Map<String, dynamic>> deliveries() =>
      _client.getJson(ApiConfig.deliveries);

  Future<Map<String, dynamic>> products({
    int page = 1,
    int perPage = 100,
    String? search,
    int? categoryId,
  }) {
    return _client.getJson(ApiConfig.products, query: {
      'audience': 'dealer',
      'page': page,
      'per_page': perPage,
      if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      if (categoryId != null && categoryId > 0) 'category_id': categoryId,
    });
  }
}
