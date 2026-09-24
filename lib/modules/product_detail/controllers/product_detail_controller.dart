import 'package:get/get.dart';

import '../../../app/data/models/product_model.dart';

/// Read-only product detail for the salesman.
///
/// The product travels as a route argument from the card that was tapped, so
/// this screen never calls the API — the catalog list already holds every
/// field it shows. There is no cart or quantity here on purpose: a salesman
/// quotes prices and reviews dealer orders, they never place one.
class ProductDetailController extends GetxController {
  ProductModel get product => Get.arguments as ProductModel;

  /// Every pack size, or a single synthetic one built from the product's own
  /// figures when the ERP has no variant row for it — so the rate table is
  /// never empty.
  List<ProductVariantModel> get variants {
    if (product.variants.isNotEmpty) return product.variants;

    return [
      ProductVariantModel(
        id: 0,
        name: product.packSize,
        unitsPerCase: product.unitsPerCase,
        dealerPrice: product.dealerPrice,
        casePrice: product.casePrice > 0
            ? product.casePrice
            : product.dealerPrice * product.unitsPerCase,
        mrp: product.mrp,
        availableStock: product.availableStock,
        availableCases: product.availableCases,
      ),
    ];
  }
}
