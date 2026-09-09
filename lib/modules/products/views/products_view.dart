import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/models/product_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/product_image.dart';
import '../controllers/products_controller.dart';

class ProductsView
    extends GetView<ProductsController> {
  const ProductsView({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text(
          'Dealer Products',
        ),
      ),
      body: Obx(() {
        final products =
            controller.filteredProducts;

        return RefreshIndicator(
          onRefresh:
              controller.loadProducts,
          child: ListView(
            physics:
                const AlwaysScrollableScrollPhysics(),
            padding:
                const EdgeInsets.fromLTRB(
              16,
              10,
              16,
              30,
            ),
            children: [
              TextField(
                onChanged: (value) {
                  controller
                      .search.value = value;
                },
                decoration:
                    const InputDecoration(
                  hintText:
                      'Search product, SKU, category...',
                  prefixIcon: Icon(
                    Icons.search_rounded,
                  ),
                ),
              ),

              const SizedBox(
                height: 16,
              ),

              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Dealer Price Catalog',
                      style:
                          TextStyle(
                        fontSize: 17,
                        fontWeight:
                            FontWeight
                                .w900,
                      ),
                    ),
                  ),

                  Text(
                    '${products.length}',
                    style:
                        const TextStyle(
                      color: AppColors
                          .primary,
                      fontWeight:
                          FontWeight
                              .w900,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 12,
              ),

              if (controller
                      .isLoading.value &&
                  products.isEmpty)
                const Padding(
                  padding:
                      EdgeInsets.all(
                    40,
                  ),
                  child: Center(
                    child:
                        CircularProgressIndicator(),
                  ),
                )
              else if (products.isEmpty)
                const Padding(
                  padding:
                      EdgeInsets.all(
                    40,
                  ),
                  child: Center(
                    child: Text(
                      'No products available.',
                    ),
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  itemCount:
                      products.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing:
                        12,
                    mainAxisSpacing:
                        12,
                    childAspectRatio:
                        .66,
                  ),
                  itemBuilder:
                      (_, index) {
                    return _ProductCard(
                      product:
                          products[index],
                    );
                  },
                ),
            ],
          ),
        );
      }),
    );
  }
}

class _ProductCard
    extends StatelessWidget {
  const _ProductCard({
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          16,
        ),
        border: Border.all(
          color:
              AppColors.border,
        ),
      ),
      clipBehavior:
          Clip.antiAlias,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Expanded(
            child:
                ProductImage(
              imageUrl:
                  product.imageUrl,
              width:
                  double.infinity,
              fit:
                  BoxFit.cover,
            ),
          ),

          Padding(
            padding:
                const EdgeInsets.all(
              10,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  product
                      .categoryName,
                  maxLines: 1,
                  overflow:
                      TextOverflow
                          .ellipsis,
                  style:
                      const TextStyle(
                    color: AppColors
                        .textSecondary,
                    fontSize: 9.5,
                  ),
                ),

                const SizedBox(
                  height: 3,
                ),

                Text(
                  product.name,
                  maxLines: 2,
                  overflow:
                      TextOverflow
                          .ellipsis,
                  style:
                      const TextStyle(
                    fontSize: 12,
                    height: 1.2,
                    fontWeight:
                        FontWeight
                            .w800,
                  ),
                ),

                const SizedBox(
                  height: 7,
                ),

                Row(
                  children: [
                    Text(
                      '₹${product.dealerPrice.toStringAsFixed(0)}',
                      style:
                          const TextStyle(
                        color:
                            AppColors
                                .primary,
                        fontSize: 14,
                        fontWeight:
                            FontWeight
                                .w900,
                      ),
                    ),

                    if (product.mrp >
                        product
                            .dealerPrice) ...[
                      const SizedBox(
                        width: 6,
                      ),

                      Text(
                        '₹${product.mrp.toStringAsFixed(0)}',
                        style:
                            const TextStyle(
                          color: AppColors
                              .textSecondary,
                          fontSize: 10,
                          decoration:
                              TextDecoration
                                  .lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  'SKU: ${product.sku}',
                  maxLines: 1,
                  overflow:
                      TextOverflow
                          .ellipsis,
                  style:
                      const TextStyle(
                    fontSize: 9.5,
                    color: AppColors
                        .textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}