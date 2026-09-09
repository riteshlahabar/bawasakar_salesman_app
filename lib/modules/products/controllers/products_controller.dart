import 'package:get/get.dart';

import '../../../app/data/models/product_model.dart';
import '../../../app/data/services/salesman_order_service.dart';

class ProductsController
    extends GetxController {
  final SalesmanOrderService _api = Get.find<SalesmanOrderService>();

  final products =
      <ProductModel>[].obs;

  final isLoading = false.obs;

  final search = ''.obs;

  List<ProductModel>
      get filteredProducts {
    final term =
        search.value
            .trim()
            .toLowerCase();

    if (term.isEmpty) {
      return products.toList();
    }

    return products.where(
      (product) {
        return product.name
                .toLowerCase()
                .contains(term) ||
            product.sku
                .toLowerCase()
                .contains(term) ||
            product.categoryName
                .toLowerCase()
                .contains(term);
      },
    ).toList();
  }

  @override
  void onReady() {
    super.onReady();

    loadProducts();
  }

  Future<void> loadProducts() async {
    if (isLoading.value) {
      return;
    }

    isLoading.value = true;

    try {
      final result =
          <ProductModel>[];

      var page = 1;

      while (true) {
        final response =
            await _api.products(
          page: page,
          perPage: 100,
        );

        final paginator =
            _extractPaginator(
          response,
        );

        final rows =
            paginator['data'];

        if (rows is! List) {
          break;
        }

        result.addAll(
          rows
              .whereType<Map>()
              .map(
                (item) =>
                    ProductModel
                        .fromJson(
                  Map<String, dynamic>
                      .from(
                    item,
                  ),
                ),
              )
              .where(
                (product) =>
                    product.id > 0,
              ),
        );

        final lastPage =
            int.tryParse(
                  paginator[
                              'last_page']
                          ?.toString() ??
                      '',
                ) ??
                1;

        if (page >= lastPage ||
            rows.isEmpty) {
          break;
        }

        page++;
      }

      products.assignAll(
        result,
      );
    } catch (error) {
      products.clear();

      Get.snackbar(
        'Products',
        error
            .toString()
            .replaceFirst(
              'Exception: ',
              '',
            ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic>
      _extractPaginator(
    Map<String, dynamic> response,
  ) {
    final rawData =
        response['data'];

    if (rawData is Map) {
      final data =
          Map<String, dynamic>.from(
        rawData,
      );

      final rawProducts =
          data['products'];

      if (rawProducts is Map) {
        return Map<String, dynamic>.from(
          rawProducts,
        );
      }
    }

    return <String, dynamic>{};
  }
}