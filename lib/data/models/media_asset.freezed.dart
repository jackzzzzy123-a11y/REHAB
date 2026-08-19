// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_asset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MediaAsset _$MediaAssetFromJson(Map<String, dynamic> json) {
  return _MediaAsset.fromJson(json);
}

/// @nodoc
mixin _$MediaAsset {
  String get assetId => throw _privateConstructorUsedError;
  String get patientId => throw _privateConstructorUsedError;
  MediaKind get kind => throw _privateConstructorUsedError;
  String get storagePath => throw _privateConstructorUsedError; // 已模糊、已加密
  DateTime get capturedAt => throw _privateConstructorUsedError;
  bool get backgroundBlurred => throw _privateConstructorUsedError;
  bool get faceBlurred => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MediaAssetCopyWith<MediaAsset> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MediaAssetCopyWith<$Res> {
  factory $MediaAssetCopyWith(
          MediaAsset value, $Res Function(MediaAsset) then) =
      _$MediaAssetCopyWithImpl<$Res, MediaAsset>;
  @useResult
  $Res call(
      {String assetId,
      String patientId,
      MediaKind kind,
      String storagePath,
      DateTime capturedAt,
      bool backgroundBlurred,
      bool faceBlurred});
}

/// @nodoc
class _$MediaAssetCopyWithImpl<$Res, $Val extends MediaAsset>
    implements $MediaAssetCopyWith<$Res> {
  _$MediaAssetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assetId = null,
    Object? patientId = null,
    Object? kind = null,
    Object? storagePath = null,
    Object? capturedAt = null,
    Object? backgroundBlurred = null,
    Object? faceBlurred = null,
  }) {
    return _then(_value.copyWith(
      assetId: null == assetId
          ? _value.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String,
      patientId: null == patientId
          ? _value.patientId
          : patientId // ignore: cast_nullable_to_non_nullable
              as String,
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as MediaKind,
      storagePath: null == storagePath
          ? _value.storagePath
          : storagePath // ignore: cast_nullable_to_non_nullable
              as String,
      capturedAt: null == capturedAt
          ? _value.capturedAt
          : capturedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      backgroundBlurred: null == backgroundBlurred
          ? _value.backgroundBlurred
          : backgroundBlurred // ignore: cast_nullable_to_non_nullable
              as bool,
      faceBlurred: null == faceBlurred
          ? _value.faceBlurred
          : faceBlurred // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MediaAssetImplCopyWith<$Res>
    implements $MediaAssetCopyWith<$Res> {
  factory _$$MediaAssetImplCopyWith(
          _$MediaAssetImpl value, $Res Function(_$MediaAssetImpl) then) =
      __$$MediaAssetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String assetId,
      String patientId,
      MediaKind kind,
      String storagePath,
      DateTime capturedAt,
      bool backgroundBlurred,
      bool faceBlurred});
}

/// @nodoc
class __$$MediaAssetImplCopyWithImpl<$Res>
    extends _$MediaAssetCopyWithImpl<$Res, _$MediaAssetImpl>
    implements _$$MediaAssetImplCopyWith<$Res> {
  __$$MediaAssetImplCopyWithImpl(
      _$MediaAssetImpl _value, $Res Function(_$MediaAssetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assetId = null,
    Object? patientId = null,
    Object? kind = null,
    Object? storagePath = null,
    Object? capturedAt = null,
    Object? backgroundBlurred = null,
    Object? faceBlurred = null,
  }) {
    return _then(_$MediaAssetImpl(
      assetId: null == assetId
          ? _value.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String,
      patientId: null == patientId
          ? _value.patientId
          : patientId // ignore: cast_nullable_to_non_nullable
              as String,
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as MediaKind,
      storagePath: null == storagePath
          ? _value.storagePath
          : storagePath // ignore: cast_nullable_to_non_nullable
              as String,
      capturedAt: null == capturedAt
          ? _value.capturedAt
          : capturedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      backgroundBlurred: null == backgroundBlurred
          ? _value.backgroundBlurred
          : backgroundBlurred // ignore: cast_nullable_to_non_nullable
              as bool,
      faceBlurred: null == faceBlurred
          ? _value.faceBlurred
          : faceBlurred // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MediaAssetImpl implements _MediaAsset {
  const _$MediaAssetImpl(
      {required this.assetId,
      required this.patientId,
      required this.kind,
      required this.storagePath,
      required this.capturedAt,
      required this.backgroundBlurred,
      required this.faceBlurred});

  factory _$MediaAssetImpl.fromJson(Map<String, dynamic> json) =>
      _$$MediaAssetImplFromJson(json);

  @override
  final String assetId;
  @override
  final String patientId;
  @override
  final MediaKind kind;
  @override
  final String storagePath;
// 已模糊、已加密
  @override
  final DateTime capturedAt;
  @override
  final bool backgroundBlurred;
  @override
  final bool faceBlurred;

  @override
  String toString() {
    return 'MediaAsset(assetId: $assetId, patientId: $patientId, kind: $kind, storagePath: $storagePath, capturedAt: $capturedAt, backgroundBlurred: $backgroundBlurred, faceBlurred: $faceBlurred)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MediaAssetImpl &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.patientId, patientId) ||
                other.patientId == patientId) &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.storagePath, storagePath) ||
                other.storagePath == storagePath) &&
            (identical(other.capturedAt, capturedAt) ||
                other.capturedAt == capturedAt) &&
            (identical(other.backgroundBlurred, backgroundBlurred) ||
                other.backgroundBlurred == backgroundBlurred) &&
            (identical(other.faceBlurred, faceBlurred) ||
                other.faceBlurred == faceBlurred));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, assetId, patientId, kind,
      storagePath, capturedAt, backgroundBlurred, faceBlurred);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MediaAssetImplCopyWith<_$MediaAssetImpl> get copyWith =>
      __$$MediaAssetImplCopyWithImpl<_$MediaAssetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MediaAssetImplToJson(
      this,
    );
  }
}

abstract class _MediaAsset implements MediaAsset {
  const factory _MediaAsset(
      {required final String assetId,
      required final String patientId,
      required final MediaKind kind,
      required final String storagePath,
      required final DateTime capturedAt,
      required final bool backgroundBlurred,
      required final bool faceBlurred}) = _$MediaAssetImpl;

  factory _MediaAsset.fromJson(Map<String, dynamic> json) =
      _$MediaAssetImpl.fromJson;

  @override
  String get assetId;
  @override
  String get patientId;
  @override
  MediaKind get kind;
  @override
  String get storagePath;
  @override // 已模糊、已加密
  DateTime get capturedAt;
  @override
  bool get backgroundBlurred;
  @override
  bool get faceBlurred;
  @override
  @JsonKey(ignore: true)
  _$$MediaAssetImplCopyWith<_$MediaAssetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
