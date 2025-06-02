// import 'dart:async';
// import 'dart:core';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'toplevel_textures.g.dart';

// @riverpod
// Stream<KeyEvent> keypresses(Ref ref) {
//   final controller = StreamController<KeyEvent>();

//   bool keyListener(KeyEvent event) {
//     controller.add(event);
//     return false;
//   }

//   HardwareKeyboard.instance.addHandler(keyListener);

//   ref.onDispose(() {
//     HardwareKeyboard.instance.removeHandler(keyListener);
//     controller.close();
//   });

//   return controller.stream;
// }

// @freezed
// abstract class WindowData with _$WindowData {
//   const factory WindowData({
//     required String title,
//     required int textureID,
//     required int width,
//     required int height,
//   }) = _WindowData;
// }

// @freezed
// abstract class LockData with _$LockData {
//   const factory LockData({
//     required String inputPassword,
//   }) = _LockData;
// }

// @freezed
// abstract class OverlayData with _$OverlayData {
//   const factory OverlayData({
//     required ScreenOverlay currentOverlay,
//     required LockData lockData,
//   }) = _OverlayData;
// }

// @riverpod
// class OverlayState extends _$OverlayState {
//   @override
//   OverlayData build() {
//     return const OverlayData(
//       currentOverlay: ScreenOverlay.none,
//       lockData: LockData(inputPassword: ""),
//     );
//   }

//   void setLockPassword(String newPassword) {

//   }

//   void checkLockPassword() {

//   }

//   void setOverlay(ScreenOverlay overlay) {
//     state = state.copyWith(currentOverlay: overlay);
//   }
// }

// // @riverpod
// // class CurrentOverlay extends _$CurrentOverlay {
// //   @override
// //   ScreenOverlay build() {
// //     return ScreenOverlay.none;
// //   }

// //   void setOverlay(ScreenOverlay overlay) {
// //     this.state = overlay;
// //   }
// // }

@riverpod
Stream<List<double>> waveforms(ref) async* {
  const bars = 50;
  // if (!kDebugMode) {
  //   yield List.generate(bars, (index) => Random().nextDouble());
  // } else {
  final config = '''
[general]
bars = $bars
autosens = 1
[output]
method = raw
raw_target = /dev/stdout
bit_format = 16bit
''';
  final tempDir = await Directory.systemTemp.createTemp();

  final cavaConfigFile = File('${tempDir.path}/cava.conf');
  await cavaConfigFile.writeAsString(config);

  const bytesize = 2;
  const bytenorm = 65535;

  final chunkSize = bytesize * bars;

  final cavaProcess = await Process.start('cava', [
    '-p',
    cavaConfigFile.path,
  ]);

  await for (final dataChunk in cavaProcess.stdout) {
    if (dataChunk.length != chunkSize) continue;
    yield Uint8List.fromList(dataChunk)
        .buffer
        .asUint16List(0, bars)
        .map((e) => e / bytenorm)
        .toList();
  }

  throw 'Cava error: ${await cavaProcess.stderr.transform(utf8.decoder).join()}';
  // }
}
