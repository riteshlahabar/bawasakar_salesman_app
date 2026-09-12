import 'package:flutter/material.dart';

import '../../../../app/data/models/dealer_model.dart';
import '../../../../app/theme/app_colors.dart';

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
          const Text(
            'Dealer',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 7),
          DropdownButtonFormField<int>(
            value: selectedDealerId > 0 ? selectedDealerId : null,
            isExpanded: true,
            hint: const Text('Select dealer'),
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
          const Text(
            'Amount',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 7),
          TextField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: const InputDecoration(
              hintText: 'Enter amount',
              prefixText: '₹ ',
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Payment Mode',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 7),
          DropdownButtonFormField<String>(
            value: paymentMode,
            items: const [
              DropdownMenuItem(value: 'cash', child: Text('Cash')),
              DropdownMenuItem(value: 'upi', child: Text('UPI')),
              DropdownMenuItem(
                value: 'bank_transfer',
                child: Text('Bank Transfer'),
              ),
              DropdownMenuItem(value: 'cheque', child: Text('Cheque')),
            ],
            onChanged: onPaymentModeChanged,
          ),
          const SizedBox(height: 15),
          const Text(
            'Transaction Reference',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 7),
          TextField(
            controller: transactionController,
            decoration: const InputDecoration(
              hintText: 'Optional UPI / bank / cheque reference',
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
            label: Text(isLoading ? 'Saving...' : 'Collect Payment'),
          ),
        ],
      ),
    );
  }
}
