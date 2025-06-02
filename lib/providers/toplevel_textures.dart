import 'dart:async';
import 'dart:core';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fantasy_rice/models/overlay.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'toplevel_textures.g.dart';
part 'toplevel_textures.freezed.dart';

// Stream<void> timerStream(Duration duration, {bool firstTime = true}) async* {
//   if (firstTime) yield 0;
//   yield* Stream.periodic(duration);
// }

// @riverpod
// Stream<Map<String, int>> toplevelTextures(Ref ref) async* {
//   await for (final _ in timerStream(
//     const Duration(seconds: 5),
//     firstTime: true,
//   )) {
//     yield (await const MethodChannel("general")
//             .invokeMethod('get_window_textures') as Map<Object?, Object?>)
//         .map(
//       (key, value) => MapEntry(
//         key as String,
//         value as int,
//       ),
//     );
//   }
// }

@freezed
abstract class WindowData with _$WindowData {
  const factory WindowData({
    required String title,
    required int textureID,
    required int width,
    required int height,
  }) = _WindowData;
}

@freezed
abstract class LockData with _$LockData {
  const factory LockData({
    required String inputPassword,
  }) = _LockData;
}

@freezed
abstract class OverlayData with _$OverlayData {
  const factory OverlayData({
    required ScreenOverlay currentOverlay,
    required LockData lockData,
  }) = _OverlayData;
}

@riverpod
class OverlayState extends _$OverlayState {
  @override
  OverlayData build() {
    return const OverlayData(
      currentOverlay: ScreenOverlay.none,
      lockData: LockData(inputPassword: ""),
    );
  }

  void setLockPassword(String newPassword) {

  }

  void checkLockPassword() {

  }

  void setOverlay(ScreenOverlay overlay) {
    state = state.copyWith(currentOverlay: overlay);
  }
}



// @riverpod
// class CurrentOverlay extends _$CurrentOverlay {
//   @override
//   ScreenOverlay build() {
//     return ScreenOverlay.none;
//   }

//   void setOverlay(ScreenOverlay overlay) {
//     this.state = overlay;
//   }
// }
