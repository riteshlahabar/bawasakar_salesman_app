import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/models/action_item_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_decorations.dart';
import '../../../app/widgets/section_header.dart';
import '../../../app/widgets/summary_card.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView
    extends GetView<DashboardController> {
  const DashboardView({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Obx(
      () => RefreshIndicator(
        onRefresh:
            controller.loadDashboard,
        child: ListView(
          physics:
              const AlwaysScrollableScrollPhysics(),
          padding:
              const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            110,
          ),
          children: [
            Text(
              'Hey ${controller.salesmanName.value},',
              style: const TextStyle(
                color:
                    AppColors.textSecondary,
                fontSize: 13,
                fontWeight:
                    FontWeight.w600,
              ),
            ),

            const SizedBox(
              height: 4,
            ),

            const Text(
              'Welcome Back',
              style: TextStyle(
                color:
                    AppColors.textPrimary,
                fontSize: 19,
                fontWeight:
                    FontWeight.w900,
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            _overviewCard(),

            const SizedBox(
              height: 22,
            ),

            const SectionHeader(
              title: 'Operations',
            ),

            const SizedBox(
              height: 14,
            ),

            SingleChildScrollView(
              scrollDirection:
                  Axis.horizontal,
              child: Row(
                children:
                    controller.operations
                        .map(
                          (item) =>
                              _OperationButton(
                            item:
                                item,
                          ),
                        )
                        .toList(),
              ),
            ),

            const SizedBox(
              height: 22,
            ),

            const SectionHeader(
              title: 'Performance',
            ),

            const SizedBox(
              height: 14,
            ),

            if (controller
                .isLoading.value)
              const Padding(
                padding:
                    EdgeInsets.all(
                  20,
                ),
                child: Center(
                  child:
                      CircularProgressIndicator(),
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                itemCount:
                    controller
                        .summaries
                        .length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing:
                      12,
                  mainAxisSpacing:
                      12,
                  mainAxisExtent:
                      144,
                ),
                itemBuilder:
                    (context, index) {
                  return SummaryCard(
                    item: controller
                            .summaries[
                        index],
                  );
                },
              ),

            const SizedBox(
              height: 18,
            ),

            Container(
              decoration:
                  AppDecorations
                      .softCard(
                radius: 16,
              ),
              padding:
                  const EdgeInsets.all(
                16,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  const Text(
                    'Quick Status',
                    style: TextStyle(
                      color: AppColors
                          .textPrimary,
                      fontSize: 16,
                      fontWeight:
                          FontWeight
                              .w900,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  ...controller.quickStats
                      .map(
                    (item) => Padding(
                      padding:
                          const EdgeInsets
                              .only(
                        bottom: 11,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons
                                .check_circle,
                            color:
                                AppColors
                                    .success,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child:
                                Text(
                              item,
                              style:
                                  const TextStyle(
                                fontSize:
                                    11,
                                fontWeight:
                                    FontWeight
                                        .w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _overviewCard() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(
        20,
      ),
      decoration: BoxDecoration(
        gradient:
            const LinearGradient(
          begin:
              Alignment.topLeft,
          end:
              Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
          ],
        ),
        borderRadius:
            BorderRadius.circular(
          24,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary
                .withValues(
              alpha: .22,
            ),
            blurRadius: 20,
            offset:
                const Offset(
              0,
              10,
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'Today Collection',
            style: TextStyle(
              color: Colors.white
                  .withValues(
                alpha: .80,
              ),
              fontSize: 12,
              fontWeight:
                  FontWeight.w600,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          Text(
            '₹${controller.todayCollections.value.toStringAsFixed(0)}',
            style:
                const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight:
                  FontWeight.w900,
            ),
          ),

          const SizedBox(
            height: 24,
          ),

          Row(
            children: [
              Expanded(
                child: Text(
                  controller.territory
                          .value
                          .trim()
                          .isEmpty
                      ? 'Sales Territory'
                      : controller
                          .territory
                          .value,
                  style: TextStyle(
                    color: Colors
                        .white
                        .withValues(
                      alpha: .82,
                    ),
                    fontWeight:
                        FontWeight
                            .w700,
                  ),
                ),
              ),

              Text(
                controller.employeeCode
                        .value
                        .trim()
                        .isEmpty
                    ? 'Salesman'
                    : controller
                        .employeeCode
                        .value,
                style: TextStyle(
                  color: Colors.white
                      .withValues(
                    alpha: .82,
                  ),
                  fontWeight:
                      FontWeight
                          .w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OperationButton
    extends StatelessWidget {
  const _OperationButton({
    required this.item,
  });

  final ActionItemModel item;

  @override
  Widget build(
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () =>
          Get.toNamed(
        item.route,
      ),
      child: Container(
        width: 88,
        margin:
            const EdgeInsets.only(
          right: 12,
        ),
        padding:
            const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 8,
        ),
        decoration:
            AppDecorations.softCard(
          radius: 18,
        ),
        child: Column(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration:
                  AppDecorations.iconBox(
                item.color,
              ),
              child: Icon(
                item.icon,
                color: item.color,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            Text(
              item.title,
              maxLines: 1,
              overflow:
                  TextOverflow.ellipsis,
              style:
                  const TextStyle(
                fontSize: 10.5,
                fontWeight:
                    FontWeight.w900,
              ),
            ),

            const SizedBox(
              height: 3,
            ),

            Text(
              item.subtitle,
              maxLines: 1,
              overflow:
                  TextOverflow.ellipsis,
              style:
                  const TextStyle(
                fontSize: 10,
                color: AppColors
                    .textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}