// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MediaAssetImpl _$$MediaAssetImplFromJson(Map<String, dynamic> json) =>
    _$MediaAssetImpl(
      assetId: json['assetId'] as String,
      patientId: json['patientId'] as String,
      kind: $enumDecode(_$MediaKindEnumMap, json['kind']),
      storagePath: json['storagePath'] as String,
      capturedAt: DateTime.parse(json['capturedAt'] as String),
      backgroundBlurred: json['backgroundBlurred'] as bool,
      faceBlurred: json['faceBlurred'] as bool,
    );

Map<String, dynamic> _$$MediaAssetImplToJson(_$MediaAssetImpl instance) =>
    <String, dynamic>{
      'assetId': instance.assetId,
      'patientId': instance.patientId,
      'kind': _$MediaKindEnumMap[instance.kind]!,
      'storagePath': instance.storagePath,
      'capturedAt': instance.capturedAt.toIso8601String(),
      'backgroundBlurred': instance.backgroundBlurred,
      'faceBlurred': instance.faceBlurred,
    };

const _$MediaKindEnumMap = {
  MediaKind.image: 'image',
  MediaKind.video: 'video',
};
