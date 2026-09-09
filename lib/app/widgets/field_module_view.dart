import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/models/list_row_model.dart';
import '../data/models/summary_card_model.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import 'app_decorations.dart';
import 'module_list_view.dart';
import 'salesman_bottom_navigation.dart';
import 'section_header.dart';
import 'summary_card.dart';

class FieldModuleView extends StatelessWidget {
  const FieldModuleView({
    super.key,
    required this.title,
    required this.subtitle,
    required this.stats,
    required this.rows,
    this.primaryActionLabel,
    this.primaryActionIcon,
    this.onPrimaryAction,
    this.secondaryActionLabel,
    this.secondaryActionIcon,
    this.onSecondaryAction,
    this.featured,
    this.recordsTitle = 'Recent Records',
  });

  final String title;
  final String subtitle;
  final List<SummaryCardModel> stats;
  final List<ListRowModel> rows;
  final String? primaryActionLabel;
  final IconData? primaryActionIcon;
  final VoidCallback? onPrimaryAction;
  final String? secondaryActionLabel;
  final IconData? secondaryActionIcon;
  final VoidCallback? onSecondaryAction;
  final Widget? featured;
  final String recordsTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(title: Text(title)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(6),
        child: FloatingActionButton(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 6,
          onPressed: () => Get.toNamed(AppRoutes.products),
          child: const Icon(Icons.qr_code_scanner_sharp),
        ),
      ),
      bottomNavigationBar: const SalesmanBottomNavigation(selectedIndex: -1),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 104),
        children: [
          SectionHeader(title: title, subtitle: subtitle),
          if (stats.isNotEmpty) ...[
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: stats.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: 144,
              ),
              itemBuilder: (context, index) => SummaryCard(item: stats[index]),
            ),
          ],
          if (featured != null) ...[const SizedBox(height: 16), featured!],
          if (primaryActionLabel != null || secondaryActionLabel != null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                if (primaryActionLabel != null)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onPrimaryAction,
                      icon: Icon(primaryActionIcon ?? Icons.add),
                      label: Text(primaryActionLabel!),
                    ),
                  ),
                if (primaryActionLabel != null && secondaryActionLabel != null)
                  const SizedBox(width: 10),
                if (secondaryActionLabel != null)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onSecondaryAction,
                      icon: Icon(secondaryActionIcon ?? Icons.visibility),
                      label: Text(secondaryActionLabel!),
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 18),
          Text(
            recordsTitle,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          ...rows.map(ModuleRow.new),
        ],
      ),
    );
  }
}

class ModuleInfoPanel extends StatelessWidget {
  const ModuleInfoPanel({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.softCard(radius: 16),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: AppDecorations.iconBox(color),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 10), trailing!],
        ],
      ),
    );
  }
}
