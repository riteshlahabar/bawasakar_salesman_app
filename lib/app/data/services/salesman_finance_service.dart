import '../../config/api_config.dart';
import 'api_client.dart';

/// Money the salesman collects, claims or is paid: collections, expenses,
/// salary, payslips, advances, loans, incentives and targets.
class SalesmanFinanceService {
  SalesmanFinanceService(this._client);

  final ApiClient _client;

  Future<Map<String, dynamic>> collectPayment({
    required int dealerId,
    required String paymentMode,
    required double amount,
    int? orderId,
    String? transactionRef,
  }) {
    return _client.postJson(ApiConfig.collections, {
      'dealer_id': dealerId,
      'payment_mode': paymentMode,
      'amount': amount,
      if (orderId != null && orderId > 0) 'order_id': orderId,
      if (transactionRef != null && transactionRef.trim().isNotEmpty)
        'transaction_ref': transactionRef.trim(),
    });
  }

  Future<Map<String, dynamic>> expenses({int page = 1}) =>
      _client.getJson(ApiConfig.expenses, query: {'page': page});

  Future<Map<String, dynamic>> submitExpense(Map<String, dynamic> payload) =>
      _client.postJson(ApiConfig.expenses, payload);

  Future<Map<String, dynamic>> salary() => _client.getJson(ApiConfig.salary);

  Future<Map<String, dynamic>> targets({int page = 1}) =>
      _client.getJson(ApiConfig.targets, query: {'page': page});

  Future<Map<String, dynamic>> payslips({String? year}) => _client.getJson(
    ApiConfig.payslips,
    query: {if (year != null && year.isNotEmpty) 'year': year},
  );

  Future<Map<String, dynamic>> payslip(int id) =>
      _client.getJson(ApiConfig.payslip(id));

  /// Advances and loans are the same `salary_advances` table, told apart by
  /// `advance_type`. Both paths reach the same controller method, which reads
  /// `?type=` and **defaults to `advance`** — so the type must always be sent
  /// explicitly. Without it the loans call silently returned the advances
  /// again, which listed every advance twice and doubled the totals.
  Future<Map<String, dynamic>> advances() =>
      _client.getJson(ApiConfig.advances, query: {'type': 'advance'});

  Future<Map<String, dynamic>> loans() =>
      _client.getJson(ApiConfig.loans, query: {'type': 'loan'});

  Future<Map<String, dynamic>> requestAdvance(Map<String, dynamic> payload) =>
      _client.postJson(ApiConfig.advances, payload);

  Future<Map<String, dynamic>> incentives({String? year}) => _client.getJson(
    ApiConfig.incentives,
    query: {if (year != null && year.isNotEmpty) 'year': year},
  );

  Future<Map<String, dynamic>> salaryRevisions() =>
      _client.getJson(ApiConfig.salaryRevisions);

  Future<Map<String, dynamic>> invoices() =>
      _client.getJson(ApiConfig.invoices);
}
