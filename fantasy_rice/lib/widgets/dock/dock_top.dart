import 'package:dart_debouncer/dart_debouncer.dart';
import 'package:fantasy_rice/providers/pc_info.dart';
import 'package:fantasy_rice/widgets/smooth_graph/smooth_graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayland_shell/wayland_shell.dart';

class DockTop extends HookConsumerWidget {
  const DockTop({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final openAC = useAnimationController(initialValue: 0.0);
    final debouncer =
        useRef(Debouncer(timerDuration: Duration(milliseconds: 50)));
    final a = ref.watch(pCInfoHistoryProvider);

    const increase = 120.0;

    return MouseRegion(
      onHover: (e) {
        debouncer.value.resetDebounce(() {
          openAC.animateTo(
            1.0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOutExpo,
          );
        });
      },
      onExit: (e) {
        debouncer.value.resetDebounce(() {
          openAC.animateTo(
            0.0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOutExpo,
          );
        });
      },
      child: AnimatedBuilder(
        animation: openAC,
        builder: (context, child) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Positioned(
              //   top: 33 - increase * openAC.value + 45,
              //   left: 6,
              //   child: InputRegion(
              //     child: Container(
              //       color: const Color.fromARGB(255, 223, 175, 99),
              //       width: 824 / 2,
              //       height: 45 + increase * openAC.value,
              //       clipBehavior: Clip.none,
              //       child: Visibility(
              //         visible: openAC.value > 0.2,
              //         child: Column(
              //           children: [
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceAround,
              //               children: [
              //                 Text(
              //                   "Battery",
              //                   style: TextStyle(
              //                     fontFamily: "whiteCupertino",
              //                   ),
              //                 ),
              //                 Text(
              //                   "RAM",
              //                   style: TextStyle(
              //                     fontFamily: "whiteCupertino",
              //                   ),
              //                 ),
              //               ],
              //             ),
              //             SizedBox(height: 20),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceAround,
              //               children: [
              //                 Container(
              //                   width: 100,
              //                   height: 50,
              //                   child: Consumer(
              //                     builder: (context, ref, child) {
              //                       final cpu = ref.watch(pCInfoHistoryProvider
              //                           .select((m) => m.cpuUsage));
              //                       return SmoothGraph(
              //                         borderRadius: 1,
              //                         ballSize: 4,
              //                         refreshRate:
              //                             const Duration(milliseconds: 400),
              //                         ballGlowMultiplier: 1 / 2,
              //                         valueHistory: [cpu],
              //                         latestValue: [cpu.last],
              //                         lowestMaxValue: 1.1,
              //                         topValueSpacing: 1.1,
              //                         tint: cpu.last >= 0.8
              //                             ? Colors.red
              //                             : const Color.fromARGB(
              //                                 255, 102, 68, 15),
              //                       );
              //                     },
              //                   ),
              //                 ),
              //                 Container(
              //                   width: 100,
              //                   height: 50,
              //                   child: Consumer(
              //                     builder: (context, ref, child) {
              //                       final cpu = ref.watch(pCInfoHistoryProvider
              //                           .select((m) => m.cpuUsage));
              //                       return SmoothGraph(
              //                         borderRadius: 1,
              //                         ballSize: 4,
              //                         refreshRate:
              //                             const Duration(milliseconds: 400),
              //                         ballGlowMultiplier: 1 / 2,
              //                         valueHistory: [cpu],
              //                         latestValue: [cpu.last],
              //                         lowestMaxValue: 1.1,
              //                         topValueSpacing: 1.1,
              //                         tint: cpu.last >= 0.8
              //                             ? Colors.red
              //                             : const Color.fromARGB(
              //                                 255, 102, 68, 15),
              //                       );
              //                     },
              //                   ),
              //                 ),
              //                 Container(
              //                   width: 100,
              //                   height: 50,
              //                   child: Consumer(
              //                     builder: (context, ref, child) {
              //                       final cpu = ref.watch(pCInfoHistoryProvider
              //                           .select((m) => m.cpuUsage));
              //                       return SmoothGraph(
              //                         borderRadius: 1,
              //                         ballSize: 4,
              //                         refreshRate:
              //                             const Duration(milliseconds: 400),
              //                         ballGlowMultiplier: 1 / 2,
              //                         valueHistory: [cpu],
              //                         latestValue: [cpu.last],
              //                         lowestMaxValue: 1.1,
              //                         topValueSpacing: 1.1,
              //                         tint: cpu.last >= 0.8
              //                             ? Colors.red
              //                             : const Color.fromARGB(
              //                                 255, 102, 68, 15),
              //                       );
              //                     },
              //                   ),
              //                 )
              //               ],
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // Positioned(
              //   top: -increase * openAC.value + 15,
              //   left: 6,
              //   child: Image.asset("assets/dock/borders/top_bg.png", scale: 2),
              // ),
              // Positioned(
              //   top: -increase * openAC.value,
              //   child:
              //       Image.asset("assets/dock/borders/rice_top.png", scale: 2),
              // ),
              Opacity(
                opacity: 1.00,
                child:
                    Image.asset("assets/dock/borders/rice_top.png", scale: 2),
              ),
              // Positioned(
              //   top: -increase * openAC.value,
              //   child: Visibility(
              //     visible: openAC.value > 0.0,
              //     child: ,
              //   ),
              // ),
              // Positioned(
              //   top: 33 - increase * openAC.value + 5,
              //   left: 260,
              //   child: Container(
              //     width: 145,
              //     height: 30,
              //     child: CustomPaint(
              //       painter: InnerPaint(
              //         flip: true,
              //         progress: 1.0,
              //       ),
              //     ),
              //   ),
              // ),
              // Positioned(
              //   top: 33 - increase * openAC.value + 5,
              //   left: 20,
              //   child: Container(
              //     width: 145,
              //     height: 30,
              //     child: CustomPaint(
              //       painter: InnerPaint(
              //         flip: false,
              //         progress: 1.0,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          );
        },
      ),
    );
  }
}

class InnerPaint extends CustomPainter {
  const InnerPaint({
    required this.flip,
    required this.progress,
  });

  final bool flip;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Offset center = rect.center;

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color.fromARGB(111, 126, 98, 45)
      ..strokeWidth = 2;

    void drawPath(Path p) {
      canvas.drawPath(p, paint);
    }

    final p = Path();

    if (flip) {
      p.moveTo(rect.right * (1.0 - 0.05), rect.bottom);
      p.lineTo(rect.right * (1.0 - 0.23), rect.bottom * 0.23);
      p.lineTo(
          rect.right * ((1.0 - 0.23) - (progress - 0.23)), rect.bottom * 0);
      p.lineTo(rect.right * ((1.0 - 0.23) - (progress - 0.23)), rect.bottom);
    } else {
      p.moveTo(rect.right * 0.05, rect.bottom);
      p.lineTo(rect.right * (0.23), rect.bottom * 0.23);
      p.lineTo(rect.right * (0.23 + (progress - 0.23)), rect.top);
      p.lineTo(rect.right * (0.23 + (progress - 0.23)), rect.bottom);
    }

    drawPath(p);
  }

  @override
  bool shouldRepaint(InnerPaint oldDelegate) => false;
  @override
  bool shouldRebuildSemantics(InnerPaint oldDelegate) => false;
}
