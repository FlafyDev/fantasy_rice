import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayland_shell/wayland_shell.dart';

const grayscaleMatrix = <double>[
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0,
  0,
  0,
  1,
  0,
];

const identityMatrix = <double>[
  1,
  0,
  0,
  0,
  0,
  0,
  1,
  0,
  0,
  0,
  0,
  0,
  1,
  0,
  0,
  0,
  0,
  0,
  1,
  0,
];

class Dock extends HookConsumerWidget {
  const Dock({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Stack(
          //   children: [
          //     Image.asset("assets/rice_top_bg.png", scale: 2),
          //     Image.asset("assets/rice_top.png", scale: 2),
          //   ],
          // ),
          InputRegion(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DockUtilityButton(
                  assetImageName: "assets/rice_btn_slot_poweroff.png",
                ),
                DockUtilityButton(
                  assetImageName: "assets/rice_btn_slot_lock.png",
                ),
                DockUtilityButton(
                  assetImageName: "assets/rice_btn_slot_lock.png",
                ),
                SizedBox(width: 10),
                ...List.generate(
                  6,
                  (i) => DockWorkspaceButton(
                    key: ValueKey(i + 3),
                  ),
                ),
                SizedBox(width: 10),
                DockUtilityButton(
                  assetImageName: "assets/rice_btn_slot_lock.png",
                ),
                DockUtilityButton(
                  assetImageName: "assets/rice_btn_slot_lock.png",
                ),
                DockUtilityButton(
                  assetImageName: "assets/rice_btn_slot_lock.png",
                ),
              ],
            ),
          ),
          SizedBox(
            height: 2,
          ),
        ],
      ),
    );
  }
}

class DockWorkspaceButton extends StatelessWidget {
  const DockWorkspaceButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(8),
          ),
          child: Material(
            color: const Color.fromARGB(255, 36, 30, 25),
            child: InkWell(
              onTap: () {
                print("hi");
              },
              hoverColor: const Color.fromARGB(40, 167, 138, 115),
              splashColor: const Color.fromARGB(105, 180, 114, 196),
              child: Ink(
                width: 127 / 2.0 - 7,
                height: 109 / 2.0 - 3,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    colorFilter: const ColorFilter.matrix(identityMatrix),
                    image: AssetImage("assets/rock-1.png"),
                    scale: 13,
                  ),
                ),
              ),
            ),
          ),
        ),
        IgnorePointer(
          child: Image.asset(
            "assets/rice_slot.png",
            scale: 2,
          ),
        ),
      ],
    );
  }
}

class DockUtilityButton extends StatelessWidget {
  const DockUtilityButton({
    required this.assetImageName,
    super.key,
  });

  final String assetImageName;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Material(
            color: const Color.fromARGB(255, 36, 30, 25),
            child: InkWell(
              onTap: () {
                print("hi");
              },
              hoverColor: const Color.fromARGB(40, 167, 138, 115),
              splashColor: const Color.fromARGB(105, 196, 162, 114),
              child: Ink(
                width: 103 / 2.0 - 7,
                height: 99 / 2.0 - 5,
              ),
            ),
          ),
        ),
        IgnorePointer(
          child: Image.asset(
            "assets/rice_btn_slot.png",
            scale: 2,
          ),
        ),
        IgnorePointer(
          child: Image.asset(
            assetImageName,
            scale: 2,
          ),
        ),
      ],
    );
  }
}
