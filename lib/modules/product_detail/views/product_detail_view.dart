import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/models/product_model.dart';
import '../../../app/localization/t.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_decorations.dart';
import '../../../app/widgets/drawer_menu_button.dart';
import '../../../app/widgets/product_image.dart';
import '../controllers/product_detail_controller.dart';

/// Everything the salesman needs to quote one product to a dealer.
///
/// Unlike the dealer and customer apps this screen has no cart, no quantity
/// stepper and no pack-size picker: the salesman does not buy, they read the
/// price list out. So **every** pack size is listed at once, each with its own
/// case rate, unit rate and stock, instead of one selected variant at a time.
class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    if (Get.arguments is! ProductModel) {
      return Scaffold(
        appBar: AppBar(
          title: Text(t('products.product_details')),
          leading: const DrawerMenuButton(),
        ),
        body: Center(child: Text(t('common.could_not_load'))),
      );
    }

    final product = controller.product;

    return Scaffold(
      appBar: AppBar(
        title: Text(t('products.product_details')),
        leading: const DrawerMenuButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          Container(
            height: 240,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: ProductImage(
              imageUrl: product.imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          if (product.categoryName.isNotEmpty)
            Text(
              product.categoryName,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          const SizedBox(height: 4),
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 20,
              height: 1.25,
              fontWeight: FontWeight.w900,
            ),
          ),
          if (product.shortDescription.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              product.shortDescription,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(height: 20),
          _sectionTitle(t('products.pack_sizes_dealer_rates')),
          const SizedBox(height: 8),
          for (final variant in controller.variants)
            _VariantCard(variant: variant),
          const SizedBox(height: 20),
          _sectionTitle(t('products.more_details')),
          const SizedBox(height: 4),
          _DetailRow(label: t('products.sku'), value: product.sku),
          _DetailRow(
            label: t('products.category'),
            value: product.categoryName,
          ),
          _DetailRow(label: t('products.unit'), value: product.unitName),
          _DetailRow(
            label: t('products.gst_rate'),
            value: '${_trim(product.gstPercent)}%',
          ),
          if (product.description.trim().isNotEmpty) ...[
            const SizedBox(height: 18),
            _sectionTitle(t('common.description')),
            const SizedBox(height: 7),
            Text(
              product.description,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ],
          if (product.additionalInfo.isNotEmpty) ...[
            const SizedBox(height: 18),
            _sectionTitle(t('products.additional_info')),
            const SizedBox(height: 4),
            for (final row in product.additionalInfo)
              _DetailRow(label: row.label, value: row.value),
          ],
          if (product.careInstructions.trim().isNotEmpty) ...[
            const SizedBox(height: 18),
            _sectionTitle(t('products.care_instructions')),
            const SizedBox(height: 7),
            Text(
              product.careInstructions,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ],
        ],
      ),
    );
  }

  static Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
    );
  }

  static String _trim(double value) {
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(2);
  }
}

/// One pack size: its case rate, what that case is made of, the unit rate and
/// the stock behind it.
class _VariantCard extends StatelessWidget {
  const _VariantCard({required this.variant});

  final ProductVariantModel variant;

  @override
  Widget build(BuildContext context) {
    final headline = variant.isCased ? variant.casePrice : variant.dealerPrice;
    final struck = variant.isCased ? variant.caseMrp : variant.mrp;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: AppDecorations.softCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      variant.name.isNotEmpty
                          ? variant.name
                          : t('products.standard_pack'),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (variant.isCased) ...[
                      const SizedBox(height: 3),
                      Text(
                        t('products.one_case_equals', {
                          'n': _trim(variant.unitsPerCase),
                          'size': variant.name,
                        }),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text.rich(
                    TextSpan(
                      text: '₹${_money(headline)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                      children: [
                        TextSpan(
                          text: variant.isCased
                              ? t('products.per_case')
                              : t('products.per_unit'),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (struck > headline)
                    Text(
                      '₹${_money(struck)}',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textSecondary,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _Figure(
                  label: t('products.dealer_unit_rate'),
                  value: '₹${_money(variant.dealerPrice)}',
                ),
              ),
              Expanded(
                child: _Figure(
                  label: t('products.mrp'),
                  value: '₹${_money(variant.mrp)}',
                ),
              ),
              Expanded(
                child: _Figure(
                  label: t('products.units_in_case'),
                  value: _trim(variant.unitsPerCase),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _stockPill(),
        ],
      ),
    );
  }

  Widget _stockPill() {
    final color = variant.isInStock ? AppColors.success : AppColors.danger;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _stockLine,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  /// Cases only — that is what a dealer orders in. The pack count behind it
  /// was shown in brackets at first and dropped at the user's request.
  ///
  /// Note for anyone adding to this line: `available_stock` is a **count of
  /// packs**, not a volume, and the product's `unit_name` ("Mililiter") is a
  /// single product-wide field that says nothing about a variant — putting the
  /// two together read as "200 Mililiter" on a 500 LTR pack.
  String get _stockLine {
    if (!variant.isInStock) return t('products.out_of_stock');

    if (!variant.isCased) {
      return '${_trim(variant.availableStock)} ${t('products.packs')} '
          '${t('products.in_stock')}';
    }

    return '${variant.availableCases} ${t('products.cases_in_stock')}';
  }

  static String _money(double value) {
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(2);
  }

  static String _trim(double value) {
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(2);
  }
}

/// A small label-over-value figure inside a variant card.
class _Figure extends StatelessWidget {
  const _Figure({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 10.5,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

/// One label/value line in "More Details" and "Additional Info".
class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    if (value.trim().isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
