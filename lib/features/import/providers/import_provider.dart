// lib/features/import/providers/import_provider.dart
//
// 匯入精靈狀態（P1-3）。流程：選檔 → 解析 → 驗證 → 入庫 → 本機通知。
// 複用 P1-2 的 RehabRepository（解析 / 入庫 / 審計）與 NotificationService。

import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/notification/notification_providers.dart';
import '../../../core/notification/notification_service.dart';
import '../../../data/datasources/rehab_data_source.dart';
import '../../../data/models/import_batch.dart';
import '../../../data/providers/rehab_providers.dart';
import '../../../data/repositories/rehab_repository.dart';

enum ImportStep { idle, picking, parsing, validating, writing, done, error }

class ImportState {
  const ImportState({
    this.step = ImportStep.idle,
    this.contract,
    this.error,
    this.fileName,
  });

  final ImportStep step;
  final ImportContract? contract;
  final String? error;
  final String? fileName;

  bool get isBusy =>
      step == ImportStep.picking ||
      step == ImportStep.parsing ||
      step == ImportStep.validating ||
      step == ImportStep.writing;

  ImportState copyWith({
    ImportStep? step,
    ImportContract? contract,
    String? error,
    String? fileName,
    bool clearError = false,
  }) =>
      ImportState(
        step: step ?? this.step,
        contract: contract ?? this.contract,
        error: clearError ? null : (error ?? this.error),
        fileName: fileName ?? this.fileName,
      );
}

final importProvider =
    StateNotifierProvider<ImportNotifier, ImportState>((ref) {
  return ImportNotifier(
    repositoryFuture: ref.watch(rehabRepositoryProvider.future),
    notification: ref.watch(notificationServiceProvider),
  );
});

class ImportNotifier extends StateNotifier<ImportState> {
  ImportNotifier({
    required this.repositoryFuture,
    required this.notification,
  }) : super(const ImportState());

  final Future<RehabRepository> repositoryFuture;
  final NotificationService notification;

  Future<void> pickAndImport() async {
    if (state.isBusy) return;
    state = state.copyWith(
      step: ImportStep.picking,
      clearError: true,
    );

    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['json', 'csv'],
      withData: true,
    );
    if (picked == null || picked.files.isEmpty) {
      state = state.copyWith(step: ImportStep.idle);
      return;
    }

    final file = picked.files.single;
    final bytes = file.bytes;
    if (bytes == null) {
      state = state.copyWith(step: ImportStep.error, error: '無法讀取檔案內容');
      return;
    }

    final content = utf8.decode(bytes, allowMalformed: true);
    final ext = (file.extension ?? '').toLowerCase();
    final format = switch (ext) {
      'json' => ImportFormat.json,
      'csv' => ImportFormat.csv,
      _ => ImportFormat.unknown,
    };

    state = state.copyWith(step: ImportStep.parsing, fileName: file.name);

    try {
      state = state.copyWith(step: ImportStep.validating);
      final repo = await repositoryFuture;
      final contract = await repo.import(content, format);
      state = state.copyWith(step: ImportStep.writing, contract: contract);
      await _notify(contract);
      state = state.copyWith(step: ImportStep.done);
    } on ImportValidationException catch (e) {
      state = state.copyWith(step: ImportStep.error, error: e.message);
    } catch (e) {
      state = state.copyWith(step: ImportStep.error, error: '匯入失敗：$e');
    }
  }

  Future<void> _notify(ImportContract contract) async {
    try {
      final imported = contract.snapshots.length;
      final name = contract.patient.displayName;
      await notification.showLocal(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: '匯入完成',
        body: '已匯入 $imported 筆（$name）',
      );
    } catch (_) {
      // 本機通知失敗不影響匯入結果（頁面成功 UI 為主反饋）。
    }
  }

  void reset() => state = const ImportState();
}
