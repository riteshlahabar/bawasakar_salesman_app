import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../app/localization/t.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/menu_select_field.dart';
import '../../controllers/advances_controller.dart';

/// The request form: advance or loan, how much, over how many instalments,
/// and why.
///
/// The instalments field appears only for a loan — `SalaryAdvanceService`
/// forces `installments = 1` on an advance, which is recovered from the next
/// salary in one go, so offering the field there would promise something the
/// server ignores.
class RequestAdvanceSheet extends StatelessWidget {
  const RequestAdvanceSheet({super.key, required this.controller});

  final AdvancesController controller;

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
              t('advances.request_advance'),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 16),
            _label(t('advances.request_type')),
            Obx(
              () => MenuSelectField<String>(
                items: AdvancesController.requestTypes,
                selected: controller.selectedType.value,
                labelOf: controller.typeLabel,
                placeholder: t('advances.choose_request_type'),
                onSelected: (value) => controller.selectedType.value = value,
              ),
            ),
            const SizedBox(height: 15),
            _label(t('advances.amount')),
            TextField(
              controller: controller.amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              decoration: InputDecoration(hintText: t('advances.amount_hint')),
            ),
            // Only a loan is spread over instalments.
            Obx(() {
              if (!controller.isLoanRequest) return const SizedBox.shrink();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  _label(t('advances.installments')),
                  TextField(
                    controller: controller.installmentsController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: t('advances.installments_hint'),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 15),
            _label(t('advances.reason')),
            TextField(
              controller: controller.reasonController,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(hintText: t('advances.reason_hint')),
            ),
            const SizedBox(height: 10),
            Obx(
              () => Text(
                controller.isLoanRequest
                    ? t('advances.loan_note')
                    : t('advances.advance_note'),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: Obx(
                () => ElevatedButton.icon(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : controller.submitRequest,
                  icon: const Icon(Icons.check),
                  label: Text(
                    controller.isSubmitting.value
                        ? t('collections.saving')
                        : t('advances.submit_request'),
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
}
