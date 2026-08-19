// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metric.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReferenceRangeImpl _$$ReferenceRangeImplFromJson(Map<String, dynamic> json) =>
    _$ReferenceRangeImpl(
      low: (json['low'] as num).toDouble(),
      high: (json['high'] as num).toDouble(),
      normalLow: (json['normalLow'] as num?)?.toDouble(),
      normalHigh: (json['normalHigh'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$ReferenceRangeImplToJson(
        _$ReferenceRangeImpl instance) =>
    <String, dynamic>{
      'low': instance.low,
      'high': instance.high,
      'normalLow': instance.normalLow,
      'normalHigh': instance.normalHigh,
    };

_$MetricImpl _$$MetricImplFromJson(Map<String, dynamic> json) => _$MetricImpl(
      key: json['key'] as String,
      label: json['label'] as String,
      kind: $enumDecode(_$MetricKindEnumMap, json['kind']),
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String,
      referenceRange: json['referenceRange'] == null
          ? null
          : ReferenceRange.fromJson(
              json['referenceRange'] as Map<String, dynamic>),
      status: $enumDecodeNullable(_$MetricStatusEnumMap, json['status']),
      category: json['category'] as String?,
      series: (json['series'] as List<dynamic>?)
              ?.map((e) => TrendPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <TrendPoint>[],
      ext: json['ext'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$MetricImplToJson(_$MetricImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'label': instance.label,
      'kind': _$MetricKindEnumMap[instance.kind]!,
      'value': instance.value,
      'unit': instance.unit,
      'referenceRange': instance.referenceRange?.toJson(),
      'status': _$MetricStatusEnumMap[instance.status],
      'category': instance.category,
      'series': instance.series.map((e) => e.toJson()).toList(),
      'ext': instance.ext,
    };

const _$MetricKindEnumMap = {
  MetricKind.percentage: 'percentage',
  MetricKind.numeric: 'numeric',
  MetricKind.score: 'score',
  MetricKind.enumeration: 'enumeration',
};

const _$MetricStatusEnumMap = {
  MetricStatus.normal: 'normal',
  MetricStatus.warning: 'warning',
  MetricStatus.abnormal: 'abnormal',
};
