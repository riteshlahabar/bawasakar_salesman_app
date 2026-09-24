import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'filter_chip_button.dart';

/// One filter option: the code the API uses, and how it reads on screen.
typedef StatusFilterOption = ({String value, String label});

/// A row of status chips, for a module whose records are filtered by what
/// state they are in rather than by when they happened.
///
/// Assets use this instead of [DateFilterBar]: an asset is a possession, not
/// an event, so a date window would hide the laptop issued last year that the
/// salesman is still holding — which is exactly the row they came to see.
class StatusFilterBar extends StatelessWidget {
  const StatusFilterBar({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<StatusFilterOption> options;

  /// The chosen option's `value`; empty means "all".
  final String selected;

  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    // The same tinted, bordered panel as the date filter, so the two read as
    // the same control on whichever screen they appear.
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(10),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: options
            .map(
              (option) => SizedBox(
                // Fixed-width chips wrap into tidy rows; letting them size to
                // their label leaves a ragged edge as the labels differ.
                width: 96,
                child: FilterChipButton(
                  label: option.label,
                  selected: option.value == selected,
                  onTap: () => onSelected(option.value),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
