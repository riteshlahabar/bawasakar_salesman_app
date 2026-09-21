import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/module_row_mapper.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_decorations.dart';
import '../../../app/widgets/empty_state.dart';
import '../../../app/widgets/section_header.dart';
import '../controllers/resignation_controller.dart';
import '../../../app/localization/t.dart';

class ResignationView extends GetView<ResignationController> {
  const ResignationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('resignation.resignation_and_exit'))),
      body: Obx(() {
        if (controller.isLoading.value && controller.resignations.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (controller.error.value.isNotEmpty && controller.resignations.isEmpty) {
          return EmptyState(
            title: t('common.could_not_load'),
            message: controller.error.value,
            icon: Icons.cloud_off,
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.load,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SectionHeader(
                title: t('resignation.resignation_and_exit'),
                subtitle: t('resignation.submit_a_resignation_request_and_track'),
              ),
              const SizedBox(height: 18),
              if (controller.current != null) _StatusCard(resignation: controller.current!),
              if (controller.current != null) const SizedBox(height: 16),
              if (controller.hasOpenRequest)
                Text(
                  t('resignation.already_pending'),
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                )
              else
                const _RequestForm(),
            ],
          ),
        );
      }),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.resignation});

  final Map<String, dynamic> resignation;

  @override
  Widget build(BuildContext context) {
    final status = resignation['status']?.toString() ?? '';
    final color = ModuleRowMapper.statusColor(status);

    return Container(
      decoration: AppDecorations.softCard(radius: 16),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: AppDecorations.iconBox(color),
                child: Icon(Icons.logout_outlined, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resignation['reference_no']?.toString() ?? '',
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${t('resignation.resignation_date')}: ${ModuleRowMapper.date(resignation['resignation_date'])}',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: color.withValues(alpha: .10), borderRadius: BorderRadius.circular(24)),
                child: Text(status, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          if (resignation['approved_last_working_date'] != null) ...[
            const Divider(height: 24),
            _kv(t('resignation.last_working_date'), ModuleRowMapper.date(resignation['approved_last_working_date'])),
          ],
          if (status == 'approved' || status == 'completed') ...[
            const SizedBox(height: 8),
            _kv(t('resignation.settlement_amount'), ModuleRowMapper.money(resignation['settlement_amount'])),
            const SizedBox(height: 8),
            _kv(t('resignation.settlement_status'), resignation['settlement_status']?.toString() ?? ''),
          ],
        ],
      ),
    );
  }

  Widget _kv(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
        Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _RequestForm extends GetView<ResignationController> {
  const _RequestForm();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.softCard(radius: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t('resignation.request_resignation'),
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 14),
          Obx(
            () => InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 1)),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) controller.resignationDate.value = picked;
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: t('resignation.resignation_date'),
                  prefixIcon: const Icon(Icons.event_outlined, color: AppColors.primary),
                ),
                child: Text(
                  controller.resignationDate.value == null
                      ? t('resignation.select_resignation_date')
                      : ModuleRowMapper.date(controller.resignationDate.value!.toIso8601String()),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller.reason,
            minLines: 3,
            maxLines: 5,
            decoration: InputDecoration(hintText: t('resignation.reason')),
          ),
          const SizedBox(height: 16),
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.isSubmitting.value ? null : controller.submit,
                child: Text(t('resignation.submit_request')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
