import 'package:get/get.dart';

import '../../../app/data/models/category_model.dart';
import '../../../app/data/models/product_model.dart';
import '../../../app/data/services/salesman_order_service.dart';
import '../../../app/localization/t.dart';

class ProductsController extends GetxController {
  final SalesmanOrderService _api = Get.find<SalesmanOrderService>();

  final products = <ProductModel>[].obs;

  final categories = <CategoryModel>[].obs;

  /// 0 is the rail's leading "All" entry.
  final selectedCategoryId = 0.obs;

  final isLoading = false.obs;

  final search = ''.obs;

  /// Category and search narrow the same in-memory list — [loadProducts]
  /// already pulls every page, so picking a category never refetches.
  List<ProductModel> get filteredProducts {
    final term = search.value.trim().toLowerCase();

    final categoryId = selectedCategoryId.value;

    return products.where((product) {
      if (categoryId > 0 && product.categoryId != categoryId) {
        return false;
      }

      if (term.isEmpty) {
        return true;
      }

      return product.name.toLowerCase().contains(term) ||
          product.sku.toLowerCase().contains(term) ||
          product.categoryName.toLowerCase().contains(term);
    }).toList();
  }

  @override
  void onReady() {
    super.onReady();

    loadCategories();
    loadProducts();
  }

  void selectCategory(int id) {
    selectedCategoryId.value = id;
  }

  Future<void> loadCategories() async {
    try {
      final response = await _api.categories();

      final rows = _extractCategoryRows(response);

      if (rows.isEmpty) {
        return;
      }

      categories.assignAll(
        rows
            .whereType<Map>()
            .map(
              (item) => CategoryModel.fromJson(Map<String, dynamic>.from(item)),
            )
            .where((category) => category.id > 0 && category.name.isNotEmpty),
      );
    } catch (_) {
      // The rail is a filter, not the screen's content — if categories fail
      // to load the product grid still works, so this stays silent.
      categories.clear();
    }
  }

  Future<void> loadProducts() async {
    if (isLoading.value) {
      return;
    }

    isLoading.value = true;

    try {
      final result = <ProductModel>[];

      var page = 1;

      while (true) {
        final response = await _api.products(page: page, perPage: 100);

        final paginator = _extractPaginator(response);

        final rows = paginator['data'];

        if (rows is! List) {
          break;
        }

        result.addAll(
          rows
              .whereType<Map>()
              .map(
                (item) =>
                    ProductModel.fromJson(Map<String, dynamic>.from(item)),
              )
              .where((product) => product.id > 0),
        );

        final lastPage =
            int.tryParse(paginator['last_page']?.toString() ?? '') ?? 1;

        if (page >= lastPage || rows.isEmpty) {
          break;
        }

        page++;
      }

      products.assignAll(result);
    } catch (error) {
      products.clear();

      Get.snackbar(
        t('common.products'),
        error.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Digs the category array out of the response, tolerating `data.categories`
  /// as well as a bare `data` list — the same keys the dealer app's parser
  /// accepts, so the two can't drift apart if the envelope ever changes.
  List<dynamic> _extractCategoryRows(dynamic source) {
    if (source is List) {
      return source;
    }

    if (source is! Map) {
      return const [];
    }

    for (final key in const ['categories', 'data', 'items']) {
      final value = source[key];

      if (value is List) {
        return value;
      }

      if (value is Map) {
        final nested = _extractCategoryRows(value);

        if (nested.isNotEmpty) {
          return nested;
        }
      }
    }

    return const [];
  }

  Map<String, dynamic> _extractPaginator(Map<String, dynamic> response) {
    final rawData = response['data'];

    if (rawData is Map) {
      final data = Map<String, dynamic>.from(rawData);

      final rawProducts = data['products'];

      if (rawProducts is Map) {
        return Map<String, dynamic>.from(rawProducts);
      }
    }

    return <String, dynamic>{};
  }
}
