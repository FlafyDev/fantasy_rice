import 'dart:math';

import 'package:fantasy_rice/models/overlay.dart';
import 'package:fantasy_rice/providers/toplevel_textures.dart';
import 'package:fantasy_rice/utils/use_delta_ticker.dart';
import 'package:fantasy_rice/utils/use_listener_effect.dart';
import 'package:fantasy_rice/widgets/dock/dock.dart';
import 'package:fantasy_rice/widgets/freeze/overlays/lock_overlay/lock_overlay.dart';
import 'package:fantasy_rice/widgets/freeze/overlays/windows_overlay/windows_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayland_shell/wayland_shell.dart';
import 'package:widget_mask/widget_mask.dart';

class Freeze extends HookConsumerWidget {
  const Freeze({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenTextureID = useState<int?>(null);
    final commonAC = useAnimationController(initialValue: 0.0);
    final currentOverlay =
        ref.watch(overlayStateProvider.select((d) => d.currentOverlay));
    final latestOverlay = useValueNotifier<ScreenOverlay>(ScreenOverlay.none);
    final stripsProgress = useValueNotifier(0.0);

    useDeltaTicker((delta) => stripsProgress.value += delta / 4);

    useValueChanged(currentOverlay, (previous, oldResult) async {
      if (currentOverlay == ScreenOverlay.none) {
        await WaylandShell.setKeyboardInput(false);
        print("no special keyboard");

        commonAC.animateTo(0.0,
            curve: Curves.easeOutExpo, duration: Duration(milliseconds: 500));

        return;
      }

      latestOverlay.value = currentOverlay;

      screenTextureID.value = (await const MethodChannel("general")
          .invokeMethod('get_single_screen') as int);

      commonAC.animateTo(1.0,
          curve: Curves.easeOutExpo, duration: Duration(milliseconds: 500));

      await WaylandShell.setKeyboardInput(true);

      // ref.read(overlayStateProvider.notifier).setOverlay(ScreenOverlay.none);
    });

    return AnimatedBuilder(
      animation: commonAC,
      child: null,
      builder: (context, child) {
        return IgnorePointer(
          ignoring: commonAC.value == 0.0,
          child: InputRegion(
            enabled: commonAC.value != 0.0,
            child: Container(
              color: Colors.black
                  .withValues(alpha: commonAC.value == 0.0 ? 0.0 : 1.0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  if (commonAC.value != 0.0)
                    Positioned.fill(
                      child: Image(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          "assets/overlays/backgrounds/purple_oil_background.jpg",
                        ),
                      ),
                    ),
                  if (commonAC.value != 0.0)
                    Transform.scale(
                      scale: 0.8 + 0.2 * (1 - commonAC.value),
                      child: Container(
                        foregroundDecoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(100 * commonAC.value),
                          color: const Color.fromARGB(255, 0, 0, 0)
                              .withValues(alpha: 0.5 * commonAC.value),
                        ),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(100 * commonAC.value),
                          border: Border.all(
                            width: 5.0 * commonAC.value,
                            color: Colors.orangeAccent,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(100 * commonAC.value),
                          child: ValueListenableBuilder(
                            valueListenable: stripsProgress,
                            builder: (context, value, child) {
                              return CustomPaint(
                                foregroundPainter: StripsPaint(
                                  color: Color.fromARGB((150 * commonAC.value).round(), 41, 41, 41),
                                  progress: value,
                                ),
                                child: child!,
                              );
                            },
                            child: Texture(
                              textureId: screenTextureID.value!,
                            ),
                          ),
                        ),
                      ),
                    ),
                  Positioned.fill(
                    child: ListenableBuilder(
                      listenable: latestOverlay,
                      builder: (context, child) {
                        if (latestOverlay.value == ScreenOverlay.lock) {
                          return LockOverlay(progress: commonAC.value);
                        }
                        if (latestOverlay.value == ScreenOverlay.windows) {
                          return WindowsOverlay(progress: commonAC.value);
                        }
                        return SizedBox();
                      },
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

class StripsPaint extends CustomPainter {
  const StripsPaint({
    required this.progress,
    required this.color,
  });

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30;

    for (int i = -20; i < 20; i++) {
      final topX = rect.right * ((i + (progress % 1.0)) / 20.0);
      final bottomX = topX + tan(pi / 4) * rect.bottom;
      final path = Path()
        ..moveTo(topX, rect.top)
        ..lineTo(bottomX, rect.bottom);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(StripsPaint oldDelegate) => true;
  @override
  bool shouldRebuildSemantics(StripsPaint oldDelegate) => false;
}
