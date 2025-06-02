import 'dart:math';

import 'package:fantasy_rice/models/overlay.dart';
import 'package:fantasy_rice/providers/notifications.dart';
import 'package:fantasy_rice/providers/toplevel_textures.dart';
import 'package:fantasy_rice/widgets/dock/dock.dart';
import 'package:fantasy_rice/widgets/freeze/freeze.dart';
import 'package:fantasy_rice/widgets/freeze/overlays/lock_overlay/lock_overlay.dart';
import 'package:fantasy_rice/widgets/notifications/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_carousel/flutter_custom_carousel.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayland_shell/wayland_shell.dart';
import 'package:widget_mask/widget_mask.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Dock(
              onLock: () {
                ref
                    .read(overlayStateProvider.notifier)
                    .setOverlay(ScreenOverlay.lock);
              },
              onPowerOff: () {
                ref
                    .read(overlayStateProvider.notifier)
                    .setOverlay(ScreenOverlay.windows);
              },
            ),
            Notifications(),
            Freeze(),
          ],
        ),
      ),
    );
  }
}