import 'dart:math';

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
                  "assets/rice_chain_long.png",
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
                "assets/rice_chain_long.png",
                scale: 1.3,
              ),
            ),
          ),
        if (progress != 0.0)
          Align(
            child: Transform.translate(
              offset: Offset(0, (1080) * (progress - 1) - 50),
              child: Image.asset(
                "assets/rice_lock.png",
                scale: 2.5,
              ),
            ),
          )
      ],
    );
  }
}
