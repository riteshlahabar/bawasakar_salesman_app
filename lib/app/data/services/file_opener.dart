import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';

import 'file_download_service.dart';
import '../../theme/app_colors.dart';
import '../../localization/t.dart';

/// Downloads a file from an authenticated endpoint and hands it to the
/// device's own viewer, where the user can print or share it.
///
/// Kept out of the controllers so every screen that downloads a document
/// (invoices, training certificates) shows the same messages for the same
/// outcome.
class FileOpener {
  const FileOpener(this._downloads);

  final FileDownloadService _downloads;

  Future<void> open(String path, String fileName, {String? mimeType}) async {
    try {
      final file = await _downloads.download(path, fileName);
      final result = await OpenFilex.open(file.path, type: mimeType);

      if (result.type == ResultType.done) {
        _notify(t('common.saved'), '${t('common.saved_as')}: ${file.uri.pathSegments.last}');
        return;
      }

      _notify(t('common.saved'), t('common.no_viewer_app_found'));
    } catch (failure) {
      _notify(t('common.download_failed'), _message(failure), isError: true);
    }
  }

  String _message(Object failure) {
    final text = failure.toString().replaceFirst('Exception: ', '');
    return text.isEmpty ? t('common.download_failed') : text;
  }

  void _notify(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      backgroundColor: isError ? AppColors.danger : AppColors.primary,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}
