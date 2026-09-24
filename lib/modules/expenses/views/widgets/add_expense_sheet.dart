import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../app/controllers/date_filter_mixin.dart';
import '../../../../app/localization/t.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/menu_select_field.dart';
import '../../controllers/expenses_controller.dart';

/// The add-an-expense form: type, amount, date, remarks.
///
/// The same shape as the log-a-visit sheet — no `viewInsets` padding of its
/// own (Get.bottomSheet's route already lifts it for the keyboard) and the
/// type picker is the shared [MenuSelectField], which opens under the field
/// rather than as a stranded dropdown menu.
class AddExpenseSheet extends StatelessWidget {
  const AddExpenseSheet({super.key, required this.controller});

  final ExpensesController controller;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

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
              t('expenses.add_expense'),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),
            _label(t('expenses.expense_type')),
            Obx(() {
              final selected = controller.expenseType.value;

              return MenuSelectField<String>(
                items: ExpensesController.expenseTypes,
                selected: selected.isEmpty ? null : selected,
                labelOf: ExpensesController.expenseTypeLabel,
                placeholder: t('expenses.select_expense_type'),
                onSelected: (value) => controller.expenseType.value = value,
              );
            }),
            const SizedBox(height: 15),
            _label(t('expenses.amount')),
            TextField(
              controller: controller.amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              // Digits and at most one dot: the endpoint wants a plain number.
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(hintText: t('expenses.amount_hint')),
            ),
            const SizedBox(height: 15),
            _label(t('expenses.expense_date')),
            Obx(
              () => _DateField(
                label: DateFilterMixin.dayLabel(controller.expenseDate.value),
                onTap: () => _pickDate(context),
              ),
            ),
            const SizedBox(height: 15),
            _label(t('visits.remarks')),
            TextField(
              controller: controller.remarksController,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(hintText: t('expenses.remarks_hint')),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Obx(
                () => ElevatedButton.icon(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : controller.saveExpense,
                  icon: const Icon(Icons.check),
                  label: Text(
                    controller.isSubmitting.value
                        ? t('collections.saving')
                        : t('expenses.save_expense'),
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

  /// Today by default and never in the future — an expense is claimed after
  /// it is spent.
  Future<void> _pickDate(BuildContext context) async {
    FocusScope.of(context).unfocus();

    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.expenseDate.value,
      firstDate: DateTime(now.year - 3),
      lastDate: now,
    );

    if (picked != null) controller.expenseDate.value = picked;
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
