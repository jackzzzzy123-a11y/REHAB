// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'patient_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PatientProfile _$PatientProfileFromJson(Map<String, dynamic> json) {
  return _PatientProfile.fromJson(json);
}

/// @nodoc
mixin _$PatientProfile {
  String get patientId => throw _privateConstructorUsedError; // 匿名内部识别码（非真实身份证）
  String get displayName => throw _privateConstructorUsedError; // 展示用代稱（Q7 含姓名）
  DateTime get dateOfBirth => throw _privateConstructorUsedError; // 出生年月
  double get heightCm => throw _privateConstructorUsedError;
  double get weightKg => throw _privateConstructorUsedError;
  String get rehabStage => throw _privateConstructorUsedError;
  String get expertId => throw _privateConstructorUsedError; // 绑定专家（同一时间仅 1 位）
  bool get isActive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PatientProfileCopyWith<PatientProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PatientProfileCopyWith<$Res> {
  factory $PatientProfileCopyWith(
          PatientProfile value, $Res Function(PatientProfile) then) =
      _$PatientProfileCopyWithImpl<$Res, PatientProfile>;
  @useResult
  $Res call(
      {String patientId,
      String displayName,
      DateTime dateOfBirth,
      double heightCm,
      double weightKg,
      String rehabStage,
      String expertId,
      bool isActive});
}

/// @nodoc
class _$PatientProfileCopyWithImpl<$Res, $Val extends PatientProfile>
    implements $PatientProfileCopyWith<$Res> {
  _$PatientProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? patientId = null,
    Object? displayName = null,
    Object? dateOfBirth = null,
    Object? heightCm = null,
    Object? weightKg = null,
    Object? rehabStage = null,
    Object? expertId = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      patientId: null == patientId
          ? _value.patientId
          : patientId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      dateOfBirth: null == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      heightCm: null == heightCm
          ? _value.heightCm
          : heightCm // ignore: cast_nullable_to_non_nullable
              as double,
      weightKg: null == weightKg
          ? _value.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as double,
      rehabStage: null == rehabStage
          ? _value.rehabStage
          : rehabStage // ignore: cast_nullable_to_non_nullable
              as String,
      expertId: null == expertId
          ? _value.expertId
          : expertId // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PatientProfileImplCopyWith<$Res>
    implements $PatientProfileCopyWith<$Res> {
  factory _$$PatientProfileImplCopyWith(_$PatientProfileImpl value,
          $Res Function(_$PatientProfileImpl) then) =
      __$$PatientProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String patientId,
      String displayName,
      DateTime dateOfBirth,
      double heightCm,
      double weightKg,
      String rehabStage,
      String expertId,
      bool isActive});
}

/// @nodoc
class __$$PatientProfileImplCopyWithImpl<$Res>
    extends _$PatientProfileCopyWithImpl<$Res, _$PatientProfileImpl>
    implements _$$PatientProfileImplCopyWith<$Res> {
  __$$PatientProfileImplCopyWithImpl(
      _$PatientProfileImpl _value, $Res Function(_$PatientProfileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? patientId = null,
    Object? displayName = null,
    Object? dateOfBirth = null,
    Object? heightCm = null,
    Object? weightKg = null,
    Object? rehabStage = null,
    Object? expertId = null,
    Object? isActive = null,
  }) {
    return _then(_$PatientProfileImpl(
      patientId: null == patientId
          ? _value.patientId
          : patientId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      dateOfBirth: null == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      heightCm: null == heightCm
          ? _value.heightCm
          : heightCm // ignore: cast_nullable_to_non_nullable
              as double,
      weightKg: null == weightKg
          ? _value.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as double,
      rehabStage: null == rehabStage
          ? _value.rehabStage
          : rehabStage // ignore: cast_nullable_to_non_nullable
              as String,
      expertId: null == expertId
          ? _value.expertId
          : expertId // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PatientProfileImpl implements _PatientProfile {
  const _$PatientProfileImpl(
      {required this.patientId,
      required this.displayName,
      required this.dateOfBirth,
      required this.heightCm,
      required this.weightKg,
      required this.rehabStage,
      required this.expertId,
      required this.isActive});

  factory _$PatientProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$PatientProfileImplFromJson(json);

  @override
  final String patientId;
// 匿名内部识别码（非真实身份证）
  @override
  final String displayName;
// 展示用代稱（Q7 含姓名）
  @override
  final DateTime dateOfBirth;
// 出生年月
  @override
  final double heightCm;
  @override
  final double weightKg;
  @override
  final String rehabStage;
  @override
  final String expertId;
// 绑定专家（同一时间仅 1 位）
  @override
  final bool isActive;

  @override
  String toString() {
    return 'PatientProfile(patientId: $patientId, displayName: $displayName, dateOfBirth: $dateOfBirth, heightCm: $heightCm, weightKg: $weightKg, rehabStage: $rehabStage, expertId: $expertId, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PatientProfileImpl &&
            (identical(other.patientId, patientId) ||
                other.patientId == patientId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.heightCm, heightCm) ||
                other.heightCm == heightCm) &&
            (identical(other.weightKg, weightKg) ||
                other.weightKg == weightKg) &&
            (identical(other.rehabStage, rehabStage) ||
                other.rehabStage == rehabStage) &&
            (identical(other.expertId, expertId) ||
                other.expertId == expertId) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, patientId, displayName,
      dateOfBirth, heightCm, weightKg, rehabStage, expertId, isActive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PatientProfileImplCopyWith<_$PatientProfileImpl> get copyWith =>
      __$$PatientProfileImplCopyWithImpl<_$PatientProfileImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PatientProfileImplToJson(
      this,
    );
  }
}

abstract class _PatientProfile implements PatientProfile {
  const factory _PatientProfile(
      {required final String patientId,
      required final String displayName,
      required final DateTime dateOfBirth,
      required final double heightCm,
      required final double weightKg,
      required final String rehabStage,
      required final String expertId,
      required final bool isActive}) = _$PatientProfileImpl;

  factory _PatientProfile.fromJson(Map<String, dynamic> json) =
      _$PatientProfileImpl.fromJson;

  @override
  String get patientId;
  @override // 匿名内部识别码（非真实身份证）
  String get displayName;
  @override // 展示用代稱（Q7 含姓名）
  DateTime get dateOfBirth;
  @override // 出生年月
  double get heightCm;
  @override
  double get weightKg;
  @override
  String get rehabStage;
  @override
  String get expertId;
  @override // 绑定专家（同一时间仅 1 位）
  bool get isActive;
  @override
  @JsonKey(ignore: true)
  _$$PatientProfileImplCopyWith<_$PatientProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
