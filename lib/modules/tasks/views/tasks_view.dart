import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/module_row_mapper.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_decorations.dart';
import '../../../app/widgets/empty_state.dart';
import '../../../app/widgets/salesman_bottom_navigation.dart';
import '../../../app/widgets/section_header.dart';
import '../controllers/tasks_controller.dart';
import '../../../app/localization/t.dart';

class TasksView extends GetView<TasksController> {
  const TasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(title: Text(t('tasks.tasks_title'))),
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
        if (controller.isLoading.value && controller.tasks.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (controller.error.value.isNotEmpty && controller.tasks.isEmpty) {
          return EmptyState(
            title: t('common.could_not_load'),
            message: controller.error.value,
            icon: Icons.cloud_off,
          );
        }

        if (controller.isEmpty) {
          return EmptyState(
            title: t('common.nothing_here_yet'),
            message: t('tasks.no_tasks_assigned_yet'),
            icon: Icons.task_alt_outlined,
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.load,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 104),
            children: [
              SectionHeader(
                title: t('tasks.tasks_title'),
                subtitle: t('tasks.tasks_assigned_to_you_by_admin'),
              ),
              const SizedBox(height: 18),
              ...controller.tasks.map((task) => _TaskCard(task: task)),
            ],
          ),
        );
      }),
    );
  }
}

class _TaskCard extends GetView<TasksController> {
  const _TaskCard({required this.task});

  final Map<String, dynamic> task;

  @override
  Widget build(BuildContext context) {
    final status = task['status']?.toString() ?? 'pending';
    final color = ModuleRowMapper.statusColor(status);
    final overdue = task['is_overdue'] == true;

    return GestureDetector(
      onTap: () => _showStatusSheet(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: AppDecorations.softCard(radius: 16),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: AppDecorations.iconBox(color),
              child: Icon(Icons.task_alt_outlined, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task['title']?.toString() ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  if ((task['description']?.toString() ?? '').isNotEmpty)
                    Text(
                      task['description'].toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        height: 1.25,
                      ),
                    ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      if (task['due_date'] != null)
                        Text(
                          t('tasks.due_date', {'date': ModuleRowMapper.date(task['due_date'])}),
                          style: TextStyle(
                            color: overdue ? AppColors.danger : AppColors.textSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      if (overdue)
                        Text(
                          t('tasks.overdue'),
                          style: const TextStyle(
                            color: AppColors.danger,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: color.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                status,
                style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusSheet(BuildContext context) {
    if (task['status'] == 'completed' || task['status'] == 'cancelled') return;

    final id = ModuleRowMapper.toInt(task['id']);
    final notes = TextEditingController();

    Get.bottomSheet<void>(
      Container(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          20 + MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task['title']?.toString() ?? '',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: notes,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(hintText: t('tasks.completion_notes')),
            ),
            const SizedBox(height: 16),
            Obx(
              () => Row(
                children: [
                  if (task['status'] == 'pending')
                    Expanded(
                      child: OutlinedButton(
                        onPressed: controller.isUpdating.value
                            ? null
                            : () {
                                controller.setStatus(id, 'in_progress');
                                Get.back<void>();
                              },
                        child: Text(t('tasks.mark_in_progress')),
                      ),
                    ),
                  if (task['status'] == 'pending') const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.isUpdating.value
                          ? null
                          : () {
                              controller.setStatus(
                                id,
                                'completed',
                                completionNotes: notes.text,
                              );
                              Get.back<void>();
                            },
                      child: Text(t('tasks.mark_completed')),
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
}
