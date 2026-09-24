import 'package:flutter/material.dart';

import '../config/api_config.dart';
import '../theme/app_colors.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
  });

  final String? imageUrl;

  final double? height;
  final double? width;

  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final url = _resolveUrl(imageUrl);

    if (url.isEmpty) {
      return _placeholder();
    }

    return Image.network(
      url,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return _placeholder();
      },
    );
  }

  String _resolveUrl(String? source) {
    var value = source?.trim() ?? '';

    if (value.isEmpty || value == 'null') {
      return '';
    }

    value = value.replaceAll('\\', '/');

    final apiUri = Uri.tryParse(ApiConfig.baseUrl);

    if (apiUri == null || apiUri.host.isEmpty) {
      return value;
    }

    final origin = '${apiUri.scheme}://${apiUri.authority}';

    final imageUri = Uri.tryParse(value);

    if (imageUri != null && imageUri.hasScheme && imageUri.host.isNotEmpty) {
      final isLocal =
          imageUri.host == 'localhost' ||
          imageUri.host == '127.0.0.1' ||
          imageUri.host == '10.0.2.2';

      if (isLocal) {
        return '$origin${imageUri.path}';
      }

      if (apiUri.scheme == 'https' &&
          imageUri.host == apiUri.host &&
          imageUri.scheme == 'http') {
        return '$origin${imageUri.path}';
      }

      return value;
    }

    return value.startsWith('/') ? '$origin$value' : '$origin/$value';
  }

  Widget _placeholder() {
    return Container(
      height: height,
      width: width,
      color: AppColors.primarySoft,
      alignment: Alignment.center,
      child: const Icon(
        Icons.inventory_2_outlined,
        color: AppColors.primary,
        size: 30,
      ),
    );
  }
}
