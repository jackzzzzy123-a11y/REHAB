// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'import_batch.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ImportBatch _$ImportBatchFromJson(Map<String, dynamic> json) {
  return _ImportBatch.fromJson(json);
}

/// @nodoc
mixin _$ImportBatch {
  String get batchId => throw _privateConstructorUsedError;
  String get sourceFileName => throw _privateConstructorUsedError;
  ImportFormat get format => throw _privateConstructorUsedError;
  DateTime get importedAt => throw _privateConstructorUsedError;
  int get recordCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ImportBatchCopyWith<ImportBatch> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImportBatchCopyWith<$Res> {
  factory $ImportBatchCopyWith(
          ImportBatch value, $Res Function(ImportBatch) then) =
      _$ImportBatchCopyWithImpl<$Res, ImportBatch>;
  @useResult
  $Res call(
      {String batchId,
      String sourceFileName,
      ImportFormat format,
      DateTime importedAt,
      int recordCount});
}

/// @nodoc
class _$ImportBatchCopyWithImpl<$Res, $Val extends ImportBatch>
    implements $ImportBatchCopyWith<$Res> {
  _$ImportBatchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? batchId = null,
    Object? sourceFileName = null,
    Object? format = null,
    Object? importedAt = null,
    Object? recordCount = null,
  }) {
    return _then(_value.copyWith(
      batchId: null == batchId
          ? _value.batchId
          : batchId // ignore: cast_nullable_to_non_nullable
              as String,
      sourceFileName: null == sourceFileName
          ? _value.sourceFileName
          : sourceFileName // ignore: cast_nullable_to_non_nullable
              as String,
      format: null == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as ImportFormat,
      importedAt: null == importedAt
          ? _value.importedAt
          : importedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      recordCount: null == recordCount
          ? _value.recordCount
          : recordCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ImportBatchImplCopyWith<$Res>
    implements $ImportBatchCopyWith<$Res> {
  factory _$$ImportBatchImplCopyWith(
          _$ImportBatchImpl value, $Res Function(_$ImportBatchImpl) then) =
      __$$ImportBatchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String batchId,
      String sourceFileName,
      ImportFormat format,
      DateTime importedAt,
      int recordCount});
}

/// @nodoc
class __$$ImportBatchImplCopyWithImpl<$Res>
    extends _$ImportBatchCopyWithImpl<$Res, _$ImportBatchImpl>
    implements _$$ImportBatchImplCopyWith<$Res> {
  __$$ImportBatchImplCopyWithImpl(
      _$ImportBatchImpl _value, $Res Function(_$ImportBatchImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? batchId = null,
    Object? sourceFileName = null,
    Object? format = null,
    Object? importedAt = null,
    Object? recordCount = null,
  }) {
    return _then(_$ImportBatchImpl(
      batchId: null == batchId
          ? _value.batchId
          : batchId // ignore: cast_nullable_to_non_nullable
              as String,
      sourceFileName: null == sourceFileName
          ? _value.sourceFileName
          : sourceFileName // ignore: cast_nullable_to_non_nullable
              as String,
      format: null == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as ImportFormat,
      importedAt: null == importedAt
          ? _value.importedAt
          : importedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      recordCount: null == recordCount
          ? _value.recordCount
          : recordCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ImportBatchImpl implements _ImportBatch {
  const _$ImportBatchImpl(
      {required this.batchId,
      required this.sourceFileName,
      required this.format,
      required this.importedAt,
      required this.recordCount});

  factory _$ImportBatchImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImportBatchImplFromJson(json);

  @override
  final String batchId;
  @override
  final String sourceFileName;
  @override
  final ImportFormat format;
  @override
  final DateTime importedAt;
  @override
  final int recordCount;

  @override
  String toString() {
    return 'ImportBatch(batchId: $batchId, sourceFileName: $sourceFileName, format: $format, importedAt: $importedAt, recordCount: $recordCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImportBatchImpl &&
            (identical(other.batchId, batchId) || other.batchId == batchId) &&
            (identical(other.sourceFileName, sourceFileName) ||
                other.sourceFileName == sourceFileName) &&
            (identical(other.format, format) || other.format == format) &&
            (identical(other.importedAt, importedAt) ||
                other.importedAt == importedAt) &&
            (identical(other.recordCount, recordCount) ||
                other.recordCount == recordCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, batchId, sourceFileName, format, importedAt, recordCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ImportBatchImplCopyWith<_$ImportBatchImpl> get copyWith =>
      __$$ImportBatchImplCopyWithImpl<_$ImportBatchImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ImportBatchImplToJson(
      this,
    );
  }
}

abstract class _ImportBatch implements ImportBatch {
  const factory _ImportBatch(
      {required final String batchId,
      required final String sourceFileName,
      required final ImportFormat format,
      required final DateTime importedAt,
      required final int recordCount}) = _$ImportBatchImpl;

  factory _ImportBatch.fromJson(Map<String, dynamic> json) =
      _$ImportBatchImpl.fromJson;

  @override
  String get batchId;
  @override
  String get sourceFileName;
  @override
  ImportFormat get format;
  @override
  DateTime get importedAt;
  @override
  int get recordCount;
  @override
  @JsonKey(ignore: true)
  _$$ImportBatchImplCopyWith<_$ImportBatchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
