/// A catalog category, as returned by `GET /catalog/categories`.
///
/// Same shape as the dealer and customer apps' model, minus `assetPath` —
/// this app's [ProductImage] has no bundled-asset fallback.
class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.imageUrl,
  });

  final int id;
  final String name;
  final String slug;
  final String? imageUrl;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: _asInt(json['id']),
      name: json['name']?.toString() ?? json['category_name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? json['image']?.toString(),
    );
  }

  static int _asInt(dynamic value) =>
      int.tryParse(value?.toString() ?? '') ?? 0;
}
