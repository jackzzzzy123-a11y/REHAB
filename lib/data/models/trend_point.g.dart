// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trend_point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TrendPointImpl _$$TrendPointImplFromJson(Map<String, dynamic> json) =>
    _$TrendPointImpl(
      at: DateTime.parse(json['at'] as String),
      value: (json['value'] as num).toDouble(),
      metricKey: json['metricKey'] as String,
    );

Map<String, dynamic> _$$TrendPointImplToJson(_$TrendPointImpl instance) =>
    <String, dynamic>{
      'at': instance.at.toIso8601String(),
      'value': instance.value,
      'metricKey': instance.metricKey,
    };
