import 'dart:math';

import 'package:fantasy_rice/widgets/fire.dart';
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
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Image(
                image: AssetImage(
                  "assets/backgrounds/rooberto-nieto-duskintheforst.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: 765,
              top: 490,
              child: Center(child: Fire()),
            ),
          ],
        ),
      ),
    );
  }
}
