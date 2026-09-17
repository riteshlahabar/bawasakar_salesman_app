import 'package:flutter/material.dart';

import '../../../../app/data/models/dealer_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/localization/t.dart';

/// Dealer/amount/payment-mode form card for [CollectionsView].
class CollectionFormCard extends StatelessWidget {
  const CollectionFormCard({
    super.key,
    required this.dealers,
    required this.selectedDealerId,
    required this.onDealerChanged,
    required this.amountController,
    required this.paymentMode,
    required this.onPaymentModeChanged,
    required this.transactionController,
    required this.isLoading,
    required this.onSubmit,
  });

  final List<DealerModel> dealers;
  final int selectedDealerId;
  final ValueChanged<int?> onDealerChanged;
  final TextEditingController amountController;
  final String paymentMode;
  final ValueChanged<String?> onPaymentModeChanged;
  final TextEditingController transactionController;
  final bool isLoading;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t('common.dealer'),
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 7),
          DropdownButtonFormField<int>(
            value: selectedDealerId > 0 ? selectedDealerId : null,
            isExpanded: true,
            hint: Text(t('collections.select_dealer')),
            items: dealers
                .map(
                  (dealer) => DropdownMenuItem<int>(
                    value: dealer.userId,
                    child: Text(
                      dealer.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: onDealerChanged,
          ),
          const SizedBox(height: 15),
          Text(
            t('collections.amount'),
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 7),
          TextField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: InputDecoration(
              hintText: t('collections.enter_amount'),
              prefixText: '₹ ',
            ),
          ),
          const SizedBox(height: 15),
          Text(
            t('collections.payment_mode'),
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 7),
          DropdownButtonFormField<String>(
            value: paymentMode,
            items: [
              DropdownMenuItem(value: 'cash', child: Text(t('collections.cash'))),
              DropdownMenuItem(value: 'upi', child: Text(t('collections.upi'))),
              DropdownMenuItem(
                value: 'bank_transfer',
                child: Text(t('collections.bank_transfer')),
              ),
              DropdownMenuItem(value: 'cheque', child: Text(t('collections.cheque'))),
            ],
            onChanged: onPaymentModeChanged,
          ),
          const SizedBox(height: 15),
          Text(
            t('collections.transaction_reference'),
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 7),
          TextField(
            controller: transactionController,
            decoration: InputDecoration(
              hintText: t('collections.optional_upi_bank_cheque_reference'),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: isLoading ? null : onSubmit,
            icon: isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.payments_outlined),
            label: Text(isLoading ? t('collections.saving') : t('collections.collect_payment')),
          ),
        ],
      ),
    );
  }
}
