// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'toplevel_textures.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WindowData {
  String get title;
  int get textureID;
  int get width;
  int get height;

  /// Create a copy of WindowData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WindowDataCopyWith<WindowData> get copyWith =>
      _$WindowDataCopyWithImpl<WindowData>(this as WindowData, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WindowData &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.textureID, textureID) ||
                other.textureID == textureID) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, textureID, width, height);

  @override
  String toString() {
    return 'WindowData(title: $title, textureID: $textureID, width: $width, height: $height)';
  }
}

/// @nodoc
abstract mixin class $WindowDataCopyWith<$Res> {
  factory $WindowDataCopyWith(
          WindowData value, $Res Function(WindowData) _then) =
      _$WindowDataCopyWithImpl;
  @useResult
  $Res call({String title, int textureID, int width, int height});
}

/// @nodoc
class _$WindowDataCopyWithImpl<$Res> implements $WindowDataCopyWith<$Res> {
  _$WindowDataCopyWithImpl(this._self, this._then);

  final WindowData _self;
  final $Res Function(WindowData) _then;

  /// Create a copy of WindowData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? textureID = null,
    Object? width = null,
    Object? height = null,
  }) {
    return _then(_self.copyWith(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      textureID: null == textureID
          ? _self.textureID
          : textureID // ignore: cast_nullable_to_non_nullable
              as int,
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _WindowData implements WindowData {
  const _WindowData(
      {required this.title,
      required this.textureID,
      required this.width,
      required this.height});

  @override
  final String title;
  @override
  final int textureID;
  @override
  final int width;
  @override
  final int height;

  /// Create a copy of WindowData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WindowDataCopyWith<_WindowData> get copyWith =>
      __$WindowDataCopyWithImpl<_WindowData>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WindowData &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.textureID, textureID) ||
                other.textureID == textureID) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, textureID, width, height);

  @override
  String toString() {
    return 'WindowData(title: $title, textureID: $textureID, width: $width, height: $height)';
  }
}

/// @nodoc
abstract mixin class _$WindowDataCopyWith<$Res>
    implements $WindowDataCopyWith<$Res> {
  factory _$WindowDataCopyWith(
          _WindowData value, $Res Function(_WindowData) _then) =
      __$WindowDataCopyWithImpl;
  @override
  @useResult
  $Res call({String title, int textureID, int width, int height});
}

/// @nodoc
class __$WindowDataCopyWithImpl<$Res> implements _$WindowDataCopyWith<$Res> {
  __$WindowDataCopyWithImpl(this._self, this._then);

  final _WindowData _self;
  final $Res Function(_WindowData) _then;

  /// Create a copy of WindowData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? title = null,
    Object? textureID = null,
    Object? width = null,
    Object? height = null,
  }) {
    return _then(_WindowData(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      textureID: null == textureID
          ? _self.textureID
          : textureID // ignore: cast_nullable_to_non_nullable
              as int,
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$LockData {
  String get inputPassword;

  /// Create a copy of LockData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LockDataCopyWith<LockData> get copyWith =>
      _$LockDataCopyWithImpl<LockData>(this as LockData, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LockData &&
            (identical(other.inputPassword, inputPassword) ||
                other.inputPassword == inputPassword));
  }

  @override
  int get hashCode => Object.hash(runtimeType, inputPassword);

  @override
  String toString() {
    return 'LockData(inputPassword: $inputPassword)';
  }
}

/// @nodoc
abstract mixin class $LockDataCopyWith<$Res> {
  factory $LockDataCopyWith(LockData value, $Res Function(LockData) _then) =
      _$LockDataCopyWithImpl;
  @useResult
  $Res call({String inputPassword});
}

/// @nodoc
class _$LockDataCopyWithImpl<$Res> implements $LockDataCopyWith<$Res> {
  _$LockDataCopyWithImpl(this._self, this._then);

  final LockData _self;
  final $Res Function(LockData) _then;

  /// Create a copy of LockData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inputPassword = null,
  }) {
    return _then(_self.copyWith(
      inputPassword: null == inputPassword
          ? _self.inputPassword
          : inputPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _LockData implements LockData {
  const _LockData({required this.inputPassword});

  @override
  final String inputPassword;

  /// Create a copy of LockData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LockDataCopyWith<_LockData> get copyWith =>
      __$LockDataCopyWithImpl<_LockData>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LockData &&
            (identical(other.inputPassword, inputPassword) ||
                other.inputPassword == inputPassword));
  }

  @override
  int get hashCode => Object.hash(runtimeType, inputPassword);

  @override
  String toString() {
    return 'LockData(inputPassword: $inputPassword)';
  }
}

/// @nodoc
abstract mixin class _$LockDataCopyWith<$Res>
    implements $LockDataCopyWith<$Res> {
  factory _$LockDataCopyWith(_LockData value, $Res Function(_LockData) _then) =
      __$LockDataCopyWithImpl;
  @override
  @useResult
  $Res call({String inputPassword});
}

/// @nodoc
class __$LockDataCopyWithImpl<$Res> implements _$LockDataCopyWith<$Res> {
  __$LockDataCopyWithImpl(this._self, this._then);

  final _LockData _self;
  final $Res Function(_LockData) _then;

  /// Create a copy of LockData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? inputPassword = null,
  }) {
    return _then(_LockData(
      inputPassword: null == inputPassword
          ? _self.inputPassword
          : inputPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$OverlayData {
  ScreenOverlay get currentOverlay;
  LockData get lockData;

  /// Create a copy of OverlayData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OverlayDataCopyWith<OverlayData> get copyWith =>
      _$OverlayDataCopyWithImpl<OverlayData>(this as OverlayData, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OverlayData &&
            (identical(other.currentOverlay, currentOverlay) ||
                other.currentOverlay == currentOverlay) &&
            (identical(other.lockData, lockData) ||
                other.lockData == lockData));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentOverlay, lockData);

  @override
  String toString() {
    return 'OverlayData(currentOverlay: $currentOverlay, lockData: $lockData)';
  }
}

/// @nodoc
abstract mixin class $OverlayDataCopyWith<$Res> {
  factory $OverlayDataCopyWith(
          OverlayData value, $Res Function(OverlayData) _then) =
      _$OverlayDataCopyWithImpl;
  @useResult
  $Res call({ScreenOverlay currentOverlay, LockData lockData});

  $LockDataCopyWith<$Res> get lockData;
}

/// @nodoc
class _$OverlayDataCopyWithImpl<$Res> implements $OverlayDataCopyWith<$Res> {
  _$OverlayDataCopyWithImpl(this._self, this._then);

  final OverlayData _self;
  final $Res Function(OverlayData) _then;

  /// Create a copy of OverlayData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentOverlay = null,
    Object? lockData = null,
  }) {
    return _then(_self.copyWith(
      currentOverlay: null == currentOverlay
          ? _self.currentOverlay
          : currentOverlay // ignore: cast_nullable_to_non_nullable
              as ScreenOverlay,
      lockData: null == lockData
          ? _self.lockData
          : lockData // ignore: cast_nullable_to_non_nullable
              as LockData,
    ));
  }

  /// Create a copy of OverlayData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LockDataCopyWith<$Res> get lockData {
    return $LockDataCopyWith<$Res>(_self.lockData, (value) {
      return _then(_self.copyWith(lockData: value));
    });
  }
}

/// @nodoc

class _OverlayData implements OverlayData {
  const _OverlayData({required this.currentOverlay, required this.lockData});

  @override
  final ScreenOverlay currentOverlay;
  @override
  final LockData lockData;

  /// Create a copy of OverlayData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OverlayDataCopyWith<_OverlayData> get copyWith =>
      __$OverlayDataCopyWithImpl<_OverlayData>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OverlayData &&
            (identical(other.currentOverlay, currentOverlay) ||
                other.currentOverlay == currentOverlay) &&
            (identical(other.lockData, lockData) ||
                other.lockData == lockData));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentOverlay, lockData);

  @override
  String toString() {
    return 'OverlayData(currentOverlay: $currentOverlay, lockData: $lockData)';
  }
}

/// @nodoc
abstract mixin class _$OverlayDataCopyWith<$Res>
    implements $OverlayDataCopyWith<$Res> {
  factory _$OverlayDataCopyWith(
          _OverlayData value, $Res Function(_OverlayData) _then) =
      __$OverlayDataCopyWithImpl;
  @override
  @useResult
  $Res call({ScreenOverlay currentOverlay, LockData lockData});

  @override
  $LockDataCopyWith<$Res> get lockData;
}

/// @nodoc
class __$OverlayDataCopyWithImpl<$Res> implements _$OverlayDataCopyWith<$Res> {
  __$OverlayDataCopyWithImpl(this._self, this._then);

  final _OverlayData _self;
  final $Res Function(_OverlayData) _then;

  /// Create a copy of OverlayData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? currentOverlay = null,
    Object? lockData = null,
  }) {
    return _then(_OverlayData(
      currentOverlay: null == currentOverlay
          ? _self.currentOverlay
          : currentOverlay // ignore: cast_nullable_to_non_nullable
              as ScreenOverlay,
      lockData: null == lockData
          ? _self.lockData
          : lockData // ignore: cast_nullable_to_non_nullable
              as LockData,
    ));
  }

  /// Create a copy of OverlayData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LockDataCopyWith<$Res> get lockData {
    return $LockDataCopyWith<$Res>(_self.lockData, (value) {
      return _then(_self.copyWith(lockData: value));
    });
  }
}

// dart format on
