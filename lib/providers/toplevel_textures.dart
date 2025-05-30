import 'dart:async';
import 'dart:core';

import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'toplevel_textures.g.dart';

Stream<void> timerStream(Duration duration, {bool firstTime = true}) async* {
  if (firstTime) yield 0;
  yield* Stream.periodic(duration);
}

@riverpod
Stream<Map<String, int>> toplevelTextures(Ref ref) async* {
  await for (final _ in timerStream(
    const Duration(seconds: 5),
    firstTime: true,
  )) {
    yield (await const MethodChannel("general").invokeMethod('get_window_textures') as Map<Object?, Object?>).map(
       (key, value) => MapEntry(
         key as String,                                                                                                                                                  
         value as int,                                                                                                                                                   
       ),                                                                                                                                                                
    );                                                                                                                                                                  
  }                                                                                                                                                                     
}
