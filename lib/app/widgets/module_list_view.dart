import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/models/list_row_model.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import 'app_decorations.dart';
import 'salesman_bottom_navigation.dart';
import 'section_header.dart';

class ModuleListView extends StatelessWidget {
  const ModuleListView({
    super.key,
    required this.title,
    required this.subtitle,
    required this.rows,
    this.primaryActionLabel,
    this.primaryActionIcon,
    this.onPrimaryAction,
    this.showChrome = true,
  });

  final String title;
  final String subtitle;
  final List<ListRowModel> rows;
  final String? primaryActionLabel;
  final IconData? primaryActionIcon;
  final VoidCallback? onPrimaryAction;
  final bool showChrome;

  @override
  Widget build(BuildContext context) {
    final content = ListView(
      padding: EdgeInsets.fromLTRB(16, 8, 16, showChrome ? 104 : 24),
      children: [
        SectionHeader(title: title, subtitle: subtitle),
        if (primaryActionLabel != null) ...[
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onPrimaryAction,
            icon: Icon(primaryActionIcon ?? Icons.add),
            label: Text(primaryActionLabel!),
          ),
        ],
        const SizedBox(height: 18),
        ...rows.map(ModuleRow.new),
      ],
    );

    if (!showChrome) return content;

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
      body: content,
    );
  }
}

class ModuleRow extends StatelessWidget {
  const ModuleRow(this.row, {super.key});

  final ListRowModel row;

  @override
  Widget build(BuildContext context) {
    final color = row.color ?? AppColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppDecorations.softCard(radius: 16),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: AppDecorations.iconBox(color),
            child: Icon(row.icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.title,
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
                  row.subtitle,
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
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                row.trailing,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (row.status != null) ...[
                const SizedBox(height: 7),
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
                    row.status!,
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
