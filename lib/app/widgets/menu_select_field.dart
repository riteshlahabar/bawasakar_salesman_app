import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../localization/t.dart';
import '../theme/app_colors.dart';

/// A read-only field that opens its options as a menu directly under itself.
///
/// Used instead of `DropdownButtonFormField` inside bottom-sheet forms: a
/// dropdown menu is placed from the button's screen rect at the moment it
/// opens, and tapping it also drops focus — so the keyboard closes, the sheet
/// slides back down, and the menu is left stranded mid-screen. This one waits
/// for the keyboard to retract before opening, so the anchor is already where
/// it will stay.
///
/// Styled with [InputDecorator] so it inherits whatever the form's text
/// fields look like.
class MenuSelectField<T> extends StatefulWidget {
  const MenuSelectField({
    super.key,
    required this.items,
    required this.labelOf,
    required this.onSelected,
    required this.placeholder,
    this.selected,
    this.emptyLabel,
  });

  final List<T> items;

  /// How one option reads in the field and in the menu.
  final String Function(T item) labelOf;

  final ValueChanged<T> onSelected;

  /// Shown, greyed, while nothing is chosen.
  final String placeholder;

  final T? selected;

  /// Shown in place of the menu when there is nothing to choose from.
  final String? emptyLabel;

  @override
  State<MenuSelectField<T>> createState() => _MenuSelectFieldState<T>();
}

class _MenuSelectFieldState<T> extends State<MenuSelectField<T>> {
  final _menu = MenuController();

  /// Opens the list only once the keyboard has fully retracted — see the
  /// class comment for why the wait matters.
  Future<void> _open() async {
    if (_menu.isOpen) {
      _menu.close();
      return;
    }

    FocusScope.of(context).unfocus();

    // ~600 ms cap: a stuck inset must never block the picker entirely.
    for (var frame = 0; frame < 36; frame++) {
      if (!mounted) return;
      if (MediaQuery.of(context).viewInsets.bottom == 0) break;
      await SchedulerBinding.instance.endOfFrame;
    }

    if (!mounted) return;
    _menu.open();
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;

    return LayoutBuilder(
      builder: (context, constraints) {
        return MenuAnchor(
          controller: _menu,
          // Pinned to the field's own width so the menu reads as part of it.
          style: MenuStyle(
            minimumSize: WidgetStatePropertyAll(Size(constraints.maxWidth, 0)),
            maximumSize: WidgetStatePropertyAll(
              Size(constraints.maxWidth, 280),
            ),
            backgroundColor: const WidgetStatePropertyAll(AppColors.card),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
          menuChildren: widget.items.isEmpty
              ? [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Text(
                      widget.emptyLabel ?? t('common.nothing_here_yet'),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ]
              : [
                  for (final item in widget.items)
                    MenuItemButton(
                      onPressed: () => widget.onSelected(item),
                      trailingIcon: item == selected
                          ? const Icon(
                              Icons.check_rounded,
                              size: 16,
                              color: AppColors.primary,
                            )
                          : null,
                      child: SizedBox(
                        // Leaves room for the tick without the label wrapping.
                        width: constraints.maxWidth - 90,
                        child: Text(
                          widget.labelOf(item),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: item == selected
                                ? FontWeight.w800
                                : FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
          builder: (context, menu, child) {
            // A sheet paints an opaque Container over the route's Material, so
            // the tap ripple needs its own transparent Material above it.
            return Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: _open,
                borderRadius: BorderRadius.circular(16),
                child: InputDecorator(
                  decoration: const InputDecoration(),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          selected == null
                              ? widget.placeholder
                              : widget.labelOf(selected),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: selected == null
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Icon(
                        menu.isOpen
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
