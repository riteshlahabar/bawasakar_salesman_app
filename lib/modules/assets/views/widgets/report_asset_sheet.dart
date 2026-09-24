import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/data/module_row_mapper.dart';
import '../../../../app/localization/t.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/menu_select_field.dart';
import '../../controllers/assets_controller.dart';

/// The report form: which asset, what happened, and anything worth adding.
///
/// Only an asset the salesman still holds can be picked — a returned one is
/// no longer theirs to report on.
class ReportAssetSheet extends StatelessWidget {
  const ReportAssetSheet({super.key, required this.controller});

  final AssetsController controller;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    // Do NOT add `viewInsets.bottom` here: Get.bottomSheet's own route
    // already pads the sheet by the keyboard height.
    return Container(
      constraints: BoxConstraints(maxHeight: media.size.height * .85),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t('assets.report_issue'),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 16),
            _label(t('common.asset')),
            Obx(() {
              // Read inside the closure: passing the list down would register
              // nothing.
              final holdings = controller.reportableAssets;
              final selected = controller.selectedAssetId.value;

              return MenuSelectField<int>(
                items: holdings
                    .map((asset) => ModuleRowMapper.toInt(asset['id']))
                    .toList(),
                selected: selected <= 0 ? null : selected,
                labelOf: controller.assetLabel,
                placeholder: t('assets.choose_an_asset'),
                emptyLabel: t('common.nothing_here_yet'),
                onSelected: (id) => controller.selectedAssetId.value = id,
              );
            }),
            const SizedBox(height: 15),
            _label(t('assets.what_happened')),
            Obx(
              () => MenuSelectField<String>(
                items: AssetsController.issueTypes,
                selected: controller.selectedIssue.value,
                labelOf: controller.issueLabel,
                placeholder: t('assets.choose_what_happened'),
                onSelected: (issue) => controller.selectedIssue.value = issue,
              ),
            ),
            const SizedBox(height: 15),
            _label(t('assets.remarks')),
            TextField(
              controller: controller.remarksController,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: t('assets.remarks_hint'),
              ),
            ),
            const SizedBox(height: 10),
            Obx(
              () => Text(
                controller.selectedIssue.value == 'return_request'
                    ? t('assets.return_request_note')
                    : t('assets.status_change_note'),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: Obx(
                () => ElevatedButton.icon(
                  onPressed: controller.isSaving.value
                      ? null
                      : controller.submitReport,
                  icon: const Icon(Icons.check),
                  label: Text(
                    controller.isSaving.value
                        ? t('collections.saving')
                        : t('assets.submit_report'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 7),
    child: Text(
      text,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
    ),
  );
}
