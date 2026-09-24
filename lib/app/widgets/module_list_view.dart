import 'package:flutter/material.dart';

import 'drawer_menu_button.dart';
import '../data/models/list_row_model.dart';
import '../data/module_row_mapper.dart';
import '../theme/app_colors.dart';
import 'app_decorations.dart';
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
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
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

    // Only the app bar: the bottom bar and FAB come from NavShell, which
    // wraps every pushed route.
    return Scaffold(
      appBar: AppBar(title: Text(title), leading: const DrawerMenuButton()),
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

    // A row carrying both a title-line value and a trailing one stacks them
    // on the right instead: Expenses wants its date and badge at the card's
    // edge with the amount directly underneath.
    final stackRight = row.titleTrailing != null && row.trailing.isNotEmpty;

    // With nothing on the right at all (Attendance passes an empty trailing)
    // the badge moves up beside the title rather than sitting alone in an
    // otherwise empty column.
    final inlineStatus =
        row.status != null && row.trailing.isEmpty && !stackRight;

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
                Row(
                  children: [
                    // Expanded, not Flexible: it pushes an inline status badge
                    // out to the card's right edge instead of leaving it stuck
                    // against the end of the title.
                    Expanded(
                      child: Text(
                        row.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (row.titleTrailing != null && !stackRight) ...[
                      const SizedBox(width: 8),
                      Text(
                        row.titleTrailing!,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    if (inlineStatus) ...[
                      const SizedBox(width: 8),
                      _StatusBadge(label: row.status!, color: color),
                    ],
                  ],
                ),
                const SizedBox(height: 5),
                // A row can colour parts of its second line (the attendance
                // sheet's in/out/hours); everything else passes plain text.
                Text.rich(
                  row.subtitleSpans == null
                      ? TextSpan(text: row.subtitle)
                      : TextSpan(children: row.subtitleSpans),
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
          // Nothing belongs on the right when a row carries neither a trailing
          // value nor a badge of its own — the visit log keeps its date and
          // time up on the title line — so the column and its gap are dropped.
          if (row.trailing.isNotEmpty ||
              (!inlineStatus && row.status != null)) ...[
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Date and badge share the top line, hard against the card's
                // right edge, with the amount on its own line below them.
                if (stackRight)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        row.titleTrailing!,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (row.status != null) ...[
                        const SizedBox(width: 8),
                        _StatusBadge(label: row.status!, color: color),
                      ],
                    ],
                  ),
                if (row.trailing.isNotEmpty) ...[
                  if (stackRight) const SizedBox(height: 7),
                  Text(
                    row.trailing,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
                if (!inlineStatus && !stackRight && row.status != null) ...[
                  if (row.trailing.isNotEmpty) const SizedBox(height: 7),
                  _StatusBadge(label: row.status!, color: color),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// The rounded status pill, shared by the row's right column and its title
/// line so the two can't drift apart.
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        ModuleRowMapper.statusLabel(label),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
