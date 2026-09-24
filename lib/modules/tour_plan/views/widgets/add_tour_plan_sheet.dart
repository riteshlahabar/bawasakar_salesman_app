import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/data/models/dealer_model.dart';
import '../../../../app/localization/t.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/menu_select_field.dart';
import '../../controllers/tour_plan_controller.dart';

/// The new-tour-plan form: date, route name, the dealers on the route.
///
/// Dealers are added one at a time through the shared [MenuSelectField] and
/// listed under it as removable chips. A true multi-select would need its own
/// picker, and a dropdown inside a bottom sheet is the exact widget that
/// strands its menu when the keyboard closes.
class AddTourPlanSheet extends StatelessWidget {
  const AddTourPlanSheet({super.key, required this.controller});

  final TourPlanController controller;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    // Do NOT add `viewInsets.bottom` here: Get.bottomSheet's own route
    // already pads the sheet by the keyboard height.
    return Container(
      constraints: BoxConstraints(maxHeight: media.size.height * .85),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t('tour_plan.add_tour_plan'),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 16),
            _label(t('tour_plan.plan_date')),
            Obx(
              () => _DateField(
                label: controller.planDateLabel,
                onTap: () => _pickDate(context),
              ),
            ),
            const SizedBox(height: 15),
            _label(t('tour_plan.route_name')),
            TextField(
              controller: controller.routeNameController,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: t('tour_plan.route_name_hint'),
              ),
            ),
            const SizedBox(height: 15),
            _label(t('tour_plan.dealers_on_route')),
            Obx(() {
              // Read inside the closure: passing the RxList down would
              // register nothing.
              final picked = controller.selectedDealerIds.toList();
              final available = controller.dealers
                  .where((dealer) => !picked.contains(dealer.userId))
                  .toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MenuSelectField<DealerModel>(
                    items: available,
                    labelOf: (dealer) => dealer.displayName,
                    placeholder: t('tour_plan.add_a_dealer'),
                    emptyLabel: t('common.nothing_here_yet'),
                    onSelected: (dealer) =>
                        controller.toggleDealer(dealer.userId),
                  ),
                  if (picked.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: picked
                          .map(
                            (id) => Chip(
                              label: Text(
                                controller.dealerName(id),
                                style: const TextStyle(fontSize: 11),
                              ),
                              onDeleted: () => controller.toggleDealer(id),
                              deleteIconColor: AppColors.textSecondary,
                              backgroundColor: AppColors.primarySoft,
                              side: BorderSide.none,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              );
            }),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Obx(
                () => ElevatedButton.icon(
                  onPressed: controller.isSaving.value
                      ? null
                      : controller.saveTourPlan,
                  icon: const Icon(Icons.check),
                  label: Text(
                    controller.isSaving.value
                        ? t('collections.saving')
                        : t('tour_plan.save_plan'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 7),
    child: Text(
      text,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
    ),
  );

  /// Today by default, and never in the past — a tour is planned before it is
  /// walked.
  Future<void> _pickDate(BuildContext context) async {
    FocusScope.of(context).unfocus();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final current = controller.planDate.value;

    final picked = await showDatePicker(
      context: context,
      initialDate: current.isBefore(today) ? today : current,
      firstDate: today,
      lastDate: DateTime(now.year + 1, now.month, now.day),
    );

    if (picked != null) controller.planDate.value = picked;
  }
}

/// The date shown like a text field, so the form reads as one column of
/// identical inputs.
class _DateField extends StatelessWidget {
  const _DateField({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: InputDecorator(
          decoration: const InputDecoration(),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Icon(
                Icons.calendar_month_rounded,
                size: 20,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
