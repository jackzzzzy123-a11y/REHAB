// lib/data/models/import_batch.dart
//
// 汇入溯源（哪一份文件、何时、几笔）。用于审计与保留管理。
// 執行 `flutter pub run build_runner build --delete-conflicting-outputs` 生成 .freezed.dart / .g.dart。

import 'package:freezed_annotation/freezed_annotation.dart';

part 'import_batch.freezed.dart';
part 'import_batch.g.dart';

enum ImportFormat { json, csv, unknown }

@freezed
class ImportBatch with _$ImportBatch {
  const factory ImportBatch({
    required String batchId,
    required String sourceFileName,
    required ImportFormat format,
    required DateTime importedAt,
    required int recordCount,
  }) = _ImportBatch;

  factory ImportBatch.fromJson(Map<String, dynamic> json) =>
      _$ImportBatchFromJson(json);
}
