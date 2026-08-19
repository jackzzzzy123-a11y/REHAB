// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'metric.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReferenceRange _$ReferenceRangeFromJson(Map<String, dynamic> json) {
  return _ReferenceRange.fromJson(json);
}

/// @nodoc
mixin _$ReferenceRange {
  double get low => throw _privateConstructorUsedError;
  double get high => throw _privateConstructorUsedError;
  double? get normalLow => throw _privateConstructorUsedError;
  double? get normalHigh => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReferenceRangeCopyWith<ReferenceRange> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReferenceRangeCopyWith<$Res> {
  factory $ReferenceRangeCopyWith(
          ReferenceRange value, $Res Function(ReferenceRange) then) =
      _$ReferenceRangeCopyWithImpl<$Res, ReferenceRange>;
  @useResult
  $Res call({double low, double high, double? normalLow, double? normalHigh});
}

/// @nodoc
class _$ReferenceRangeCopyWithImpl<$Res, $Val extends ReferenceRange>
    implements $ReferenceRangeCopyWith<$Res> {
  _$ReferenceRangeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? low = null,
    Object? high = null,
    Object? normalLow = freezed,
    Object? normalHigh = freezed,
  }) {
    return _then(_value.copyWith(
      low: null == low
          ? _value.low
          : low // ignore: cast_nullable_to_non_nullable
              as double,
      high: null == high
          ? _value.high
          : high // ignore: cast_nullable_to_non_nullable
              as double,
      normalLow: freezed == normalLow
          ? _value.normalLow
          : normalLow // ignore: cast_nullable_to_non_nullable
              as double?,
      normalHigh: freezed == normalHigh
          ? _value.normalHigh
          : normalHigh // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReferenceRangeImplCopyWith<$Res>
    implements $ReferenceRangeCopyWith<$Res> {
  factory _$$ReferenceRangeImplCopyWith(_$ReferenceRangeImpl value,
          $Res Function(_$ReferenceRangeImpl) then) =
      __$$ReferenceRangeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double low, double high, double? normalLow, double? normalHigh});
}

/// @nodoc
class __$$ReferenceRangeImplCopyWithImpl<$Res>
    extends _$ReferenceRangeCopyWithImpl<$Res, _$ReferenceRangeImpl>
    implements _$$ReferenceRangeImplCopyWith<$Res> {
  __$$ReferenceRangeImplCopyWithImpl(
      _$ReferenceRangeImpl _value, $Res Function(_$ReferenceRangeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? low = null,
    Object? high = null,
    Object? normalLow = freezed,
    Object? normalHigh = freezed,
  }) {
    return _then(_$ReferenceRangeImpl(
      low: null == low
          ? _value.low
          : low // ignore: cast_nullable_to_non_nullable
              as double,
      high: null == high
          ? _value.high
          : high // ignore: cast_nullable_to_non_nullable
              as double,
      normalLow: freezed == normalLow
          ? _value.normalLow
          : normalLow // ignore: cast_nullable_to_non_nullable
              as double?,
      normalHigh: freezed == normalHigh
          ? _value.normalHigh
          : normalHigh // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReferenceRangeImpl implements _ReferenceRange {
  const _$ReferenceRangeImpl(
      {required this.low, required this.high, this.normalLow, this.normalHigh});

  factory _$ReferenceRangeImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReferenceRangeImplFromJson(json);

  @override
  final double low;
  @override
  final double high;
  @override
  final double? normalLow;
  @override
  final double? normalHigh;

  @override
  String toString() {
    return 'ReferenceRange(low: $low, high: $high, normalLow: $normalLow, normalHigh: $normalHigh)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReferenceRangeImpl &&
            (identical(other.low, low) || other.low == low) &&
            (identical(other.high, high) || other.high == high) &&
            (identical(other.normalLow, normalLow) ||
                other.normalLow == normalLow) &&
            (identical(other.normalHigh, normalHigh) ||
                other.normalHigh == normalHigh));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, low, high, normalLow, normalHigh);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReferenceRangeImplCopyWith<_$ReferenceRangeImpl> get copyWith =>
      __$$ReferenceRangeImplCopyWithImpl<_$ReferenceRangeImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReferenceRangeImplToJson(
      this,
    );
  }
}

abstract class _ReferenceRange implements ReferenceRange {
  const factory _ReferenceRange(
      {required final double low,
      required final double high,
      final double? normalLow,
      final double? normalHigh}) = _$ReferenceRangeImpl;

  factory _ReferenceRange.fromJson(Map<String, dynamic> json) =
      _$ReferenceRangeImpl.fromJson;

  @override
  double get low;
  @override
  double get high;
  @override
  double? get normalLow;
  @override
  double? get normalHigh;
  @override
  @JsonKey(ignore: true)
  _$$ReferenceRangeImplCopyWith<_$ReferenceRangeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Metric _$MetricFromJson(Map<String, dynamic> json) {
  return _Metric.fromJson(json);
}

/// @nodoc
mixin _$Metric {
  String get key => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  MetricKind get kind => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  ReferenceRange? get referenceRange => throw _privateConstructorUsedError;
  MetricStatus? get status => throw _privateConstructorUsedError;

  /// 雷达图分组键（如 mobility / balance），多指标同屏聚合用。
  String? get category => throw _privateConstructorUsedError;

  /// 该指标的纵向时序点（同病人不同测试批次），用于趋势对比。
  List<TrendPoint> get series => throw _privateConstructorUsedError;

  /// 未知字段原样保留，避免汇入时丢信息（schema 无关缓冲）。
  Map<String, dynamic>? get ext => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MetricCopyWith<Metric> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetricCopyWith<$Res> {
  factory $MetricCopyWith(Metric value, $Res Function(Metric) then) =
      _$MetricCopyWithImpl<$Res, Metric>;
  @useResult
  $Res call(
      {String key,
      String label,
      MetricKind kind,
      double value,
      String unit,
      ReferenceRange? referenceRange,
      MetricStatus? status,
      String? category,
      List<TrendPoint> series,
      Map<String, dynamic>? ext});

  $ReferenceRangeCopyWith<$Res>? get referenceRange;
}

/// @nodoc
class _$MetricCopyWithImpl<$Res, $Val extends Metric>
    implements $MetricCopyWith<$Res> {
  _$MetricCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? label = null,
    Object? kind = null,
    Object? value = null,
    Object? unit = null,
    Object? referenceRange = freezed,
    Object? status = freezed,
    Object? category = freezed,
    Object? series = null,
    Object? ext = freezed,
  }) {
    return _then(_value.copyWith(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as MetricKind,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      referenceRange: freezed == referenceRange
          ? _value.referenceRange
          : referenceRange // ignore: cast_nullable_to_non_nullable
              as ReferenceRange?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MetricStatus?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      series: null == series
          ? _value.series
          : series // ignore: cast_nullable_to_non_nullable
              as List<TrendPoint>,
      ext: freezed == ext
          ? _value.ext
          : ext // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ReferenceRangeCopyWith<$Res>? get referenceRange {
    if (_value.referenceRange == null) {
      return null;
    }

    return $ReferenceRangeCopyWith<$Res>(_value.referenceRange!, (value) {
      return _then(_value.copyWith(referenceRange: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MetricImplCopyWith<$Res> implements $MetricCopyWith<$Res> {
  factory _$$MetricImplCopyWith(
          _$MetricImpl value, $Res Function(_$MetricImpl) then) =
      __$$MetricImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String key,
      String label,
      MetricKind kind,
      double value,
      String unit,
      ReferenceRange? referenceRange,
      MetricStatus? status,
      String? category,
      List<TrendPoint> series,
      Map<String, dynamic>? ext});

  @override
  $ReferenceRangeCopyWith<$Res>? get referenceRange;
}

/// @nodoc
class __$$MetricImplCopyWithImpl<$Res>
    extends _$MetricCopyWithImpl<$Res, _$MetricImpl>
    implements _$$MetricImplCopyWith<$Res> {
  __$$MetricImplCopyWithImpl(
      _$MetricImpl _value, $Res Function(_$MetricImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? label = null,
    Object? kind = null,
    Object? value = null,
    Object? unit = null,
    Object? referenceRange = freezed,
    Object? status = freezed,
    Object? category = freezed,
    Object? series = null,
    Object? ext = freezed,
  }) {
    return _then(_$MetricImpl(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as MetricKind,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      referenceRange: freezed == referenceRange
          ? _value.referenceRange
          : referenceRange // ignore: cast_nullable_to_non_nullable
              as ReferenceRange?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MetricStatus?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      series: null == series
          ? _value._series
          : series // ignore: cast_nullable_to_non_nullable
              as List<TrendPoint>,
      ext: freezed == ext
          ? _value._ext
          : ext // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MetricImpl implements _Metric {
  const _$MetricImpl(
      {required this.key,
      required this.label,
      required this.kind,
      required this.value,
      required this.unit,
      this.referenceRange,
      this.status,
      this.category,
      final List<TrendPoint> series = const <TrendPoint>[],
      final Map<String, dynamic>? ext})
      : _series = series,
        _ext = ext;

  factory _$MetricImpl.fromJson(Map<String, dynamic> json) =>
      _$$MetricImplFromJson(json);

  @override
  final String key;
  @override
  final String label;
  @override
  final MetricKind kind;
  @override
  final double value;
  @override
  final String unit;
  @override
  final ReferenceRange? referenceRange;
  @override
  final MetricStatus? status;

  /// 雷达图分组键（如 mobility / balance），多指标同屏聚合用。
  @override
  final String? category;

  /// 该指标的纵向时序点（同病人不同测试批次），用于趋势对比。
  final List<TrendPoint> _series;

  /// 该指标的纵向时序点（同病人不同测试批次），用于趋势对比。
  @override
  @JsonKey()
  List<TrendPoint> get series {
    if (_series is EqualUnmodifiableListView) return _series;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_series);
  }

  /// 未知字段原样保留，避免汇入时丢信息（schema 无关缓冲）。
  final Map<String, dynamic>? _ext;

  /// 未知字段原样保留，避免汇入时丢信息（schema 无关缓冲）。
  @override
  Map<String, dynamic>? get ext {
    final value = _ext;
    if (value == null) return null;
    if (_ext is EqualUnmodifiableMapView) return _ext;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Metric(key: $key, label: $label, kind: $kind, value: $value, unit: $unit, referenceRange: $referenceRange, status: $status, category: $category, series: $series, ext: $ext)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetricImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.referenceRange, referenceRange) ||
                other.referenceRange == referenceRange) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._series, _series) &&
            const DeepCollectionEquality().equals(other._ext, _ext));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      key,
      label,
      kind,
      value,
      unit,
      referenceRange,
      status,
      category,
      const DeepCollectionEquality().hash(_series),
      const DeepCollectionEquality().hash(_ext));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MetricImplCopyWith<_$MetricImpl> get copyWith =>
      __$$MetricImplCopyWithImpl<_$MetricImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MetricImplToJson(
      this,
    );
  }
}

abstract class _Metric implements Metric {
  const factory _Metric(
      {required final String key,
      required final String label,
      required final MetricKind kind,
      required final double value,
      required final String unit,
      final ReferenceRange? referenceRange,
      final MetricStatus? status,
      final String? category,
      final List<TrendPoint> series,
      final Map<String, dynamic>? ext}) = _$MetricImpl;

  factory _Metric.fromJson(Map<String, dynamic> json) = _$MetricImpl.fromJson;

  @override
  String get key;
  @override
  String get label;
  @override
  MetricKind get kind;
  @override
  double get value;
  @override
  String get unit;
  @override
  ReferenceRange? get referenceRange;
  @override
  MetricStatus? get status;
  @override

  /// 雷达图分组键（如 mobility / balance），多指标同屏聚合用。
  String? get category;
  @override

  /// 该指标的纵向时序点（同病人不同测试批次），用于趋势对比。
  List<TrendPoint> get series;
  @override

  /// 未知字段原样保留，避免汇入时丢信息（schema 无关缓冲）。
  Map<String, dynamic>? get ext;
  @override
  @JsonKey(ignore: true)
  _$$MetricImplCopyWith<_$MetricImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
