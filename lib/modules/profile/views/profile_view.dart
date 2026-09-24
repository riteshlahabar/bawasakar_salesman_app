import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/widgets/drawer_menu_button.dart';
import '../../../app/data/models/action_item_model.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/action_tile.dart';
import '../../../app/widgets/app_decorations.dart';
import '../controllers/profile_controller.dart';
import '../../../app/localization/t.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t('common.my_profile')),
        leading: const DrawerMenuButton(),
      ),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppDecorations.softCard(),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.employeeCode.isNotEmpty
                              ? controller.employeeCode
                              : controller.mobile,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            // Every row is drawn even when its value is empty (showing "—"),
            // because a profile field an admin has not filled in yet is worth
            // seeing: on live most of these columns are still null, and
            // hiding them made the screen look like the fields were missing
            // from the app rather than from the record.
            _InfoRow(
              icon: Icons.badge_outlined,
              label: t('profile.employee_code'),
              value: controller.employeeCode,
              showWhenEmpty: true,
            ),
            // Joining Date and Employment Status are Employee Profile items in
            // the Phase 1 spec. Department, Designation and Reporting Manager
            // were removed on 2026-09-24: the spec's whole HRMS list is headed
            // "HRMS Modules (Admin Panel)", and a reporting hierarchy appears
            // nowhere in it at all.
            _InfoRow(
              icon: Icons.event_outlined,
              label: t('profile.joining_date'),
              value: controller.joiningDate,
              showWhenEmpty: true,
            ),
            _InfoRow(
              icon: Icons.verified_user_outlined,
              label: t('profile.employment_status'),
              value: controller.employmentStatus,
              showWhenEmpty: true,
            ),
            _InfoRow(
              icon: Icons.phone_outlined,
              label: t('profile.mobile'),
              value: controller.mobile,
              showWhenEmpty: true,
            ),
            _InfoRow(
              icon: Icons.email_outlined,
              label: t('common.email'),
              value: controller.email,
              showWhenEmpty: true,
            ),
            const SizedBox(height: 14),
            ActionTile(
              item: ActionItemModel(
                title: t('common.help_and_support'),
                subtitle: t('common.raise_a_support_ticket'),
                icon: Icons.support_agent_rounded,
                route: AppRoutes.support,
                color: AppColors.info,
              ),
              onTap: () => Get.toNamed(AppRoutes.support),
            ),
            const SizedBox(height: 10),
            ActionTile(
              item: ActionItemModel(
                title: t('common.logout'),
                subtitle: t('profile.sign_out_from_the_salesman_app'),
                icon: Icons.logout_rounded,
                route: AppRoutes.login,
                color: AppColors.danger,
              ),
              onTap: controller.logout,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.showWhenEmpty = false,
  });

  final IconData icon;
  final String label;
  final String value;

  /// Draw the row with a dash instead of hiding it when the value is empty.
  ///
  /// Hiding is still the default, but on the profile a silently missing row
  /// reads as a bug: the salesman cannot tell a field that is not part of
  /// this app from one an admin simply has not filled in yet.
  final bool showWhenEmpty;

  @override
  Widget build(BuildContext context) {
    final isEmpty = value.isEmpty;
    if (isEmpty && !showWhenEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: AppDecorations.softCard(radius: 14),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isEmpty ? '—' : value,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: isEmpty
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
