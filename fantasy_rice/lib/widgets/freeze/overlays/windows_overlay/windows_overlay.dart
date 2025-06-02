import 'dart:math';

import 'package:fantasy_rice/models/overlay.dart';
import 'package:fantasy_rice/providers/hyprland_ipc.dart';
import 'package:fantasy_rice/providers/toplevel_textures.dart';
import 'package:fantasy_rice/utils/use_delta_ticker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hyprland_ipc/hyprland_ipc.dart';
import 'package:wayland_shell/wayland_shell.dart';

class WindowsOverlay extends HookConsumerWidget {
  const WindowsOverlay({
    required this.progress,
    super.key,
  });

  final double progress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tickerProvider = useSingleTickerProvider();
    final rotation = useState(0.0);
    final _ = ref.watch(keypressesProvider);

    ref.listen(keypressesProvider, (prev, key) {
      if (key.value is! KeyDownEvent) {
        return;
      }

      if (key.value?.logicalKey == LogicalKeyboardKey.escape) {
        ref.read(overlayStateProvider.notifier).setOverlay(ScreenOverlay.none);
      }
    });

    useEffect(() {
      var lastElapsed = Duration.zero;
      final ticker = tickerProvider.createTicker((elapsed) {
        final delta = (elapsed - lastElapsed).inMicroseconds / 1000000.0;
        lastElapsed = elapsed;
        rotation.value += 2 * pi / 100 * delta;
      });

      ticker.start();

      return ticker.dispose;
    }, [tickerProvider, rotation]);

    final windows = useState<List<WindowData>?>(null);

    useEffect(() {
      (() async {
        if (progress == 0.0) {
          windows.value = null;
          return;
        }

        windows.value = ((await (const MethodChannel("general"))
                .invokeMethod('get_window_textures') as Map<Object?, Object?>)
            .entries
            .map(
          (e) {
            final dataString = e.key as String;
            final dataParts = dataString.split("___");
            final title = dataParts[0]; // That's actually the class lol
            final width = int.parse(dataParts[1]);
            final height = int.parse(dataParts[2]);
            final textureID = e.value as int;

            return WindowData(
              title: title,
              textureID: textureID,
              width: width,
              height: height,
            );
          },
        )).toList();
      })();

      return;
    }, [progress != 0.0]);

    return Opacity(
      opacity: progress,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(250.0),
                    child: Transform.rotate(
                      angle: rotation.value,
                      child: ValueListenableBuilder(
                          valueListenable: windows,
                          builder: (context, value, child) {
                            return CustomPaint(
                              painter: SummoningCirclePaint(
                                circles: value?.length ?? 5,
                              ),
                            );
                          }),
                    ),
                  ),
                ),
              ),
            ),
            ...(windows.value?.indexed.map(
                  (e) {
                    final total = windows.value!.length;
                    final progression = e.$1 / total;
                    final piProg = progression * 2 * pi - rotation.value;
                    final screenAspectRatio =
                        MediaQuery.of(context).size.aspectRatio;

                    final x =
                        (sin(piProg) / 1.2) / screenAspectRatio;
                    final y = (cos(piProg) / 1.2);

                    final maxAspectRatio = 1.5;
                    final adjustedAspectRatio = (e.$2.width / e.$2.height)
                        .clamp(1.0 / maxAspectRatio, maxAspectRatio);

                    var height = max(50.0, 330.0 / (total / 4));

                    return Align(
                      key: ValueKey(e.$2.textureID),
                      alignment: Alignment(x, y),
                      child: TestWidget(
                        height: height + 50,
                        width: adjustedAspectRatio * (height + 50),
                        child: (m) => Container(
                          transformAlignment: Alignment.center,
                          transform: m,
                          height: height,
                          width: adjustedAspectRatio * height,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withAlpha(100),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                            border: Border.all(
                              color: Colors.amber,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: AspectRatio(
                              aspectRatio: e.$2.width / e.$2.height,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      width: 127 / 2.0 - 7,
                                      height: 109 / 2.0 - 3,
                                      child: Texture(
                                        textureId: e.$2.textureID,
                                        filterQuality: FilterQuality.high,
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () async {
                                          final hyprlandIPC = ref.read(hyprlandIPCProvider);
                                          if (hyprlandIPC.value == null) return;

                                          final clients = (await hyprlandIPC.value!.runCommand(GetClientsCommand())).output;
                                          
                                          final foundClient = clients.firstWhereOrNull((c) => c.className == e.$2.title);

                                          if (foundClient == null) return;
                                          print(foundClient);
                                          
                                          ref.read(overlayStateProvider.notifier).setOverlay(ScreenOverlay.none);

                                          await Future.delayed(Duration(seconds: 1));

                                          hyprlandIPC.value!.runCommand(FocusWindowCommand(window: foundClient.address));
                                        },
                                        hoverColor: const Color.fromARGB(
                                            40, 167, 138, 115),
                                        splashColor: const Color.fromARGB(105, 196, 185, 114),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ) ??
                []),
          ],
        ),
      ),
    );
  }
}

class TestWidget extends HookConsumerWidget {
  const TestWidget({
    required this.child,
    required this.width,
    required this.height,
    super.key,
  });

  final Widget Function(Matrix4) child;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mouseCoords = useValueNotifier(Offset.zero);
    final smoothCoords = useValueNotifier(Offset.zero);
    final velocity = useValueNotifier(Offset.zero);
    final tickerProvider = useSingleTickerProvider();
    final mouseInside = useRef(false);

    useEffect(() {
      final ticker = tickerProvider.createTicker((elapsed) {
        final target = mouseCoords.value;
        final current = smoothCoords.value;
        final diff = target - current;

        if (diff.distanceSquared < 0.001) {
          velocity.value = Offset.zero;
          return;
        }

        // Calculate acceleration based on distance to target
        final accelerationMultiplier = mouseInside.value ? 0.02 : 0.002;
        final acceleration = diff * accelerationMultiplier;

        // Apply friction to velocity
        final friction = 0.95;
        velocity.value = velocity.value * friction + acceleration;
        smoothCoords.value = current + velocity.value;
      });

      ticker.start();
      return ticker.dispose;
    }, [tickerProvider, mouseInside]);

    return Container(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ValueListenableBuilder(
            valueListenable: smoothCoords,
            builder: (context, value, _child) {
              // Create perspective distortion based on mouse position
              final rotationX =
                  value.dy * 0.3; // Rotate around X-axis (tilt up/down)
              final rotationY =
                  -value.dx * 0.3; // Rotate around Y-axis (tilt left/right)

              // Create the 3D transformation matrix
              final matrix = Matrix4.identity()
                ..setEntry(3, 2, 0.001) // Add perspective
                ..rotateX(rotationX) // Tilt based on Y mouse position
                ..rotateY(rotationY); // Tilt based on X mouse position

              return child(matrix);
            },
          ),
          MouseRegion(
            hitTestBehavior: HitTestBehavior.translucent,
            onEnter: (event) {
              mouseInside.value = true;
            },
            onHover: (event) {
              mouseCoords.value = Offset(
                event.localPosition.dx / width - 0.5,
                event.localPosition.dy / height - 0.5,
              );
            },
            onExit: (event) {
              mouseCoords.value = Offset(0, 0);
              mouseInside.value = false;
            },
          ),
        ],
      ),
    );
  }
}

double _convertRadiusToSigma(double radius) {
  return radius * 0.57735 + 0.5;
}

class SummoningCirclePaint extends CustomPainter {
  const SummoningCirclePaint({
    required this.circles,
  });

  final int circles;

  static const innerSize = 50.0;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Offset center = rect.center;

    final color = Colors.amber;

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30
      ..color = color.withAlpha(200)
      ..maskFilter = MaskFilter.blur(
        BlurStyle.normal,
        _convertRadiusToSigma(30),
      );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = 20;

    void drawPath(Path p) {
      canvas
        ..saveLayer(Rect.largest, Paint())
        ..drawPath(p, glowPaint)
        ..restore()
        ..drawPath(p, paint);
    }

    final outerCircle = Path()..addOval(rect);
    final innerCircle = Path()..addOval(rect.deflate(innerSize));

    final outerRadius = rect.center.dx.abs();

    drawPath(outerCircle);
    drawPath(innerCircle);

    final triPath = Path();
    for (int i = 0; i < circles; i++) {
      final currentCenter = getCircleCenter(i, circles, center, outerRadius);

      final tinyCirclePath = Path()
        ..addOval(
          Rect.fromCenter(
            center: currentCenter,
            width: innerSize,
            height: innerSize,
          ),
        );
      drawPath(tinyCirclePath);

      final currentCenterTri =
          getCircleCenter(i, circles, center, outerRadius - 40);
      final midCenterTri =
          getCircleCenter(i + 0.5, circles, center, outerRadius - 40 - 300 / circles);

      if (i == 0) triPath.moveTo(currentCenterTri.dx, currentCenterTri.dy);
      triPath.lineTo(currentCenterTri.dx, currentCenterTri.dy);
      triPath.lineTo(midCenterTri.dx, midCenterTri.dy);
    }
    triPath.close();
    drawPath(triPath);
  }

  Offset getCircleCenter(
      num index, int total, Offset center, double outerRadius) {
    index %= total;

    final piProg = index / total * 2 * pi;

    return Offset(
      center.dx + sin(piProg) * (outerRadius - innerSize / 2),
      center.dy + cos(piProg) * (outerRadius - innerSize / 2),
    );
  }

  @override
  bool shouldRepaint(SummoningCirclePaint oldDelegate) => false;
  @override
  bool shouldRebuildSemantics(SummoningCirclePaint oldDelegate) => false;
}
