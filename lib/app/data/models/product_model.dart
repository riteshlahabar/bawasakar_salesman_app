/// One pack size of a product, with what it costs the dealer.
///
/// The salesman quotes by the case, so [casePrice] — not [dealerPrice] — is
/// the figure that gets read out; the unit rate is kept alongside it because
/// the ERP prices the unit and multiplies up.
class ProductVariantModel {
  const ProductVariantModel({
    required this.id,
    required this.name,
    required this.unitsPerCase,
    required this.dealerPrice,
    required this.casePrice,
    required this.mrp,
    required this.availableStock,
    required this.availableCases,
  });

  final int id;
  final String name;

  final double unitsPerCase;
  final double dealerPrice;
  final double casePrice;
  final double mrp;

  final double availableStock;
  final int availableCases;

  /// The MRP of a whole case, so it can be struck through beside [casePrice].
  double get caseMrp => mrp * unitsPerCase;

  bool get isCased => unitsPerCase > 1;

  bool get isInStock => availableStock > 0;

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    final perCase = ProductModel._asDouble(json['units_per_case']);

    return ProductVariantModel(
      id: ProductModel._asInt(json['id']),
      name: json['name']?.toString() ?? '',
      unitsPerCase: perCase <= 0 ? 1 : perCase,
      dealerPrice: ProductModel._asDouble(json['dealer_price']),
      casePrice: ProductModel._asDouble(json['dealer_case_price']),
      mrp: ProductModel._asDouble(json['mrp']),
      availableStock: ProductModel._asDouble(json['available_stock']),
      availableCases: ProductModel._asInt(json['available_cases']),
    );
  }
}

/// One label/value line of a product's "Additional Info" table.
class ProductInfoRow {
  const ProductInfoRow({required this.label, required this.value});

  final String label;
  final String value;
}

class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.dealerPrice,
    required this.mrp,
    required this.gstPercent,
    this.categoryId = 0,
    this.categoryName = '',
    this.unitName = '',
    this.packSize = '',
    this.unitsPerCase = 1,
    this.casePrice = 0,
    this.availableStock = 0,
    this.availableCases = 0,
    this.variants = const [],
    this.description = '',
    this.shortDescription = '',
    this.additionalInfo = const [],
    this.careInstructions = '',
    this.imageUrl,
  });

  final int id;

  final String name;
  final String sku;

  final double dealerPrice;
  final double mrp;

  final double gstPercent;

  final int categoryId;
  final String categoryName;
  final String unitName;

  /// The main variant's display name — the pack the dealer buys ("1 L",
  /// "50 kg"). Empty when the product has no variant row.
  final String packSize;

  /// How many units make one case, and what that case costs the dealer. The
  /// dealer orders in cases, so this is the number that matters on the card.
  final double unitsPerCase;
  final double casePrice;

  /// Stock of the main variant, in units and in whole cases.
  final double availableStock;
  final int availableCases;

  /// Every active pack size the API sent, in its own order — the detail
  /// screen lists all of them with their own case rates, since a salesman is
  /// asked for the whole price list, not one pack.
  final List<ProductVariantModel> variants;

  final String description;
  final String shortDescription;

  final List<ProductInfoRow> additionalInfo;
  final String careInstructions;

  final String? imageUrl;

  bool get isInStock => availableStock > 0;

  /// True only when a case is more than one unit — a product sold singly
  /// should not claim a case rate.
  bool get isCased => unitsPerCase > 1;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final variant = _mainVariant(json);

    return ProductModel(
      id: _asInt(json['id']),
      name: json['name']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      dealerPrice: _asDouble(variant?['dealer_price'] ?? json['dealer_price']),
      mrp: _asDouble(variant?['mrp'] ?? json['mrp']),
      gstPercent: _asDouble(json['gst_percent']),
      categoryId: _asInt(json['category_id']),
      categoryName: json['category_name']?.toString() ?? '',
      unitName: json['unit_name']?.toString() ?? '',
      packSize: variant?['name']?.toString() ?? '',
      unitsPerCase: _asDouble(variant?['units_per_case']) <= 0
          ? 1
          : _asDouble(variant?['units_per_case']),
      casePrice: _asDouble(variant?['dealer_case_price']),
      availableStock: _asDouble(variant?['available_stock']),
      availableCases: _asInt(variant?['available_cases']),
      variants: _variants(json),
      description: json['description']?.toString() ?? '',
      shortDescription: json['short_description']?.toString() ?? '',
      additionalInfo: _additionalInfo(json),
      careInstructions: json['care_instructions']?.toString() ?? '',
      imageUrl: _image(json),
    );
  }

  static List<ProductVariantModel> _variants(Map<String, dynamic> json) {
    final raw = json['variants'];
    if (raw is! List) return const [];

    return raw
        .whereType<Map<String, dynamic>>()
        .map(ProductVariantModel.fromJson)
        .toList();
  }

  static List<ProductInfoRow> _additionalInfo(Map<String, dynamic> json) {
    final raw = json['additional_info'];
    if (raw is! List) return const [];

    return raw
        .whereType<Map>()
        .map(
          (row) => ProductInfoRow(
            label: row['label']?.toString().trim() ?? '',
            value: row['value']?.toString().trim() ?? '',
          ),
        )
        .where((row) => row.label.isNotEmpty || row.value.isNotEmpty)
        .toList();
  }

  /// The variant the API flags as `main_variant_id`, falling back to the first
  /// one it sends. Pricing and stock live on the variant, not on the product —
  /// this app used to drop the whole array and show only the product-level
  /// price, which is why cases and stock never appeared.
  static Map<String, dynamic>? _mainVariant(Map<String, dynamic> json) {
    final raw = json['variants'];
    if (raw is! List) return null;

    final variants = raw.whereType<Map<String, dynamic>>().toList();
    if (variants.isEmpty) return null;

    final mainId = _asInt(json['main_variant_id']);
    final match = variants.where((v) => _asInt(v['id']) == mainId);

    return match.isNotEmpty ? match.first : variants.first;
  }

  static String? _image(Map<String, dynamic> json) {
    final candidates = [
      json['image_url'],
      json['homepage_mobile_image_url'],
      json['homepage_image_url'],
    ];

    for (final candidate in candidates) {
      final value = candidate?.toString().trim() ?? '';

      if (value.isNotEmpty && value != 'null') {
        return value;
      }
    }

    return null;
  }

  static int _asInt(dynamic value) {
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _asDouble(dynamic value) {
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
