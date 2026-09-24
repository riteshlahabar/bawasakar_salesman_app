import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/data/clock_time.dart';
import '../../../../app/localization/t.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/app_decorations.dart';
import '../../controllers/dashboard_controller.dart';

/// Check In / Check Out / Break row plus today's check-in address & time,
/// shown on [DashboardView]. Break/Resume writes a real attendance_breaks
/// row on the server, so admin sees the day's breaks and the time is
/// deducted from working minutes at check-out.
class AttendanceQuickActions extends GetView<DashboardController> {
  const AttendanceQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final canCheckOut =
          controller.hasCheckedInToday && !controller.hasCheckedOutToday;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: t('dashboard.check_in'),
                  icon: Icons.login,
                  color: AppColors.success,
                  enabled:
                      !controller.hasCheckedInToday &&
                      !controller.isPunching.value,
                  loading:
                      controller.isPunching.value &&
                      !controller.hasCheckedInToday,
                  onTap: controller.checkIn,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ActionButton(
                  label: t('dashboard.check_out'),
                  icon: Icons.logout,
                  color: AppColors.danger,
                  enabled: canCheckOut && !controller.isPunching.value,
                  loading:
                      controller.isPunching.value &&
                      controller.hasCheckedInToday,
                  onTap: controller.checkOut,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ActionButton(
                  label: controller.onBreak.value
                      ? t('dashboard.resume')
                      : t('dashboard.break'),
                  icon: controller.onBreak.value
                      ? Icons.play_arrow
                      : Icons.pause,
                  color: AppColors.orange,
                  enabled: canCheckOut && !controller.isBreakBusy.value,
                  loading: controller.isBreakBusy.value,
                  onTap: controller.toggleBreak,
                ),
              ),
            ],
          ),
          if (controller.hasCheckedInToday) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: AppDecorations.softCard(radius: 16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: AppDecorations.iconBox(AppColors.primary),
                    child: const Icon(
                      Icons.location_on_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.checkInAddress.value.isEmpty
                              ? t('dashboard.locating_address')
                              : controller.checkInAddress.value,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          clockTime(controller.checkedInAt.value),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    });
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.enabled,
    required this.loading,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool enabled;
  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: enabled ? color : color.withValues(alpha: .35),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            if (loading)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            else
              Icon(icon, color: Colors.white, size: 20),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
