import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/data/models/product_model.dart';
import '../../../../app/localization/t.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/product_image.dart';

/// Grid tile for a single dealer-price product in [ProductsView].
///
/// The salesman quotes to a dealer, who buys by the case — so the case is the
/// headline price here, with the MRP and the stock on hand under it. Tapping
/// the tile opens the full rate list for every pack size.
class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    // A GestureDetector, not an InkWell: the card paints its own opaque white
    // background, so a ripple would be hidden behind it.
    return GestureDetector(
      onTap: () =>
          Get.toNamed<void>(AppRoutes.productDetail, arguments: product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ProductImage(
                imageUrl: product.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.categoryName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 9.5,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (_packLine.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      _packLine,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),
                  _priceRow(),
                  const SizedBox(height: 6),
                  _stockPill(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// The case rate when the product is sold in cases, the unit rate when it is
  /// not — with the MRP struck through on its own line underneath.
  Widget _priceRow() {
    final headline = product.isCased ? product.casePrice : product.dealerPrice;
    final struck = product.isCased
        ? product.mrp * product.unitsPerCase
        : product.mrp;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Flexible(
              child: Text(
                '₹${_money(headline)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Text(
              product.isCased ? t('products.per_case') : t('products.per_unit'),
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        if (struck > headline)
          Text(
            '₹${_money(struck)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              decoration: TextDecoration.lineThrough,
            ),
          ),
      ],
    );
  }

  Widget _stockPill() {
    final inStock = product.isInStock;
    final color = inStock ? AppColors.success : AppColors.danger;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _stockLine,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  /// "1 L · 10 units/case" — either half is dropped when the API has no value
  /// for it, so a product with no variant row simply shows nothing here.
  String get _packLine {
    return [
      if (product.packSize.isNotEmpty) product.packSize,
      if (product.isCased)
        '${_qty(product.unitsPerCase)} ${t('products.units_per_case')}',
    ].join(' · ');
  }

  String get _stockLine {
    if (!product.isInStock) return t('products.out_of_stock');

    if (product.isCased && product.availableCases > 0) {
      return '${product.availableCases} ${t('products.cases_in_stock')}';
    }

    return '${_qty(product.availableStock)} ${t('products.in_stock')}';
  }

  /// Whole numbers read better bare on a card; a genuine paisa value keeps its
  /// two decimals rather than being rounded away.
  static String _money(double value) {
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(2);
  }

  static String _qty(double value) {
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(2);
  }
}
