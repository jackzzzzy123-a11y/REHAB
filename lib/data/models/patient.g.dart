// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PatientImpl _$$PatientImplFromJson(Map<String, dynamic> json) =>
    _$PatientImpl(
      patientId: json['patientId'] as String,
      displayName: json['displayName'] as String,
      rehabStage: json['rehabStage'] as String,
      bedNo: json['bedNo'] as String?,
    );

Map<String, dynamic> _$$PatientImplToJson(_$PatientImpl instance) =>
    <String, dynamic>{
      'patientId': instance.patientId,
      'displayName': instance.displayName,
      'rehabStage': instance.rehabStage,
      'bedNo': instance.bedNo,
    };
