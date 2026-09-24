import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../../config/api_config.dart';
import '../../core/error/api_exception.dart';
import 'auth_storage.dart';
import '../../localization/t.dart';

/// Downloads a binary file (invoice PDF, training certificate) that sits
/// behind the bearer-token API and saves it to the app's documents directory.
///
/// It bypasses [ApiClient] deliberately: that transport decodes every response
/// as JSON, and these endpoints return binary. No storage permission is
/// needed on either platform because the documents directory is app-private.
class FileDownloadService {
  FileDownloadService(this._storage);

  final AuthStorage _storage;

  Future<File> download(String path, String fileName) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: ApiConfig.timeoutSeconds);

    try {
      final request = await client.getUrl(uri);
      request.headers.set(HttpHeaders.acceptHeader, 'application/octet-stream');

      final token = _storage.token;
      if (token.isNotEmpty) {
        request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
      }

      final response = await request.close();

      if (response.statusCode != HttpStatus.ok) {
        throw ApiException(
          response.statusCode == HttpStatus.notFound
              ? t('common.file_not_found')
              : t('common.could_not_download_file'),
          response.statusCode,
          const <String, dynamic>{},
        );
      }

      final bytes = await consolidateHttpClientResponseBytes(response);
      final directory = await getApplicationDocumentsDirectory();
      final file = File(
        '${directory.path}/${_safeName(_resolveName(fileName, response))}',
      );

      return file.writeAsBytes(bytes, flush: true);
    } on SocketException {
      throw ApiException(t('common.no_internet'), 0, const <String, dynamic>{});
    } finally {
      client.close();
    }
  }

  String _safeName(String raw) =>
      raw.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '-');

  /// Swaps in the extension the server actually sent (via
  /// `Content-Disposition: ...filename="x.ext"`) when it differs from the
  /// guessed one — a training certificate may be a scanned image rather than
  /// a PDF, and opening it with the wrong extension can fail to launch a
  /// viewer at all.
  String _resolveName(String fileName, HttpClientResponse response) {
    final disposition = response.headers.value(HttpHeaders.contentDisposition);
    final match = disposition == null
        ? null
        : RegExp(r'filename="?([^";]+)"?').firstMatch(disposition);
    final serverExtension = match == null
        ? null
        : _extensionOf(match.group(1)!);

    if (serverExtension == null) return fileName;

    final currentExtension = _extensionOf(fileName);
    if (currentExtension == serverExtension) return fileName;

    final base = currentExtension == null
        ? fileName
        : fileName.substring(0, fileName.length - currentExtension.length - 1);

    return '$base.$serverExtension';
  }

  String? _extensionOf(String name) {
    final dot = name.lastIndexOf('.');
    return dot == -1 || dot == name.length - 1
        ? null
        : name.substring(dot + 1).toLowerCase();
  }
}
