/// One line of an order, as the detail screen lists it.
class SalesmanOrderItemModel {
  const SalesmanOrderItemModel({
    required this.productName,
    required this.variantName,
    required this.imageUrl,
    required this.quantity,
    required this.packQuantity,
    required this.unitsPerCase,
    required this.unitPrice,
    required this.gstPercent,
    required this.lineTotal,
  });

  final String productName;

  /// Pack size the dealer ordered, e.g. "50 kg" — empty for products with
  /// no variants.
  final String variantName;

  /// `product_image_url`, attached server-side by OrderItemImageAttacher.
  /// Empty when the product has no image.
  final String imageUrl;

  /// Total units ordered — `packQuantity` × `unitsPerCase`. The dealer never
  /// types this; it is what leaves the warehouse.
  final double quantity;

  /// Number of **cases** ordered. This is the number the dealer actually
  /// chose, so it is what the apps show.
  final double packQuantity;

  /// How many units are in one case.
  final double unitsPerCase;

  /// Price of a single unit. Multiply by [unitsPerCase] for the case rate.
  final double unitPrice;

  final double gstPercent;

  final double lineTotal;

  /// Rate for one whole case, which is how dealers buy and how the cart and
  /// product pages already price these products.
  double get casePrice => unitPrice * (unitsPerCase <= 0 ? 1 : unitsPerCase);

  /// "2 cases × 10 units" — or "2 cases" when the case size is unknown
  /// (older rows, or a product with no variant).
  String get caseLabel {
    final cases = _trim(packQuantity <= 0 ? quantity : packQuantity);

    if (unitsPerCase <= 1) return '$cases ${_plural(packQuantity, 'case')}';

    return '$cases ${_plural(packQuantity, 'case')} × ${_trim(unitsPerCase)} units';
  }

  /// Total units behind [caseLabel], e.g. "20 units in total".
  String get totalUnitsLabel => '${_trim(quantity)} units';

  static String _trim(double value) => value == value.roundToDouble()
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(3);

  static String _plural(double count, String word) =>
      count == 1 ? word : '${word}s';

  factory SalesmanOrderItemModel.fromJson(Map<String, dynamic> json) {
    final rawProduct = json['product'];
    final product = rawProduct is Map
        ? Map<String, dynamic>.from(rawProduct)
        : <String, dynamic>{};

    final image = json['product_image_url']?.toString().trim() ?? '';

    return SalesmanOrderItemModel(
      productName: product['name']?.toString().trim() ?? '',
      variantName: json['variant_name']?.toString().trim() ?? '',
      imageUrl: image == 'null' ? '' : image,
      quantity: SalesmanOrderModel._asDouble(json['quantity']),
      packQuantity: SalesmanOrderModel._asDouble(json['pack_quantity']),
      unitsPerCase: SalesmanOrderModel._asDouble(json['units_per_case']),
      unitPrice: SalesmanOrderModel._asDouble(json['unit_price']),
      gstPercent: SalesmanOrderModel._asDouble(json['gst_percent']),
      lineTotal: SalesmanOrderModel._asDouble(json['line_total']),
    );
  }
}

class SalesmanOrderModel {
  const SalesmanOrderModel({
    required this.id,
    required this.orderNo,
    required this.dealerName,
    required this.contactPerson,
    required this.dealerMobile,
    required this.dealerAddress,
    required this.status,
    required this.availability,
    required this.availableOn,
    required this.subtotal,
    required this.gstTotal,
    required this.discountTotal,
    required this.grandTotal,
    required this.itemCount,
    required this.productSummary,
    required this.items,
    required this.notes,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.createdAt,
  });

  final int id;

  final String orderNo;

  /// The dealer's firm name when there is one, otherwise the account holder's
  /// own name.
  final String dealerName;

  /// The person to ask for — the name typed at checkout when the order has
  /// one, otherwise the dealer account holder. Empty only when the account
  /// itself has no name.
  final String contactPerson;

  /// Who to call about this order — the order's own contact mobile when the
  /// dealer typed one at checkout, otherwise the dealer account's mobile.
  /// Empty when neither is on record.
  final String dealerMobile;

  /// Full delivery address, e.g. "Plot 4, MIDC Road, Pune, Maharashtra - 411001".
  /// Falls back to just "City, State" on older orders that carry no address
  /// lines, and is empty when the order has no address at all.
  final String dealerAddress;

  final String status;

  /// The salesman's stock answer while the order is still in their review:
  /// `not_available`, `available_on`, or empty when they haven't answered.
  /// It is deliberately not part of [status] — the order does not move, and
  /// the salesman can still approve or cancel it afterwards.
  final String availability;

  /// When [availability] is `available_on`, the date and time the stock is
  /// expected. Null otherwise.
  final DateTime? availableOn;

  final double subtotal;

  final double gstTotal;

  final double discountTotal;

  final double grandTotal;

  final int itemCount;

  /// Every line of the order, for the detail screen. The list endpoint
  /// already eager-loads `items.product`, so this needs no second request.
  final List<SalesmanOrderItemModel> items;

  /// Free-text note the dealer or salesman left on the order.
  final String notes;

  /// "cod" today — the gateway is built but parked, so nothing else appears
  /// here yet.
  final String paymentMethod;

  final String paymentStatus;

  /// First couple of product names in the order, e.g. "Urea 50kg, DAP 25kg
  /// +1 more" — a compact stand-in for the full item list.
  final String productSummary;

  final String createdAt;

  bool get canForwardToAdmin => status == 'salesman_review';

  bool get canReject => status == 'salesman_review';

  /// The order date and time as "22-09-2026, 4:35 PM" for the card, or the
  /// raw API value when it isn't a parseable timestamp. Written by hand
  /// rather than with `intl`'s `DateFormat`, which this app does not depend on.
  String get orderDate {
    final parsed = DateTime.tryParse(createdAt);
    if (parsed == null) return createdAt;

    return formatDateTime(parsed);
  }

  /// When the stock is expected, e.g. "25-09-2026, 10:00 AM" — empty unless
  /// the salesman answered `available_on`.
  String get availableOnLabel =>
      availableOn == null ? '' : formatDateTime(availableOn!);

  /// "25-09-2026, 10:00 AM" in the device's own timezone — the same
  /// `dd-mm-yyyy` the rest of the app uses, plus the 12-hour clock. Written by
  /// hand rather than with `intl`'s `DateFormat`, which this app does not
  /// depend on.
  static String formatDateTime(DateTime value) {
    final local = value.toLocal();

    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');

    final hour24 = local.hour;
    final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    final meridiem = hour24 < 12 ? 'AM' : 'PM';

    return '$day-$month-${local.year}, $hour12:$minute $meridiem';
  }

  factory SalesmanOrderModel.fromJson(Map<String, dynamic> json) {
    final rawDealer = json['dealer'];

    final dealer = rawDealer is Map
        ? Map<String, dynamic>.from(rawDealer)
        : <String, dynamic>{};

    final rawProfile = dealer['dealer_profile'];

    final dealerProfile = rawProfile is Map
        ? Map<String, dynamic>.from(rawProfile)
        : <String, dynamic>{};

    final rawItems = json['items'];

    final items = rawItems is List
        ? rawItems
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList()
        : <Map<String, dynamic>>[];

    final productNames = items
        .map((item) {
          final rawProduct = item['product'];
          final product = rawProduct is Map
              ? Map<String, dynamic>.from(rawProduct)
              : <String, dynamic>{};
          return product['name']?.toString().trim() ?? '';
        })
        .where((name) => name.isNotEmpty)
        .toList();

    final line1 = json['address_line1']?.toString().trim() ?? '';
    final line2 = json['address_line2']?.toString().trim() ?? '';
    final city = json['city']?.toString().trim() ?? '';
    final state = json['state']?.toString().trim() ?? '';
    final pincode = json['pincode']?.toString().trim() ?? '';

    // Orders placed from the dealer app don't always carry a delivery
    // address, so fall back to the dealer account's own LGD location before
    // giving up and hiding the address row.
    final orderStreet = [
      line1,
      line2,
      city,
      state,
    ].where((part) => part.isNotEmpty).join(', ');

    final dealerStreet =
        [
              dealer['city_village'],
              dealer['subdistrict_name'],
              dealer['district_name'],
              dealer['state_name'],
            ]
            .map((part) => part?.toString().trim() ?? '')
            .where((part) => part.isNotEmpty)
            .join(', ');

    final street = orderStreet.isNotEmpty ? orderStreet : dealerStreet;

    final effectivePincode = orderStreet.isNotEmpty
        ? pincode
        : dealer['pincode']?.toString().trim() ?? '';

    final contactName = json['contact_name']?.toString().trim() ?? '';
    final contactMobile = json['contact_mobile']?.toString().trim() ?? '';
    final accountMobile = dealer['mobile']?.toString().trim() ?? '';

    final firmName = dealerProfile['firm_name']?.toString().trim() ?? '';

    final ownerName = dealer['name']?.toString().trim() ?? '';

    return SalesmanOrderModel(
      id: _asInt(json['id']),
      orderNo: json['order_no']?.toString() ?? '',
      dealerName: firmName.isNotEmpty ? firmName : ownerName,
      contactPerson: contactName.isNotEmpty ? contactName : ownerName,
      dealerMobile: contactMobile.isNotEmpty ? contactMobile : accountMobile,
      dealerAddress: street.isEmpty || effectivePincode.isEmpty
          ? street
          : '$street - $effectivePincode',
      status: json['status']?.toString() ?? '',
      availability: json['availability']?.toString().trim() ?? '',
      availableOn: DateTime.tryParse(json['available_on']?.toString() ?? ''),
      subtotal: _asDouble(json['subtotal']),
      gstTotal: _asDouble(json['gst_total']),
      discountTotal: _asDouble(json['discount_total']),
      grandTotal: _asDouble(json['grand_total']),
      itemCount: items.length,
      productSummary: _summarize(productNames),
      items: items.map(SalesmanOrderItemModel.fromJson).toList(),
      notes: json['notes']?.toString().trim() ?? '',
      paymentMethod: json['payment_method']?.toString().trim() ?? '',
      paymentStatus: json['payment_status']?.toString().trim() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  /// "Urea 50kg, DAP 25kg" for two or fewer products, or "Urea 50kg, DAP
  /// 25kg +1 more" beyond that. Empty when the order has no items loaded.
  static String _summarize(List<String> productNames) {
    if (productNames.isEmpty) return '';
    if (productNames.length <= 2) return productNames.join(', ');
    return '${productNames.take(2).join(', ')} +${productNames.length - 2} more';
  }

  static int _asInt(dynamic value) {
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _asDouble(dynamic value) {
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
