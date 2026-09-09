class SalesmanOrderModel {
  const SalesmanOrderModel({
    required this.id,
    required this.orderNo,
    required this.dealerName,
    required this.status,
    required this.grandTotal,
    required this.itemCount,
    required this.createdAt,
  });

  final int id;

  final String orderNo;

  final String dealerName;

  final String status;

  final double grandTotal;

  final int itemCount;

  final String createdAt;

  bool get canForwardToAdmin =>
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
      status:
          json['status']
                  ?.toString() ??
              '',
      grandTotal:
          _asDouble(
        json['grand_total'],
      ),
      itemCount:
          rawItems is List
              ? rawItems.length
              : 0,
      createdAt:
          json['created_at']
                  ?.toString() ??
              '',
    );
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