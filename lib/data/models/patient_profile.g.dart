// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PatientProfileImpl _$$PatientProfileImplFromJson(Map<String, dynamic> json) =>
    _$PatientProfileImpl(
      patientId: json['patientId'] as String,
      displayName: json['displayName'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      heightCm: (json['heightCm'] as num).toDouble(),
      weightKg: (json['weightKg'] as num).toDouble(),
      rehabStage: json['rehabStage'] as String,
      expertId: json['expertId'] as String,
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$$PatientProfileImplToJson(
        _$PatientProfileImpl instance) =>
    <String, dynamic>{
      'patientId': instance.patientId,
      'displayName': instance.displayName,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
      'heightCm': instance.heightCm,
      'weightKg': instance.weightKg,
      'rehabStage': instance.rehabStage,
      'expertId': instance.expertId,
      'isActive': instance.isActive,
    };
