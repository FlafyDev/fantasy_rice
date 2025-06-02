import 'dart:math';
import 'dart:ui' as ui;

import 'package:fantasy_rice/providers/toplevel_textures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

double _convertRadiusToSigma(double radius) {
  return radius * 0.57735 + 0.5;
}

class Fire extends HookConsumerWidget {
  const Fire({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bars = ref.watch(waveformsProvider);

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 300,
          height: 300,
          child: Transform.translate(
            offset: Offset(150, 150),
            child: CustomPaint(
              painter: CircularWaveformPainter(
                values: bars.valueOrNull ?? [],
                strokeWidth: 20,
                round: true,
                blur: 90,
                out: true,
              ),
            ),
          ),
        ),
        Container(
          width: 80,
          height: 100,
          child: CustomPaint(
            painter: SummoningCirclePaint(bars: bars.value ?? []),
          ),
        ),
      ],
    );
  }
}

class SummoningCirclePaint extends CustomPainter {
  const SummoningCirclePaint({
    required this.bars,
  });

  final List<double> bars;

  static const innerSize = 50.0;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Offset center = rect.center;

    final color = Colors.amber;

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..color = color.withAlpha(200)
      ..maskFilter = MaskFilter.blur(
        BlurStyle.normal,
        _convertRadiusToSigma(30),
      );

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.round
      ..color = color
      ..strokeWidth = 2;

    void drawShape(Path p, Color col) {
      paint.color = col;
      glowPaint.color = col;
      canvas
        ..saveLayer(Rect.largest, Paint())
        ..drawPath(p, glowPaint)
        ..restore()
        ..drawPath(p, paint);
    }

    // final levels = [
    //   10.0,
    //   10.0,
    //   2.0,
    //   100.0,
    //   5.0,
    //   1.0,
    //   10.0,
    //   10.0,
    //   10.0,
    //   2.0,
    //   100.0,
    //   5.0,
    //   1.0,
    //   10.0
    // ];
    final levels = bars.map((e) => e * 150.0).toList();
    final levels1 = bars
        .sublist(0, (levels.length / 2).floor())
        .map((e) => e * 20.0)
        .toList();

    drawShape(createPathForLevels(rect, levels), const ui.Color.fromARGB(145, 255, 193, 7));
    drawShape(createPathForLevels(rect, levels1), const ui.Color.fromARGB(142, 244, 130, 54));

    // drawShape(
    //   Vertices(
    //     VertexMode.triangleFan,
    //     // [
    //     //   Offset(rect.right / 0, 10),
    //     //   Offset(rect.right / 1, 10),
    //     //   Offset(rect.right / 2, 50),
    //     // ]

    //     [
    //       Offset(0.0, rect.bottom),
    //       Offset(rect.right, rect.bottom),
    //     ],
    //   ),
    // );
  }

  Path createPathForLevels(Rect rect, List<double> levels) {
    final p = Path()..moveTo(0, rect.bottom);

    levels = levels.indexed.map((e) {
      var mod = (e.$1 / (levels.length / 2));
      if (mod > 1.0) {
        mod = -mod + 2.0;
      }
      return e.$2 * mod * 2.0;
    }).toList();

    for (final o in (levels.indexed.map((e) {
      return Offset(rect.right * (e.$1 / levels.length), rect.bottom - e.$2);
    }))) {
      p.lineTo(o.dx, o.dy);
    }
    p.lineTo(rect.right, rect.bottom);
    for (final o in (levels.reversed.indexed.map((e) {
      return Offset(rect.right * (1 - (e.$1 + 1) / levels.length),
          rect.bottom + e.$2 / 5);
    }))) {
      p.lineTo(o.dx, o.dy);
    }
    return p;
  }

  @override
  bool shouldRepaint(SummoningCirclePaint oldDelegate) =>
      bars != oldDelegate.bars;
  @override
  bool shouldRebuildSemantics(SummoningCirclePaint oldDelegate) => false;
}

// class _BackgroundWaveforms extends HookConsumerWidget {
//   const _BackgroundWaveforms({super.key, required this.blur, required this.out});

//   final double blur;
//   final bool out;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final waveforms = ref.watch(waveformsProvider(50));
//   }
// }

class CircularWaveformPainter extends CustomPainter {
  CircularWaveformPainter({
    required this.values,
    required this.strokeWidth,
    required this.round,
    required this.blur,
    required this.out,
  });

  List<double> values;
  final double strokeWidth;
  final bool round;
  final double blur;
  final bool out;

  @override
  void paint(Canvas canvas, Size size) {
    // values = [...values, ...values.reversed];
    final paint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(0, 0),
        size.width,
        [
          Colors.amber.withOpacity(0),
          Colors.amber.withOpacity(0),
          Colors.amberAccent.withOpacity(0.5),
          Colors.amber.withOpacity(0.2),
          // Colors.purpleAccent.withOpacity(0.2),
          // Colors.blue.withOpacity(0),
        ],
        [
          0.17,
          0.57,
          0.7,
          0.8,
          // 0.9,
          // 1,
        ],
      )
      // ..shader = ui.Gradient.radial(
      //   Offset(0, 0),
      //   size.width,
      //   [
      //     Colors.blue.withOpacity(0),
      //     Colors.greenAccent.withOpacity(0.7),
      //     Colors.blue.withOpacity(0.9),
      //   ],
      //   [
      //     0.4,
      //     0.7,
      //     1.0
      //   ],
      // )
      // blur
      ..maskFilter = blur != 0
          ? MaskFilter.blur(
              BlurStyle.normal,
              _convertRadiusToSigma(blur),
            )
          : null
      ..style = PaintingStyle.fill
      ..strokeCap = round ? StrokeCap.round : StrokeCap.square
      ..strokeWidth = 4;

    final paint2 = Paint()
      ..shader = ui.Gradient.radial(
        Offset(0, 0),
        size.width,
        [
          Colors.blue.withOpacity(0),
          Colors.blueAccent.withOpacity(0.1),
        ],
        [
          0.709,
          0.709,
        ],
      )
      ..maskFilter = blur != 0
          ? MaskFilter.blur(
              BlurStyle.normal,
              _convertRadiusToSigma(2),
            )
          : null
      ..style = PaintingStyle.fill
      ..strokeCap = round ? StrokeCap.round : StrokeCap.square
      ..strokeWidth = 20;

    final points = <Offset>[];

    for (var i = 0; i < values.length; i++) {
      final a = out ? 2 : 1.3;
      final b = out ? 1 : 1.2;
      // final length = a * (1 - pow(e, -b * values[i]));
      final length = a * pow(values[i], b);
      final progress = i / (values.length - 1);
      // I was about to start my brain, but then github copilot did it all for me :^)
      // final start = Offset(sin(progress * pi * 2) * size.width / 2, cos(progress * pi * 2) * size.height / 2);
      final end = Offset(sin(progress * pi * 2) * size.width / 2 * (1 + length),
          cos(progress * pi * 2) * size.height / 2 * (1 + length));
      points.add(end);
      // canvas.drawLine(
      //   start,
      //   end,
      //   paint,
      // );
    }
    final path = Path();

    final splinePoints = <Offset>[
      ...points,
    ];

    for (var i = 1; i < points.length - 1; i++) {
      final xc = (points[i].dx + points[i + 1].dx) / 2;
      final yc = (points[i].dy + points[i + 1].dy) / 2;
      splinePoints[i] = Offset(xc, yc);
    }

    path.moveTo(splinePoints.first.dx + size.width / 2, splinePoints.first.dy);

    for (var i = 1; i < splinePoints.length; i++) {
      final xc = (splinePoints[i].dx + splinePoints[i - 1].dx) / 2;
      final yc = (splinePoints[i].dy + splinePoints[i - 1].dy) / 2;
      path.quadraticBezierTo(
          splinePoints[i - 1].dx, splinePoints[i - 1].dy, xc, yc);
    }
    if (!out) {
      canvas
        ..drawPath(path, paint)
        ..drawPath(path, paint2);
    } else {
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CircularWaveformPainter oldDelegate) {
    return true;
    // return !listEquals(this.values, oldDelegate.values);
  }
}
