import 'package:fantasy_rice/providers/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:math';

import 'package:wayland_shell/wayland_shell.dart';

class Notifications extends HookConsumerWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsStateProvider);

    return Align(
      alignment: Alignment.topCenter,
      child: Stack(
        children: notifications.asMap().entries.map(
          (entry) {
            final n = entry.value;
            final i = entry.key;
            return _NotificationTile(
              index: (notifications.length - i - 1).toDouble(),
              key: ValueKey(n),
              onPressed: () {
                ref
                    .read(notificationsStateProvider.notifier)
                    .closeNotification(n.id);
              },
              n: n,
            );
          },
        ).toList(),
      ),
    );
  }
}

class _NotificationTile extends HookConsumerWidget {
  const _NotificationTile({
    super.key,
    required this.index,
    required this.n,
    required this.onPressed,
  });

  final double index;
  final NotificationData n;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animatedIndex = useAnimationController(
      duration: Duration(seconds: 1),
      upperBound: 100,
      lowerBound: -1,
      initialValue: -1,
    );
    final createdAC = useAnimationController(
        duration: Duration(seconds: 1), upperBound: 100, initialValue: 0);

    useEffect(() {
      createdAC.animateTo(1,
          duration: Duration(milliseconds: 500), curve: Curves.linear);
      return;
    }, [createdAC]);

    useEffect(() {
      if (index != 0 || createdAC.isCompleted) {
        animatedIndex.animateTo(index,
            duration: Duration(seconds: 1), curve: Curves.easeOutExpo);
      } else {
        animatedIndex.value = index;
      }
      return;
    }, [animatedIndex, index]);

    const width = 395.0;
    const height = 130.0;

    return AnimatedBuilder(
      animation: Listenable.merge([createdAC, animatedIndex]),
      builder: (context, child) {
        final scrollFrameNumber =
            (createdAC.value * 13).round().toString().padLeft(4, '0');
        return Positioned(
          left: MediaQuery.of(context).size.width - width,
          top: height * animatedIndex.value,
          child: InputRegion(
            child: GestureDetector(
              onTap: onPressed,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Image.asset(
                      "assets/scroll/frame$scrollFrameNumber.png",
                      fit: BoxFit.none,
                      scale: 1.5,
                    ),
                  ),
                  Positioned(
                    left: 110,
                    top: 120,
                    child: Opacity(
                      opacity: Curves.easeOutExpo.flipped.transform(createdAC.value),
                      child: SizedBox(
                        width: 150,
                        height: 100,
                        child: Center(
                          child: Text(
                            n.title,
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "PistonBlack",
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 250,
                    top: 100,
                    child: Opacity(
                      opacity: Curves.easeOutExpo.transform(createdAC.value),
                      child: SizedBox(
                        width: 140,
                        height: 110,
                        child: Center(
                          child: Text(
                            n.description,
                            softWrap: true,
                            textAlign: TextAlign.center,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: "whiteCupertino",
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
