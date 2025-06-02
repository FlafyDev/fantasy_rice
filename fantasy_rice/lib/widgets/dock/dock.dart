import 'dart:math';

import 'package:fantasy_rice/providers/hyprland_ipc.dart';
import 'package:fantasy_rice/widgets/dock/dock_top.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hyprland_ipc/hyprland_ipc.dart';
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
    required this.onLock,
    required this.onPowerOff,
    super.key,
  });

  final void Function() onLock;
  final void Function() onPowerOff;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hyprlandIPC = ref.watch(hyprlandIPCProvider);
    final activeWorkspaceName = ref.watch(activeWorkspaceNameProvider);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          DockTop(),
          InputRegion(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DockUtilityButton(
                  onPressed: onPowerOff,
                  assetImageName: "assets/dock/icons/windows.png",
                ),
                DockUtilityButton(
                  onPressed: onLock,
                  assetImageName: "assets/dock/icons/lock.png",
                ),
                DockUtilityButton(
                  onPressed: () {},
                  assetImageName: "assets/dock/icons/poweroff.png",
                ),
                SizedBox(width: 10),
                ...List.generate(
                  6,
                  (i) => DockWorkspaceButton(
                    index: i,
                    key: ValueKey(i + 3),
                    disabled: i + 1 != (int.tryParse(activeWorkspaceName.valueOrNull ?? "-1") ?? -1),
                    onPressed: () async {
                      await hyprlandIPC.value?.runCommand(
                        ChangeToWorkspaceCommand(
                          workspace: WorkspaceRefID((i + 1).toString()),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 10),
                DockUtilityButton(
                  onPressed: () {},
                  assetImageName: "assets/dock/icons/question.png",
                ),
                DockUtilityButton(
                  onPressed: () {},
                  assetImageName: "assets/dock/icons/question.png",
                ),
                DockUtilityButton(
                  onPressed: () {},
                  assetImageName: "assets/dock/icons/question.png",
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
    required this.onPressed,
    required this.index,
    required this.disabled,
    super.key,
  });

  final bool disabled;

  final void Function() onPressed;
  final int index;
  static const gems = [
    "assets/dock/gems/purple.png",
    "assets/dock/gems/green.png",
    "assets/dock/gems/pink.png",
    "assets/dock/gems/blue.png",
    "assets/dock/gems/red.png",
    "assets/dock/gems/yellow.png",
  ];
  static const colors = [
    Color.fromARGB(105, 180, 114, 196), // purple
    Color.fromARGB(105, 114, 196, 123), // green
    Color.fromARGB(105, 196, 114, 180), // pink
    Color.fromARGB(105, 114, 152, 196), // blue
    Color.fromARGB(105, 196, 80, 80), // red
    Color.fromARGB(105, 220, 196, 114), // yellow
  ];

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
              onTap: onPressed,
              hoverColor: const Color.fromARGB(40, 167, 138, 115),
              splashColor: colors[index],
              child: Ink(
                width: 127 / 2.0 - 7,
                height: 109 / 2.0 - 3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    colorFilter: ColorFilter.matrix(disabled ? grayscaleMatrix : identityMatrix),
                    image: AssetImage(gems[index]),
                    scale: 13,
                  ),
                ),
              ),
            ),
          ),
        ),
        IgnorePointer(
          child: Image.asset(
            "assets/dock/borders/main_button.png",
            scale: 2,
          ),
        ),
      ],
    );
  }
}

class DockUtilityButton extends StatelessWidget {
  const DockUtilityButton({
    required this.onPressed,
    required this.assetImageName,
    super.key,
  });

  final void Function() onPressed;
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
              onTap: onPressed,
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
            "assets/dock/borders/side_button.png",
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
