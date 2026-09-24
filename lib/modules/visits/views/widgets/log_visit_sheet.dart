import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/data/models/dealer_model.dart';
import '../../../../app/localization/t.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/menu_select_field.dart';
import '../../controllers/visits_controller.dart';

/// The log-a-visit form: dealer, purpose, remarks.
///
/// No location field — visits are recorded by hand, so nothing here waits on
/// the phone's GPS.
class LogVisitSheet extends StatelessWidget {
  const LogVisitSheet({super.key, required this.controller});

  final VisitsController controller;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    // Do NOT add `viewInsets.bottom` here: Get.bottomSheet's own route
    // already pads the sheet by the keyboard height, so doing it again
    // lifts the sheet a second keyboard-height above the keyboard.
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
              t('visits.log_visit'),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              t('common.dealer'),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            Obx(() {
              // Read inside the closure: passing the RxList down would
              // register nothing.
              final dealers = controller.dealers.toList();
              final selected = controller.selectedDealerId.value;
              final picked = dealers
                  .where((dealer) => dealer.userId == selected)
                  .toList();

              return MenuSelectField<DealerModel>(
                items: dealers,
                selected: picked.isEmpty ? null : picked.first,
                labelOf: (dealer) => dealer.displayName,
                placeholder: t('collections.select_dealer'),
                onSelected: (dealer) =>
                    controller.selectedDealerId.value = dealer.userId,
              );
            }),
            const SizedBox(height: 15),
            Text(
              t('visits.purpose'),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            TextField(
              controller: controller.purposeController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(hintText: t('visits.purpose_hint')),
            ),
            const SizedBox(height: 15),
            Text(
              t('visits.remarks'),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            TextField(
              controller: controller.remarksController,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(hintText: t('visits.remarks_hint')),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Obx(
                () => ElevatedButton.icon(
                  onPressed: controller.isSaving.value
                      ? null
                      : controller.saveVisit,
                  icon: const Icon(Icons.check),
                  label: Text(
                    controller.isSaving.value
                        ? t('collections.saving')
                        : t('visits.save_visit'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
