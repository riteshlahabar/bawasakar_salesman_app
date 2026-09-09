class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.dealerPrice,
    required this.mrp,
    required this.gstPercent,
    this.categoryName = '',
    this.unitName = '',
    this.imageUrl,
  });

  final int id;

  final String name;
  final String sku;

  final double dealerPrice;
  final double mrp;

  final double gstPercent;

  final String categoryName;
  final String unitName;

  final String? imageUrl;

  factory ProductModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProductModel(
      id: _asInt(
        json['id'],
      ),
      name:
          json['name']
                  ?.toString() ??
              '',
      sku:
          json['sku']
                  ?.toString() ??
              '',
      dealerPrice:
          _asDouble(
        json['dealer_price'],
      ),
      mrp:
          _asDouble(
        json['mrp'],
      ),
      gstPercent:
          _asDouble(
        json['gst_percent'],
      ),
      categoryName:
          json['category_name']
                  ?.toString() ??
              '',
      unitName:
          json['unit_name']
                  ?.toString() ??
              '',
      imageUrl:
          _image(
        json,
      ),
    );
  }

  static String? _image(
    Map<String, dynamic> json,
  ) {
    final candidates = [
      json['image_url'],
      json['homepage_mobile_image_url'],
      json['homepage_image_url'],
    ];

    for (final candidate
        in candidates) {
      final value =
          candidate?.toString().trim() ??
              '';

      if (value.isNotEmpty &&
          value != 'null') {
        return value;
      }
    }

    return null;
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