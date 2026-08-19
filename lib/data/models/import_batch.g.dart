// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_batch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ImportBatchImpl _$$ImportBatchImplFromJson(Map<String, dynamic> json) =>
    _$ImportBatchImpl(
      batchId: json['batchId'] as String,
      sourceFileName: json['sourceFileName'] as String,
      format: $enumDecode(_$ImportFormatEnumMap, json['format']),
      importedAt: DateTime.parse(json['importedAt'] as String),
      recordCount: (json['recordCount'] as num).toInt(),
    );

Map<String, dynamic> _$$ImportBatchImplToJson(_$ImportBatchImpl instance) =>
    <String, dynamic>{
      'batchId': instance.batchId,
      'sourceFileName': instance.sourceFileName,
      'format': _$ImportFormatEnumMap[instance.format]!,
      'importedAt': instance.importedAt.toIso8601String(),
      'recordCount': instance.recordCount,
    };

const _$ImportFormatEnumMap = {
  ImportFormat.json: 'json',
  ImportFormat.csv: 'csv',
  ImportFormat.unknown: 'unknown',
};
