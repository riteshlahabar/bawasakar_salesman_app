import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/module_row_mapper.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_decorations.dart';
import '../../../app/widgets/empty_state.dart';
import '../../../app/widgets/salesman_bottom_navigation.dart';
import '../../../app/widgets/section_header.dart';
import '../controllers/invoices_controller.dart';
import '../../../app/localization/t.dart';

class InvoicesView extends GetView<InvoicesController> {
  const InvoicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(title: Text(t('invoices.invoices'))),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(6),
        child: FloatingActionButton(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 6,
          onPressed: () => Get.toNamed<void>(AppRoutes.products),
          child: const Icon(Icons.qr_code_scanner_sharp),
        ),
      ),
      bottomNavigationBar: const SalesmanBottomNavigation(selectedIndex: -1),
      body: Obx(() {
        if (controller.isLoading.value && controller.invoices.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (controller.error.value.isNotEmpty && controller.invoices.isEmpty) {
          return EmptyState(
            title: t('common.could_not_load'),
            message: controller.error.value,
            icon: Icons.cloud_off,
          );
        }

        if (controller.isEmpty) {
          return EmptyState(
            title: t('common.nothing_here_yet'),
            message: t('invoices.no_invoices_yet'),
            icon: Icons.receipt_long_outlined,
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.load,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 104),
            children: [
              SectionHeader(
                title: t('invoices.invoices'),
                subtitle: t('invoices.your_invoices_for_billed_orders_with'),
              ),
              const SizedBox(height: 18),
              ...controller.invoices.map((invoice) => _InvoiceCard(invoice: invoice)),
            ],
          ),
        );
      }),
    );
  }
}

class _InvoiceCard extends GetView<InvoicesController> {
  const _InvoiceCard({required this.invoice});

  final Map<String, dynamic> invoice;

  @override
  Widget build(BuildContext context) {
    final order = invoice['order'] is Map ? invoice['order'] as Map : const {};
    final invoiceNo = invoice['invoice_no']?.toString() ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppDecorations.softCard(radius: 16),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: AppDecorations.iconBox(AppColors.primary),
            child: const Icon(Icons.receipt_long_outlined, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invoiceNo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 5),
                Text(
                  [
                    ModuleRowMapper.date(invoice['invoice_date']),
                    if ((order['order_no']?.toString() ?? '').isNotEmpty) order['order_no'].toString(),
                  ].join(' • '),
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                ),
                const SizedBox(height: 2),
                Text(
                  ModuleRowMapper.money(invoice['grand_total']),
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => controller.downloadPdf(ModuleRowMapper.toInt(invoice['id']), invoiceNo),
            icon: const Icon(Icons.download_outlined, color: AppColors.primary),
            tooltip: t('invoices.download_pdf'),
          ),
        ],
      ),
    );
  }
}
