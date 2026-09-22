class SalesmanOrderModel {
  const SalesmanOrderModel({
    required this.id,
    required this.orderNo,
    required this.dealerName,
    required this.dealerAddress,
    required this.status,
    required this.grandTotal,
    required this.itemCount,
    required this.productSummary,
    required this.createdAt,
  });

  final int id;

  final String orderNo;

  final String dealerName;

  /// City + state the order ships to, e.g. "Pune, Maharashtra". Empty when
  /// the order carries no address (older orders, or not yet filled in).
  final String dealerAddress;

  final String status;

  final double grandTotal;

  final int itemCount;

  /// First couple of product names in the order, e.g. "Urea 50kg, DAP 25kg
  /// +1 more" — a compact stand-in for the full item list.
  final String productSummary;

  final String createdAt;

  bool get canForwardToAdmin =>
      status == 'salesman_review';

  bool get canReject =>
      status == 'salesman_review';

  factory SalesmanOrderModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawDealer =
        json['dealer'];

    final dealer = rawDealer is Map
        ? Map<String, dynamic>.from(
            rawDealer,
          )
        : <String, dynamic>{};

    final rawProfile =
        dealer['dealer_profile'];

    final dealerProfile =
        rawProfile is Map
            ? Map<String, dynamic>.from(
                rawProfile,
              )
            : <String, dynamic>{};

    final rawItems =
        json['items'];

    final items = rawItems is List
        ? rawItems.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList()
        : <Map<String, dynamic>>[];

    final productNames = items
        .map((item) {
          final rawProduct = item['product'];
          final product = rawProduct is Map ? Map<String, dynamic>.from(rawProduct) : <String, dynamic>{};
          return product['name']?.toString().trim() ?? '';
        })
        .where((name) => name.isNotEmpty)
        .toList();

    final city = json['city']?.toString().trim() ?? '';
    final state = json['state']?.toString().trim() ?? '';

    final firmName =
        dealerProfile['firm_name']
                ?.toString()
                .trim() ??
            '';

    final ownerName =
        dealer['name']
                ?.toString()
                .trim() ??
            '';

    return SalesmanOrderModel(
      id: _asInt(
        json['id'],
      ),
      orderNo:
          json['order_no']
                  ?.toString() ??
              '',
      dealerName:
          firmName.isNotEmpty
              ? firmName
              : ownerName,
      dealerAddress: [city, state].where((part) => part.isNotEmpty).join(', '),
      status:
          json['status']
                  ?.toString() ??
              '',
      grandTotal:
          _asDouble(
        json['grand_total'],
      ),
      itemCount: items.length,
      productSummary: _summarize(productNames),
      createdAt:
          json['created_at']
                  ?.toString() ??
              '',
    );
  }

  /// "Urea 50kg, DAP 25kg" for two or fewer products, or "Urea 50kg, DAP
  /// 25kg +1 more" beyond that. Empty when the order has no items loaded.
  static String _summarize(List<String> productNames) {
    if (productNames.isEmpty) return '';
    if (productNames.length <= 2) return productNames.join(', ');
    return '${productNames.take(2).join(', ')} +${productNames.length - 2} more';
  }

  static int _asInt(
    dynamic value,
  ) {
    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  static double _asDouble(
    dynamic value,
  ) {
    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }
}