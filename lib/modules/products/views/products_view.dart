import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/widgets/drawer_menu_button.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/products_controller.dart';
import 'widgets/category_menu.dart';
import 'widgets/product_card.dart';
import '../../../app/localization/t.dart';

class ProductsView extends GetView<ProductsController> {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t('products.dealer_products')),
        leading: const DrawerMenuButton(),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            child: TextField(
              onChanged: (value) => controller.search.value = value,
              decoration: InputDecoration(
                hintText: t('products.search_product_sku_category'),
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // `.toList()` matters: Obx only tracks observables read
                // inside its own closure, and CategoryMenu reads the list in
                // its own build() — passing the RxList straight through would
                // register nothing and the rail would never rebuild.
                Obx(() {
                  final categories = controller.categories.toList();

                  return CategoryMenu(
                    categories: categories,
                    selectedCategoryId: controller.selectedCategoryId.value,
                    onCategorySelected: controller.selectCategory,
                  );
                }),
                Expanded(child: Obx(() => _productArea())),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _productArea() {
    final products = controller.filteredProducts;

    if (controller.isLoading.value && products.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: controller.loadProducts,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      t('products.dealer_price_catalog'),
                      style: const TextStyle(
                        fontSize: 15,
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
            ),
          ),
          if (products.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Center(child: Text(t('products.no_products_available'))),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 24),
              sliver: SliverGrid.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  // The card carries pack size, case rate, the struck MRP and
                  // a stock pill under the image, so it needs more height than
                  // the old name-and-price tile did.
                  childAspectRatio: .60,
                ),
                itemBuilder: (_, index) {
                  return ProductCard(product: products[index]);
                },
              ),
            ),
        ],
      ),
    );
  }
}
