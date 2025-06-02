import 'dart:math';

import 'package:fantasy_rice/models/overlay.dart';
import 'package:fantasy_rice/providers/toplevel_textures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayland_shell/wayland_shell.dart';

class LockOverlay extends HookConsumerWidget {
  const LockOverlay({
    required this.progress,
    super.key,
  });

  final double progress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _ = ref.watch(keypressesProvider);
    final inputPassword = useValueNotifier("");

    ref.listen(keypressesProvider, (prev, key) {
      print(key.value);
      if (key.value is KeyUpEvent) {
        return;
      }

      if (key.value?.logicalKey != LogicalKeyboardKey.backspace) {
        inputPassword.value += key.valueOrNull?.character ?? "";
      } else if (inputPassword.value.isNotEmpty) {
        inputPassword.value = inputPassword.value.substring(0, inputPassword.value.length - 1);
      }

      if (inputPassword.value == "ilysmuwu") {
        ref.read(overlayStateProvider.notifier).setOverlay(ScreenOverlay.none);
      }
    });

    return Stack(
      children: [
        if (progress != 0.0)
          Positioned(
            left: (1920 / 0.5) * (progress * 1 - 1),
            top: (1080 / 0.5) * (progress - 1) - 550,
            child: Transform.flip(
              flipX: true,
              child: Transform.rotate(
                angle: pi * 2 / 20,
                child: Image.asset(
                  "assets/overlays/lock/chain.png",
                  scale: 1.3,
                ),
              ),
            ),
          ),
        if (progress != 0.0)
          Positioned(
            right: (1920 / 0.5) * (progress * 1 - 1),
            top: (1080 / 0.5) * (progress - 1) - 550,
            child: Transform.rotate(
              angle: pi * 2 / 20,
              child: Image.asset(
                "assets/overlays/lock/chain.png",
                scale: 1.3,
              ),
            ),
          ),
        if (progress != 0.0)
          Align(
            child: Transform.translate(
              offset: Offset(0, (1080) * (progress - 1) - 50),
              child: Image.asset(
                "assets/overlays/lock/lock.png",
                scale: 2.5,
              ),
            ),
          ),
        if (progress != 0.0)
          Align(
            alignment: Alignment(0.5, 0.8),
            child: Opacity(
              opacity: progress,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ValueListenableBuilder(
                  valueListenable: inputPassword,
                  builder: (context, value, child) {
                    return Text(
                      List.filled(min(value.length, 16), "*").join(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        shadows: [
                          BoxShadow(
                            color: Colors.white,
                            blurRadius: 10,
                            spreadRadius: 100,
                            blurStyle: BlurStyle.normal,
                          ),
                        ],
                        color: Colors.white,
                        fontSize: 128,
                        fontWeight: FontWeight.bold,
                        fontFamily: "whiteCupertino",
                      ),
                    );
                  }
                ),
              ),
            ),
          ),
      ],
    );
  }
}
