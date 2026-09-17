import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/products_controller.dart';
import 'widgets/product_card.dart';
import '../../../app/localization/t.dart';

class ProductsView extends GetView<ProductsController> {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('products.dealer_products'))),
      body: Obx(() {
        final products = controller.filteredProducts;

        return RefreshIndicator(
          onRefresh: controller.loadProducts,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
            children: [
              TextField(
                onChanged: (value) => controller.search.value = value,
                decoration: InputDecoration(
                  hintText: t('products.search_product_sku_category'),
                  prefixIcon: Icon(Icons.search_rounded),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      t('products.dealer_price_catalog'),
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Text(
                    '${products.length}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (controller.isLoading.value && products.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (products.isEmpty)
                Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: Text(t('products.no_products_available'))),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: .66,
                      ),
                  itemBuilder: (_, index) {
                    return ProductCard(product: products[index]);
                  },
                ),
            ],
          ),
        );
      }),
    );
  }
}
