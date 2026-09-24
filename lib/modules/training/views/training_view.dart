import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/widgets/drawer_menu_button.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_decorations.dart';
import '../../../app/widgets/empty_state.dart';
import '../../../app/widgets/section_header.dart';
import '../controllers/training_controller.dart';
import '../../../app/localization/t.dart';

class TrainingView extends GetView<TrainingController> {
  const TrainingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The bottom bar and FAB belong to NavShell, which wraps this route.
      appBar: AppBar(
        title: Text(t('training.training_title')),
        leading: const DrawerMenuButton(),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.trainings.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (controller.error.value.isNotEmpty && controller.trainings.isEmpty) {
          return EmptyState(
            title: t('common.could_not_load'),
            message: controller.error.value,
            icon: Icons.cloud_off,
          );
        }

        if (controller.isEmpty) {
          return EmptyState(
            title: t('common.nothing_here_yet'),
            message: t('training.no_trainings_yet'),
            icon: Icons.school_outlined,
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.load,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              SectionHeader(
                title: t('training.training_title'),
                subtitle: t('training.training_programs_you_are_enrolled'),
              ),
              const SizedBox(height: 18),
              ...controller.trainings.map((row) => _TrainingCard(row: row)),
            ],
          ),
        );
      }),
    );
  }
}

class _TrainingCard extends GetView<TrainingController> {
  const _TrainingCard({required this.row});

  final Map<String, dynamic> row;

  @override
  Widget build(BuildContext context) {
    final status = row['status']?.toString() ?? '';
    final color = ModuleRowMapper.statusColor(status);
    final issued = row['certificate_issued'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppDecorations.softCard(radius: 16),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: AppDecorations.iconBox(color),
                child: Icon(Icons.school_outlined, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      row['title']?.toString() ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      [
                        if ((row['trainer']?.toString() ?? '').isNotEmpty)
                          row['trainer'].toString(),
                        if (row['starts_on'] != null)
                          ModuleRowMapper.date(row['starts_on']),
                        if (row['score'] != null)
                          t('training.score', {'n': '${row['score']}'}),
                      ].join(' • '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  ModuleRowMapper.statusLabel(status),
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          if (issued) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => controller.downloadCertificate(
                  ModuleRowMapper.toInt(row['id']),
                  row['title']?.toString() ?? '',
                ),
                icon: const Icon(Icons.download_outlined, size: 18),
                label: Text(t('training.download_certificate')),
              ),
            ),
          ] else ...[
            const SizedBox(height: 8),
            Text(
              t('training.certificate_pending'),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
