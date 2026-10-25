import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../l10n/app_localizations.dart';
import 'firestore_service.dart';

class ExportResult {
  final bool success;
  final String? filePath;
  final String? errorMessage;
  final String? errorCode;

  const ExportResult({
    required this.success,
    this.filePath,
    this.errorMessage,
    this.errorCode,
  });

  String? localizedError(AppLocalizations l10n) {
    if (success) return null;

    switch (errorCode) {
      case 'storage-unavailable':
        return l10n.exportStorageUnavailable;
      case 'export-failed':
        return l10n.settingsExportFailed;
      default:
        return l10n.settingsExportFailed;
    }
  }
}

class ExportService {
  final FirestoreService _firestore = FirestoreService();

  Future<ExportResult> exportUserData(String uid) async {
    try {
      final payload = await _firestore.buildExportPayload(uid);

      final jsonString = const JsonEncoder.withIndent(
        '  ',
      ).convert(payload);

      final timestamp = DateFormat(
        'yyyy-MM-dd_HH-mm-ss',
      ).format(DateTime.now());

      final fileName = 'mushroom_log_$timestamp.json';

      final directory = await _resolveExportDirectory();

      await directory.create(recursive: true);

      final file = File(
        '${directory.path}${Platform.pathSeparator}$fileName',
      );

      await file.writeAsString(
        jsonString,
        encoding: utf8,
        flush: true,
      );

      return ExportResult(
        success: true,
        filePath: file.path,
      );
    } on FileSystemException {
      return const ExportResult(
        success: false,
        errorCode: 'storage-unavailable',
        errorMessage: 'Не удалось сохранить файл в хранилище.',
      );
    } catch (_) {
      return const ExportResult(
        success: false,
        errorCode: 'export-failed',
        errorMessage: 'Не удалось экспортировать данные.',
      );
    }
  }

  Future<Directory> _resolveExportDirectory() async {
    if (Platform.isAndroid) {
      final external = await getExternalStorageDirectory();

      if (external != null) {
        return Directory(
          '${external.path}${Platform.pathSeparator}exports',
        );
      }
    }

    final documents = await getApplicationDocumentsDirectory();

    return Directory(
      '${documents.path}${Platform.pathSeparator}exports',
    );
  }
}
