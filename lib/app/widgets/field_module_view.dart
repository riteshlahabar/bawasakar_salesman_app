import 'package:flutter/material.dart';

import 'drawer_menu_button.dart';
import '../data/models/list_row_model.dart';
import '../data/models/summary_card_model.dart';
import '../theme/app_colors.dart';
import 'app_decorations.dart';
import 'module_list_view.dart';
import 'section_header.dart';
import 'summary_card.dart';
import '../localization/t.dart';

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
    this.recordsTitle = 'common.recent_records',
    this.showHeader = true,
    this.topSlot,
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

  /// The in-body title/subtitle block. Screens whose app bar already says the
  /// same thing pass `false` (Attendance does).
  final bool showHeader;

  /// Sits above the stat tiles, for a filter that decides what they count —
  /// Attendance's month stepper.
  final Widget? topSlot;

  @override
  Widget build(BuildContext context) {
    // No bottom bar or FAB here: every route showing this view is wrapped in
    // NavShell, which owns them. Adding them again stacked two bars.
    return Scaffold(
      appBar: AppBar(title: Text(title), leading: const DrawerMenuButton()),
      body: ListView(
        // Always scrollable, even when the content is shorter than the
        // screen: without this a short list cannot be overscrolled, so the
        // RefreshIndicator that RemoteModuleView wraps around this view never
        // fires and pull-to-refresh silently does nothing.
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          if (showHeader) SectionHeader(title: title, subtitle: subtitle),
          if (topSlot != null) ...[
            SizedBox(height: showHeader ? 14 : 4),
            topSlot!,
          ],
          if (stats.isNotEmpty) ...[
            // A filter above needs a clear gap so the tiles below read as its
            // result, not as part of the control.
            SizedBox(height: showHeader || topSlot != null ? 16 : 4),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: stats.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: SummaryCard.gridExtent,
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
            // A key or already-translated text; t() returns the latter unchanged.
            t(recordsTitle),
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
