import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/collections_controller.dart';

class CollectionsView
    extends GetView<CollectionsController> {
  const CollectionsView({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Obx(
      () => RefreshIndicator(
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
            const Text(
              'Payment Collection',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.w900,
                color:
                    AppColors.textPrimary,
              ),
            ),

            const SizedBox(
              height: 5,
            ),

            const Text(
              'Record a payment received from an assigned dealer.',
              style: TextStyle(
                fontSize: 11.5,
                color:
                    AppColors.textSecondary,
              ),
            ),

            const SizedBox(
              height: 18,
            ),

            Container(
              padding:
                  const EdgeInsets.all(
                16,
              ),
              decoration:
                  BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius
                        .circular(
                  18,
                ),
                border: Border.all(
                  color:
                      AppColors.border,
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  const Text(
                    'Dealer',
                    style:
                        TextStyle(
                      fontSize: 12,
                      fontWeight:
                          FontWeight
                              .w800,
                    ),
                  ),

                  const SizedBox(
                    height: 7,
                  ),

                  DropdownButtonFormField<
                      int>(
                    value: controller
                                .selectedDealerId
                                .value >
                            0
                        ? controller
                            .selectedDealerId
                            .value
                        : null,
                    isExpanded:
                        true,
                    hint: const Text(
                      'Select dealer',
                    ),
                    items: controller
                        .dealers
                        .map(
                      (dealer) {
                        return DropdownMenuItem<
                            int>(
                          value:
                              dealer.userId,
                          child:
                              Text(
                            dealer
                                .displayName,
                            maxLines:
                                1,
                            overflow:
                                TextOverflow
                                    .ellipsis,
                          ),
                        );
                      },
                    ).toList(),
                    onChanged:
                        (value) {
                      controller
                              .selectedDealerId
                              .value =
                          value ?? 0;
                    },
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  const Text(
                    'Amount',
                    style:
                        TextStyle(
                      fontSize: 12,
                      fontWeight:
                          FontWeight
                              .w800,
                    ),
                  ),

                  const SizedBox(
                    height: 7,
                  ),

                  TextField(
                    controller:
                        controller
                            .amountController,
                    keyboardType:
                        const TextInputType
                            .numberWithOptions(
                      decimal: true,
                    ),
                    decoration:
                        const InputDecoration(
                      hintText:
                          'Enter amount',
                      prefixText:
                          '₹ ',
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  const Text(
                    'Payment Mode',
                    style:
                        TextStyle(
                      fontSize: 12,
                      fontWeight:
                          FontWeight
                              .w800,
                    ),
                  ),

                  const SizedBox(
                    height: 7,
                  ),

                  DropdownButtonFormField<
                      String>(
                    value: controller
                        .paymentMode
                        .value,
                    items: const [
                      DropdownMenuItem(
                        value: 'cash',
                        child:
                            Text(
                          'Cash',
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'upi',
                        child:
                            Text(
                          'UPI',
                        ),
                      ),
                      DropdownMenuItem(
                        value:
                            'bank_transfer',
                        child:
                            Text(
                          'Bank Transfer',
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'cheque',
                        child:
                            Text(
                          'Cheque',
                        ),
                      ),
                    ],
                    onChanged:
                        (value) {
                      if (value !=
                          null) {
                        controller
                                .paymentMode
                                .value =
                            value;
                      }
                    },
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  const Text(
                    'Transaction Reference',
                    style:
                        TextStyle(
                      fontSize: 12,
                      fontWeight:
                          FontWeight
                              .w800,
                    ),
                  ),

                  const SizedBox(
                    height: 7,
                  ),

                  TextField(
                    controller:
                        controller
                            .transactionController,
                    decoration:
                        const InputDecoration(
                      hintText:
                          'Optional UPI / bank / cheque reference',
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  ElevatedButton.icon(
                    onPressed: controller
                            .isLoading
                            .value
                        ? null
                        : controller
                            .collect,
                    icon: controller
                            .isLoading
                            .value
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child:
                                CircularProgressIndicator(
                              strokeWidth:
                                  2,
                              color:
                                  Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons
                                .payments_outlined,
                          ),
                    label: Text(
                      controller
                              .isLoading
                              .value
                          ? 'Saving...'
                          : 'Collect Payment',
                    ),
                  ),
                ],
              ),
            ),

            if (controller.lastMessage
                .value.isNotEmpty) ...[
              const SizedBox(
                height: 16,
              ),

              Container(
                padding:
                    const EdgeInsets.all(
                  14,
                ),
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
                child: Row(
                  children: [
                    const Icon(
                      Icons
                          .check_circle_outline,
                      color:
                          AppColors.primary,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        controller
                            .lastMessage
                            .value,
                        style:
                            const TextStyle(
                          color:
                              AppColors
                                  .primaryDark,
                          fontWeight:
                              FontWeight
                                  .w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}