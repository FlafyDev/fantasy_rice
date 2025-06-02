// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pc_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PCInfoHistoryData implements DiagnosticableTreeMixin {
  List<double> get cpuUsage;
  Map<String, List<double>> get gpusUsage;

  /// Create a copy of PCInfoHistoryData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PCInfoHistoryDataCopyWith<PCInfoHistoryData> get copyWith =>
      _$PCInfoHistoryDataCopyWithImpl<PCInfoHistoryData>(
          this as PCInfoHistoryData, _$identity);

  /// Serializes this PCInfoHistoryData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'PCInfoHistoryData'))
      ..add(DiagnosticsProperty('cpuUsage', cpuUsage))
      ..add(DiagnosticsProperty('gpusUsage', gpusUsage));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PCInfoHistoryData &&
            const DeepCollectionEquality().equals(other.cpuUsage, cpuUsage) &&
            const DeepCollectionEquality().equals(other.gpusUsage, gpusUsage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(cpuUsage),
      const DeepCollectionEquality().hash(gpusUsage));

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PCInfoHistoryData(cpuUsage: $cpuUsage, gpusUsage: $gpusUsage)';
  }
}

/// @nodoc
abstract mixin class $PCInfoHistoryDataCopyWith<$Res> {
  factory $PCInfoHistoryDataCopyWith(
          PCInfoHistoryData value, $Res Function(PCInfoHistoryData) _then) =
      _$PCInfoHistoryDataCopyWithImpl;
  @useResult
  $Res call({List<double> cpuUsage, Map<String, List<double>> gpusUsage});
}

/// @nodoc
class _$PCInfoHistoryDataCopyWithImpl<$Res>
    implements $PCInfoHistoryDataCopyWith<$Res> {
  _$PCInfoHistoryDataCopyWithImpl(this._self, this._then);

  final PCInfoHistoryData _self;
  final $Res Function(PCInfoHistoryData) _then;

  /// Create a copy of PCInfoHistoryData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cpuUsage = null,
    Object? gpusUsage = null,
  }) {
    return _then(_self.copyWith(
      cpuUsage: null == cpuUsage
          ? _self.cpuUsage
          : cpuUsage // ignore: cast_nullable_to_non_nullable
              as List<double>,
      gpusUsage: null == gpusUsage
          ? _self.gpusUsage
          : gpusUsage // ignore: cast_nullable_to_non_nullable
              as Map<String, List<double>>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _PCInfoHistoryData
    with DiagnosticableTreeMixin
    implements PCInfoHistoryData {
  const _PCInfoHistoryData(
      {required final List<double> cpuUsage,
      required final Map<String, List<double>> gpusUsage})
      : _cpuUsage = cpuUsage,
        _gpusUsage = gpusUsage;
  factory _PCInfoHistoryData.fromJson(Map<String, dynamic> json) =>
      _$PCInfoHistoryDataFromJson(json);

  final List<double> _cpuUsage;
  @override
  List<double> get cpuUsage {
    if (_cpuUsage is EqualUnmodifiableListView) return _cpuUsage;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cpuUsage);
  }

  final Map<String, List<double>> _gpusUsage;
  @override
  Map<String, List<double>> get gpusUsage {
    if (_gpusUsage is EqualUnmodifiableMapView) return _gpusUsage;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_gpusUsage);
  }

  /// Create a copy of PCInfoHistoryData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PCInfoHistoryDataCopyWith<_PCInfoHistoryData> get copyWith =>
      __$PCInfoHistoryDataCopyWithImpl<_PCInfoHistoryData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PCInfoHistoryDataToJson(
      this,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'PCInfoHistoryData'))
      ..add(DiagnosticsProperty('cpuUsage', cpuUsage))
      ..add(DiagnosticsProperty('gpusUsage', gpusUsage));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PCInfoHistoryData &&
            const DeepCollectionEquality().equals(other._cpuUsage, _cpuUsage) &&
            const DeepCollectionEquality()
                .equals(other._gpusUsage, _gpusUsage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_cpuUsage),
      const DeepCollectionEquality().hash(_gpusUsage));

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PCInfoHistoryData(cpuUsage: $cpuUsage, gpusUsage: $gpusUsage)';
  }
}

/// @nodoc
abstract mixin class _$PCInfoHistoryDataCopyWith<$Res>
    implements $PCInfoHistoryDataCopyWith<$Res> {
  factory _$PCInfoHistoryDataCopyWith(
          _PCInfoHistoryData value, $Res Function(_PCInfoHistoryData) _then) =
      __$PCInfoHistoryDataCopyWithImpl;
  @override
  @useResult
  $Res call({List<double> cpuUsage, Map<String, List<double>> gpusUsage});
}

/// @nodoc
class __$PCInfoHistoryDataCopyWithImpl<$Res>
    implements _$PCInfoHistoryDataCopyWith<$Res> {
  __$PCInfoHistoryDataCopyWithImpl(this._self, this._then);

  final _PCInfoHistoryData _self;
  final $Res Function(_PCInfoHistoryData) _then;

  /// Create a copy of PCInfoHistoryData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? cpuUsage = null,
    Object? gpusUsage = null,
  }) {
    return _then(_PCInfoHistoryData(
      cpuUsage: null == cpuUsage
          ? _self._cpuUsage
          : cpuUsage // ignore: cast_nullable_to_non_nullable
              as List<double>,
      gpusUsage: null == gpusUsage
          ? _self._gpusUsage
          : gpusUsage // ignore: cast_nullable_to_non_nullable
              as Map<String, List<double>>,
    ));
  }
}

// dart format on
