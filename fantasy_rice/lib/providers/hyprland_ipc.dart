import 'dart:async';
import 'dart:core';

import 'package:dbus/dbus.dart';
import 'package:fantasy_rice/dbus/notifications_object.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hyprland_ipc/hyprland_ipc.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hyprland_ipc.g.dart';

@riverpod
Future<HyprlandIPC> hyprlandIPC(Ref ref) async {
  final res = await HyprlandIPC.fromInstance();
  await res.runCommand(GetVersionCommand());
  return res;
}
// final hyprlandEventsProvider = StreamProvider<Event>((ref) {
//   final hyprland = ref.watch(hyprlandProvider);
//   return hyprland.value?.eventsStream ?? const Stream.empty();
// });

@riverpod
Stream<Event> hyprlandIPCEvents(Ref ref) {
  final hyprland = ref.watch(hyprlandIPCProvider);
  return hyprland.value?.eventsStream ?? const Stream.empty();
}

@riverpod
Stream<String> activeWorkspaceName(Ref ref) async* {
  final controller = StreamController<String>();
  final hyprland = ref.watch(hyprlandIPCProvider);

  if (hyprland.value == null) {
    yield* Stream.empty();
  }

  final workspace = await hyprland.value!.runCommand(GetActiveWorkspaceCommand());

  yield workspace.output.name;

  final sub = ref.listen(hyprlandIPCEventsProvider, ((prev, event) {
    if (event.value is WorkspaceEvent) {
      controller.add((event.value as WorkspaceEvent).workspaceName);
    }
  }));

  // Close subscription and controller when provider is disposed
  ref.onDispose(sub.close);
  ref.onDispose(controller.close);

  yield* controller.stream;
}