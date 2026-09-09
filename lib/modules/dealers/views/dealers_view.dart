import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/models/dealer_model.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/dealers_controller.dart';

class DealersView
    extends GetView<DealersController> {
  const DealersView({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Obx(() {
      final dealers =
          controller.filteredDealers;

      return RefreshIndicator(
        onRefresh:
            controller.loadDealers,
        child: ListView(
          physics:
              const AlwaysScrollableScrollPhysics(),
          padding:
              const EdgeInsets.fromLTRB(
            16,
            10,
            16,
            110,
          ),
          children: [
            TextField(
              onChanged: (value) {
                controller.search.value =
                    value;
              },
              decoration:
                  const InputDecoration(
                hintText:
                    'Search assigned dealer...',
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
                    'Assigned Dealers',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight:
                          FontWeight
                              .w900,
                      color: AppColors
                          .textPrimary,
                    ),
                  ),
                ),

                Text(
                  '${dealers.length}',
                  style:
                      const TextStyle(
                    color:
                        AppColors.primary,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 12,
            ),

            if (controller
                    .isLoading.value &&
                dealers.isEmpty)
              const Padding(
                padding:
                    EdgeInsets.all(
                  30,
                ),
                child: Center(
                  child:
                      CircularProgressIndicator(),
                ),
              )
            else if (dealers.isEmpty)
              _empty()
            else
              ...dealers.map(
                _dealerCard,
              ),
          ],
        ),
      );
    });
  }

  Widget _dealerCard(
    DealerModel dealer,
  ) {
    final hasOutstanding =
        dealer.outstandingBalance >
            0;

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),
      padding:
          const EdgeInsets.all(
        15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        border: Border.all(
          color:
              AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration:
                    BoxDecoration(
                  color: AppColors
                      .primarySoft,
                  borderRadius:
                      BorderRadius
                          .circular(
                    14,
                  ),
                ),
                child:
                    const Icon(
                  Icons
                      .storefront_rounded,
                  color:
                      AppColors.primary,
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      dealer.displayName,
                      maxLines: 1,
                      overflow:
                          TextOverflow
                              .ellipsis,
                      style:
                          const TextStyle(
                        fontSize: 14,
                        fontWeight:
                            FontWeight
                                .w900,
                      ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    Text(
                      dealer.dealerCode,
                      style:
                          const TextStyle(
                        fontSize: 11,
                        color: AppColors
                            .textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration:
                    BoxDecoration(
                  color: hasOutstanding
                      ? AppColors
                          .danger
                          .withValues(
                            alpha:
                                .09,
                          )
                      : AppColors
                          .primarySoft,
                  borderRadius:
                      BorderRadius
                          .circular(
                    20,
                  ),
                ),
                child: Text(
                  hasOutstanding
                      ? 'Due'
                      : 'Clear',
                  style:
                      TextStyle(
                    fontSize: 10,
                    fontWeight:
                        FontWeight
                            .w800,
                    color: hasOutstanding
                        ? AppColors
                            .danger
                        : AppColors
                            .primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 13,
          ),

          if (dealer.name
              .trim()
              .isNotEmpty)
            _info(
              Icons
                  .person_outline,
              dealer.name,
            ),

          if (dealer.mobile
              .trim()
              .isNotEmpty)
            _info(
              Icons
                  .phone_outlined,
              dealer.mobile,
            ),

          if (dealer.location
              .trim()
              .isNotEmpty)
            _info(
              Icons
                  .location_on_outlined,
              dealer.location,
            ),

          const Divider(
            height: 24,
          ),

          Row(
            children: [
              Expanded(
                child: _amount(
                  'Credit',
                  dealer.creditLimit,
                  AppColors.primary,
                ),
              ),

              Expanded(
                child: _amount(
                  'Outstanding',
                  dealer
                      .outstandingBalance,
                  hasOutstanding
                      ? AppColors
                          .danger
                      : AppColors
                          .primary,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 12,
          ),

          SizedBox(
            width: double.infinity,
            child:
                OutlinedButton.icon(
              onPressed: () {
                Get.toNamed(
                  AppRoutes.visits,
                );
              },
              icon:
                  const Icon(
                Icons.route_outlined,
              ),
              label:
                  const Text(
                'Dealer Visit',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _info(
    IconData icon,
    String text,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 5,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color:
                AppColors.textSecondary,
          ),
          const SizedBox(
            width: 7,
          ),
          Expanded(
            child: Text(
              text,
              style:
                  const TextStyle(
                fontSize: 11,
                color: AppColors
                    .textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _amount(
    String title,
    double amount,
    Color color,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
              const TextStyle(
            fontSize: 10.5,
            color:
                AppColors.textSecondary,
          ),
        ),
        const SizedBox(
          height: 3,
        ),
        Text(
          '₹${amount.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 13,
            fontWeight:
                FontWeight.w900,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _empty() {
    return const Padding(
      padding:
          EdgeInsets.symmetric(
        vertical: 60,
      ),
      child: Column(
        children: [
          Icon(
            Icons
                .storefront_outlined,
            size: 52,
            color:
                AppColors.mutedGreen,
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            'No Assigned Dealers',
            style: TextStyle(
              fontWeight:
                  FontWeight.w800,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Admin has not assigned any dealer to this salesman yet.',
            textAlign:
                TextAlign.center,
            style: TextStyle(
              color: AppColors
                  .textSecondary,
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }
}