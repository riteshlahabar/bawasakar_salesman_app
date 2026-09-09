import 'package:get/get.dart';

import '../../../app/data/models/dealer_model.dart';
import '../../../app/data/services/salesman_dashboard_service.dart';

class DealersController
    extends GetxController {
  final SalesmanDashboardService _api = Get.find<SalesmanDashboardService>();

  final dealers =
      <DealerModel>[].obs;

  final isLoading = false.obs;

  final search = ''.obs;

  final errorMessage = ''.obs;

  List<DealerModel>
      get filteredDealers {
    final term =
        search.value
            .trim()
            .toLowerCase();

    if (term.isEmpty) {
      return dealers.toList();
    }

    return dealers.where(
      (dealer) {
        return dealer.displayName
                .toLowerCase()
                .contains(term) ||
            dealer.name
                .toLowerCase()
                .contains(term) ||
            dealer.dealerCode
                .toLowerCase()
                .contains(term) ||
            dealer.mobile
                .contains(term) ||
            dealer.location
                .toLowerCase()
                .contains(term);
      },
    ).toList();
  }

  @override
  void onReady() {
    super.onReady();

    loadDealers();
  }

  Future<void> loadDealers() async {
    if (isLoading.value) {
      return;
    }

    isLoading.value = true;

    errorMessage.value = '';

    try {
      final result =
          <DealerModel>[];

      var page = 1;

      while (true) {
        final response =
            await _api.dealers(
          page: page,
          perPage: 100,
        );

        final data =
            _extractPaginator(
          response,
          'dealers',
        );

        final rows =
            data['data'];

        if (rows is! List) {
          break;
        }

        result.addAll(
          rows
              .whereType<Map>()
              .map(
                (item) =>
                    DealerModel
                        .fromJson(
                  Map<String, dynamic>
                      .from(
                    item,
                  ),
                ),
              ),
        );

        final lastPage =
            int.tryParse(
                  data['last_page']
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

      dealers.assignAll(
        result,
      );
    } catch (error) {
      errorMessage.value =
          error.toString();

      dealers.clear();

      Get.snackbar(
        'Dealers',
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
    String key,
  ) {
    final rawData =
        response['data'];

    if (rawData is Map) {
      final data =
          Map<String, dynamic>.from(
        rawData,
      );

      final rawPaginator =
          data[key];

      if (rawPaginator is Map) {
        return Map<String, dynamic>.from(
          rawPaginator,
        );
      }
    }

    return <String, dynamic>{};
  }
}