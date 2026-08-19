// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rehab_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SnapshotSummary _$SnapshotSummaryFromJson(Map<String, dynamic> json) {
  return _SnapshotSummary.fromJson(json);
}

/// @nodoc
mixin _$SnapshotSummary {
  double? get completionRate => throw _privateConstructorUsedError; // 完成率（%）
  String? get trendDirection =>
      throw _privateConstructorUsedError; // 'up' | 'down' | 'flat'
  RehabRisk? get riskLevel => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SnapshotSummaryCopyWith<SnapshotSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SnapshotSummaryCopyWith<$Res> {
  factory $SnapshotSummaryCopyWith(
          SnapshotSummary value, $Res Function(SnapshotSummary) then) =
      _$SnapshotSummaryCopyWithImpl<$Res, SnapshotSummary>;
  @useResult
  $Res call(
      {double? completionRate,
      String? trendDirection,
      RehabRisk? riskLevel,
      String? note});
}

/// @nodoc
class _$SnapshotSummaryCopyWithImpl<$Res, $Val extends SnapshotSummary>
    implements $SnapshotSummaryCopyWith<$Res> {
  _$SnapshotSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? completionRate = freezed,
    Object? trendDirection = freezed,
    Object? riskLevel = freezed,
    Object? note = freezed,
  }) {
    return _then(_value.copyWith(
      completionRate: freezed == completionRate
          ? _value.completionRate
          : completionRate // ignore: cast_nullable_to_non_nullable
              as double?,
      trendDirection: freezed == trendDirection
          ? _value.trendDirection
          : trendDirection // ignore: cast_nullable_to_non_nullable
              as String?,
      riskLevel: freezed == riskLevel
          ? _value.riskLevel
          : riskLevel // ignore: cast_nullable_to_non_nullable
              as RehabRisk?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SnapshotSummaryImplCopyWith<$Res>
    implements $SnapshotSummaryCopyWith<$Res> {
  factory _$$SnapshotSummaryImplCopyWith(_$SnapshotSummaryImpl value,
          $Res Function(_$SnapshotSummaryImpl) then) =
      __$$SnapshotSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double? completionRate,
      String? trendDirection,
      RehabRisk? riskLevel,
      String? note});
}

/// @nodoc
class __$$SnapshotSummaryImplCopyWithImpl<$Res>
    extends _$SnapshotSummaryCopyWithImpl<$Res, _$SnapshotSummaryImpl>
    implements _$$SnapshotSummaryImplCopyWith<$Res> {
  __$$SnapshotSummaryImplCopyWithImpl(
      _$SnapshotSummaryImpl _value, $Res Function(_$SnapshotSummaryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? completionRate = freezed,
    Object? trendDirection = freezed,
    Object? riskLevel = freezed,
    Object? note = freezed,
  }) {
    return _then(_$SnapshotSummaryImpl(
      completionRate: freezed == completionRate
          ? _value.completionRate
          : completionRate // ignore: cast_nullable_to_non_nullable
              as double?,
      trendDirection: freezed == trendDirection
          ? _value.trendDirection
          : trendDirection // ignore: cast_nullable_to_non_nullable
              as String?,
      riskLevel: freezed == riskLevel
          ? _value.riskLevel
          : riskLevel // ignore: cast_nullable_to_non_nullable
              as RehabRisk?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SnapshotSummaryImpl implements _SnapshotSummary {
  const _$SnapshotSummaryImpl(
      {this.completionRate, this.trendDirection, this.riskLevel, this.note});

  factory _$SnapshotSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$SnapshotSummaryImplFromJson(json);

  @override
  final double? completionRate;
// 完成率（%）
  @override
  final String? trendDirection;
// 'up' | 'down' | 'flat'
  @override
  final RehabRisk? riskLevel;
  @override
  final String? note;

  @override
  String toString() {
    return 'SnapshotSummary(completionRate: $completionRate, trendDirection: $trendDirection, riskLevel: $riskLevel, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SnapshotSummaryImpl &&
            (identical(other.completionRate, completionRate) ||
                other.completionRate == completionRate) &&
            (identical(other.trendDirection, trendDirection) ||
                other.trendDirection == trendDirection) &&
            (identical(other.riskLevel, riskLevel) ||
                other.riskLevel == riskLevel) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, completionRate, trendDirection, riskLevel, note);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SnapshotSummaryImplCopyWith<_$SnapshotSummaryImpl> get copyWith =>
      __$$SnapshotSummaryImplCopyWithImpl<_$SnapshotSummaryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SnapshotSummaryImplToJson(
      this,
    );
  }
}

abstract class _SnapshotSummary implements SnapshotSummary {
  const factory _SnapshotSummary(
      {final double? completionRate,
      final String? trendDirection,
      final RehabRisk? riskLevel,
      final String? note}) = _$SnapshotSummaryImpl;

  factory _SnapshotSummary.fromJson(Map<String, dynamic> json) =
      _$SnapshotSummaryImpl.fromJson;

  @override
  double? get completionRate;
  @override // 完成率（%）
  String? get trendDirection;
  @override // 'up' | 'down' | 'flat'
  RehabRisk? get riskLevel;
  @override
  String? get note;
  @override
  @JsonKey(ignore: true)
  _$$SnapshotSummaryImplCopyWith<_$SnapshotSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RehabSnapshot _$RehabSnapshotFromJson(Map<String, dynamic> json) {
  return _RehabSnapshot.fromJson(json);
}

/// @nodoc
mixin _$RehabSnapshot {
  String get patientId => throw _privateConstructorUsedError;
  String get batchId => throw _privateConstructorUsedError; // 对应 import_batch
  DateTime get testDate =>
      throw _privateConstructorUsedError; // 测试/评估日期（纵向对比关键）
  List<Metric> get metrics => throw _privateConstructorUsedError; // 数据驱动：有什么画什么
  SnapshotSummary? get summary => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RehabSnapshotCopyWith<RehabSnapshot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RehabSnapshotCopyWith<$Res> {
  factory $RehabSnapshotCopyWith(
          RehabSnapshot value, $Res Function(RehabSnapshot) then) =
      _$RehabSnapshotCopyWithImpl<$Res, RehabSnapshot>;
  @useResult
  $Res call(
      {String patientId,
      String batchId,
      DateTime testDate,
      List<Metric> metrics,
      SnapshotSummary? summary});

  $SnapshotSummaryCopyWith<$Res>? get summary;
}

/// @nodoc
class _$RehabSnapshotCopyWithImpl<$Res, $Val extends RehabSnapshot>
    implements $RehabSnapshotCopyWith<$Res> {
  _$RehabSnapshotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? patientId = null,
    Object? batchId = null,
    Object? testDate = null,
    Object? metrics = null,
    Object? summary = freezed,
  }) {
    return _then(_value.copyWith(
      patientId: null == patientId
          ? _value.patientId
          : patientId // ignore: cast_nullable_to_non_nullable
              as String,
      batchId: null == batchId
          ? _value.batchId
          : batchId // ignore: cast_nullable_to_non_nullable
              as String,
      testDate: null == testDate
          ? _value.testDate
          : testDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metrics: null == metrics
          ? _value.metrics
          : metrics // ignore: cast_nullable_to_non_nullable
              as List<Metric>,
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as SnapshotSummary?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SnapshotSummaryCopyWith<$Res>? get summary {
    if (_value.summary == null) {
      return null;
    }

    return $SnapshotSummaryCopyWith<$Res>(_value.summary!, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RehabSnapshotImplCopyWith<$Res>
    implements $RehabSnapshotCopyWith<$Res> {
  factory _$$RehabSnapshotImplCopyWith(
          _$RehabSnapshotImpl value, $Res Function(_$RehabSnapshotImpl) then) =
      __$$RehabSnapshotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String patientId,
      String batchId,
      DateTime testDate,
      List<Metric> metrics,
      SnapshotSummary? summary});

  @override
  $SnapshotSummaryCopyWith<$Res>? get summary;
}

/// @nodoc
class __$$RehabSnapshotImplCopyWithImpl<$Res>
    extends _$RehabSnapshotCopyWithImpl<$Res, _$RehabSnapshotImpl>
    implements _$$RehabSnapshotImplCopyWith<$Res> {
  __$$RehabSnapshotImplCopyWithImpl(
      _$RehabSnapshotImpl _value, $Res Function(_$RehabSnapshotImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? patientId = null,
    Object? batchId = null,
    Object? testDate = null,
    Object? metrics = null,
    Object? summary = freezed,
  }) {
    return _then(_$RehabSnapshotImpl(
      patientId: null == patientId
          ? _value.patientId
          : patientId // ignore: cast_nullable_to_non_nullable
              as String,
      batchId: null == batchId
          ? _value.batchId
          : batchId // ignore: cast_nullable_to_non_nullable
              as String,
      testDate: null == testDate
          ? _value.testDate
          : testDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metrics: null == metrics
          ? _value._metrics
          : metrics // ignore: cast_nullable_to_non_nullable
              as List<Metric>,
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as SnapshotSummary?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RehabSnapshotImpl implements _RehabSnapshot {
  const _$RehabSnapshotImpl(
      {required this.patientId,
      required this.batchId,
      required this.testDate,
      required final List<Metric> metrics,
      this.summary})
      : _metrics = metrics;

  factory _$RehabSnapshotImpl.fromJson(Map<String, dynamic> json) =>
      _$$RehabSnapshotImplFromJson(json);

  @override
  final String patientId;
  @override
  final String batchId;
// 对应 import_batch
  @override
  final DateTime testDate;
// 测试/评估日期（纵向对比关键）
  final List<Metric> _metrics;
// 测试/评估日期（纵向对比关键）
  @override
  List<Metric> get metrics {
    if (_metrics is EqualUnmodifiableListView) return _metrics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_metrics);
  }

// 数据驱动：有什么画什么
  @override
  final SnapshotSummary? summary;

  @override
  String toString() {
    return 'RehabSnapshot(patientId: $patientId, batchId: $batchId, testDate: $testDate, metrics: $metrics, summary: $summary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RehabSnapshotImpl &&
            (identical(other.patientId, patientId) ||
                other.patientId == patientId) &&
            (identical(other.batchId, batchId) || other.batchId == batchId) &&
            (identical(other.testDate, testDate) ||
                other.testDate == testDate) &&
            const DeepCollectionEquality().equals(other._metrics, _metrics) &&
            (identical(other.summary, summary) || other.summary == summary));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, patientId, batchId, testDate,
      const DeepCollectionEquality().hash(_metrics), summary);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RehabSnapshotImplCopyWith<_$RehabSnapshotImpl> get copyWith =>
      __$$RehabSnapshotImplCopyWithImpl<_$RehabSnapshotImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RehabSnapshotImplToJson(
      this,
    );
  }
}

abstract class _RehabSnapshot implements RehabSnapshot {
  const factory _RehabSnapshot(
      {required final String patientId,
      required final String batchId,
      required final DateTime testDate,
      required final List<Metric> metrics,
      final SnapshotSummary? summary}) = _$RehabSnapshotImpl;

  factory _RehabSnapshot.fromJson(Map<String, dynamic> json) =
      _$RehabSnapshotImpl.fromJson;

  @override
  String get patientId;
  @override
  String get batchId;
  @override // 对应 import_batch
  DateTime get testDate;
  @override // 测试/评估日期（纵向对比关键）
  List<Metric> get metrics;
  @override // 数据驱动：有什么画什么
  SnapshotSummary? get summary;
  @override
  @JsonKey(ignore: true)
  _$$RehabSnapshotImplCopyWith<_$RehabSnapshotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
