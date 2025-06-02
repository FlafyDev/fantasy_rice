// ignore_for_file: implementation_imports, invalid_use_of_visible_for_testing_member

import 'dart:math';
import 'dart:typed_data';

import 'package:fantasy_rice/utils/rect_custom_clipper.dart';
import 'package:fantasy_rice/utils/timer_stream.dart';
import 'package:fantasy_rice/utils/use_values_changed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;
import 'package:collection/collection.dart';

class SmoothGraph extends HookConsumerWidget {
  const SmoothGraph({
    super.key,
    required this.valueHistory,
    required this.latestValue,
    required this.tint,
    this.graphsTint,
    this.animate = true,
    this.lowestMaxValue = 1,
    this.topValueSpacing = 1.2,
    this.ballSize = 12.0,
    this.borderRadius = 10.0,
    this.refreshRate = const Duration(milliseconds: 500),
    this.ballGlowMultiplier = 1,
    this.pastPoints = 1,
    this.futurePoints = 1,
    this.graphAccuracy = 100,
  });

  final List<List<double>> valueHistory;
  final List<double> latestValue;
  final bool animate;
  final Color tint;
  final List<Color>? graphsTint;
  // The graph will show the values proportionate to the max value.
  final double lowestMaxValue;
  final double topValueSpacing;
  final double ballSize;
  final double borderRadius;
  final Duration refreshRate;
  final double ballGlowMultiplier;
  final int pastPoints;
  final int futurePoints;
  final int graphAccuracy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final additionalPointsNum = pastPoints + futurePoints;
    assert(futurePoints >= 1, 'futurePoints must be at least 1.');
    assert(pastPoints >= 1, 'pastPoints must be at least 1.');
    // assert(valueHistory.length >= additionalPointsNum, 'valueHistory must have at least ${pastPoints + futurePoints} points values.');
    // useValueChanged<List<double>, Object?>(valueHistory, (oldValue, _) {
    //   assert(oldValue.length == valueHistory.length, 'valueHistory must not change length.');
    //   return null;
    // });
    // useValueChanged<int, Object?>(pastPoints, (oldValue, _) {
    //   assert(oldValue == pastPoints, 'pastPoints must not be changed.');
    //   return null;
    // });
    // useValueChanged<int, Object?>(futurePoints, (oldValue, _) {
    //   assert(oldValue == futurePoints, 'futurePoints must not be changed.');
    //   return null;
    // });

    final graphsNum = valueHistory.length;
    final visiblePointsNum = valueHistory.first.length - additionalPointsNum;
    final pointSpace = 1 / visiblePointsNum;
    final moveAC = useAnimationController(duration: refreshRate);
    final maxValueAC = useAnimationController(
      initialValue: lowestMaxValue,
      upperBound: double.infinity,
    );
    final maxValueTarget = useRef(lowestMaxValue);
    final points = useState([
      <Offset>[]
    ]);
    // final lastSectionGraphY = useState(<double>[]);

    void updateMaxValue({required bool animate}) {
      final newValue = max(
        lowestMaxValue,
        points.value.map((graphPoints) => graphPoints.skip(pastPoints - 1).take(visiblePointsNum + 2).map((p) => p.dy)).flattened.reduce((prev, curr) => max(prev, curr)) * topValueSpacing,
      );
      if (animate) {
        if (maxValueTarget.value != newValue) {
          maxValueAC.animateTo(
            newValue,
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOut,
          );
        }
      } else {
        maxValueAC.value = newValue;
      }
      maxValueTarget.value = newValue;
    }

    useEffect(
      () {
        void progressGraph() {
          if (moveAC.status == AnimationStatus.completed) {
            if (animate) {
              moveAC
                ..reset()
                ..forward();
            }
            points.value = points.value
                .mapIndexed(
                  (i, graphPoints) =>
                      graphPoints.skip(1).map((p) => Offset(p.dx - pointSpace, p.dy)).toList() +
                      [
                        Offset(
                          1 + pointSpace * (futurePoints),
                          latestValue[i],
                        ),
                      ],
                )
                .toList();
            updateMaxValue(animate: true);
          }
        }

        if (animate) {
          moveAC.addListener(progressGraph);
          return () => moveAC.removeListener(progressGraph);
        } else {
          final sub = timerStream(refreshRate).listen((_) => progressGraph());
          return sub.cancel;
        }
      },
      [
        latestValue,
        animate,
        moveAC,
        points,
        maxValueAC,
      ],
    );

    useValuesChanged(
      [
        animate,
      ],
      firstTime: true,
      callback: () {
        if (animate) {
          moveAC.forward(from: 0);
        }
      },
    );

    useValuesChanged(
      [],
      firstTime: true,
      callback: () {
        points.value = List.generate(
          graphsNum,
          (j) => List.generate(
            visiblePointsNum + additionalPointsNum,
            (i) => Offset(
              (i - pastPoints + 1) * pointSpace,
              valueHistory[j][i],
            ),
          ),
        );

        updateMaxValue(animate: false);

        return;
      },
    );

    return AnimatedBuilder(
      animation: maxValueAC,
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final graphPaths = <Path>[];
            final lastSectionGraphsY = <List<double>>[];
            final graphs = <CustomPaint>[];
            final graphsGlow = <CustomPaint>[];

            for (int i = 0; i < graphsNum; i++) {
              final res = _createSmoothGraphFromPoints(points.value[i], graphAccuracy, pointsFromEnd: 1);
              graphPaths.add(res.$1.transform(
                Matrix4Transform().scaleBy(x: constraints.maxWidth, y: -constraints.maxHeight / maxValueAC.value).translate(y: constraints.maxHeight).matrix4.storage,
              ));
              lastSectionGraphsY.add(res.$2);
              graphs.add(CustomPaint(
                painter: _PathPainter(
                  path: graphPaths[i],
                  color: graphsTint?[i] ?? tint,
                  glow: false,
                ),
              ));
              graphsGlow.add(CustomPaint(
                painter: _PathPainter(
                  path: graphPaths[i],
                  color: graphsTint?[i] ?? tint,
                  glow: true,
                ),
              ));
            }

            return AnimatedBuilder(
              animation: moveAC,
              child: Stack(
                children: graphs,
              ),
              builder: (context, graphs) {
                final ballOffset = 0;
                final lastSectionGraphY = lastSectionGraphsY[0];
                final y = lastSectionGraphY[-(ballOffset / constraints.maxWidth / pointSpace * graphAccuracy).round() + lastSectionGraphY.length - graphAccuracy - 1 + (moveAC.value * graphAccuracy).round()] * -(constraints.maxHeight / maxValueAC.value) + constraints.maxHeight;
                return CustomPaint(
                  painter: _GradientPainter(
                    strokeWidth: 1,
                    radius: borderRadius,
                    gradient: LinearGradient(
                      end: Alignment(
                        1,
                        (y / constraints.maxHeight * 2 - 1) * 2,
                      ),
                      stops: const [
                        0.0,
                        0.9,
                        1.0,
                      ],
                      colors: [
                        tint.withOpacity(0.1),
                        tint.withOpacity(0.1),
                        tint.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Ball glow
                          Positioned(
                            // left: constraints.maxWidth/2 -
                            //     ballOffset -
                            //     ballSize / 2,
                            // top: y - ballSize / 2,
                            width: constraints.maxWidth,
                            height: constraints.maxHeight,
                            child: ClipRRect(
                              clipBehavior: Clip.hardEdge,
                              borderRadius: BorderRadius.circular(borderRadius),
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: constraints.maxWidth - ballOffset - ballSize / 2,
                                    top: y - ballSize / 2,
                                    child: SizedBox(
                                      width: ballSize,
                                      height: ballSize,
                                      child: Center(
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: tint,
                                                blurRadius: 60 * ballGlowMultiplier,
                                                spreadRadius: 30 * ballGlowMultiplier,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Graph glow
                          // Positioned(
                          //   left: -moveAC.value * (constraints.maxWidth / visiblePointsNum),
                          //   width: constraints.maxWidth,
                          //   height: constraints.maxHeight,
                          //   child: ClipRRect(
                          //     clipper: RRectCustomClipper(
                          //       (size) => RRect.fromRectAndRadius(
                          //         Rect.fromLTRB(
                          //           moveAC.value * (constraints.maxWidth / visiblePointsNum),
                          //           0,
                          //           size.width + moveAC.value * (constraints.maxWidth / visiblePointsNum),
                          //           size.height,
                          //         ),
                          //         Radius.circular(borderRadius),
                          //       ),
                          //     ),
                          //     child: graphGlow,
                          //   ),
                          // ),
                          // Graph line
                          ClipRRect(
                            borderRadius: BorderRadius.circular(borderRadius),
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: const BoxDecoration(),
                              width: constraints.maxWidth,
                              child: Stack(
                                clipBehavior: Clip.hardEdge,
                                children: [
                                  Positioned(
                                    left: -moveAC.value * (constraints.maxWidth / visiblePointsNum),
                                    width: constraints.maxWidth,
                                    height: constraints.maxHeight,
                                    child: graphs!,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Ball
                          // TODO: Add border radius to clip
                          Positioned(
                            // left: constraints.maxWidth/2 -
                            //     ballOffset -
                            //     ballSize / 2,
                            // top: y - ballSize / 2,
                            width: constraints.maxWidth,
                            height: constraints.maxHeight,
                            child: ClipRRect(
                              clipBehavior: Clip.hardEdge,
                              borderRadius: BorderRadius.circular(borderRadius),
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: constraints.maxWidth - ballOffset - ballSize / 2,
                                    top: y - ballSize / 2,
                                    child: ClipRect(
                                      clipper: RectCustomClipper(
                                        (size) => Rect.fromLTRB(
                                          0,
                                          0,
                                          size.width,
                                          size.height,
                                        ),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          border: Border.all(
                                            color: tint,
                                            width: ballSize / 8,
                                          ),
                                        ),
                                        width: ballSize,
                                        height: ballSize,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

/// Interpolation using piecewise cubic Hermite polynomial.
List<double> pchipInterpolate(List<double> xi, List<double> yi, List<double> x) {
  var xIndex = List<int>.filled(x.length, 0);
  final xiStep = (xi.last - xi.first) / (xi.length - 1);
  xIndex = x.map((e) => min(max(((e - xi.first) / xiStep).floor(), 0), xi.length - 2)).toList();

  var h = (xi.last - xi.first) / (xi.length - 1);

  List<double> delta = yi.asMap().entries.skip(1).fold(
      <double>[],
      (acc, e) => [
            ...acc,
            (yi[e.key] - yi[e.key - 1]) / h
          ]);
  List<double> d = List.generate(xi.length, (i) => 0);

  d = [
    delta.first,
    ...(_addListWithList(
      delta.skip(1).map((e) => 1 / e).toList(),
      delta.take(delta.length - 1).map((e) => 1 / e).toList(),
    )).map((e) => 2 / e).toList(),
    delta.last,
  ];
  final dFilters = [
    false,
    ...List.generate(delta.length - 1, (i) => (delta[i] > 0) != (delta[i + 1] > 0)),
    false
  ];

  final l1 = [
    false,
    ...delta.map((e) => e == 0)
  ];
  final l2 = [
    ...delta.map((e) => e == 0),
    false
  ];

  final dFilters2 = l1.asMap().entries.map((e) => e.value || l2[e.key]).toList();

  for (int i = 0; i < d.length; i++) {
    if (dFilters2[i] || dFilters[i]) d[i] = 0;
  }

  final xixindex = xIndex.map((e) => xi[e]).toList();
  final xi1xindex = xIndex.map((e) => xi[1 + e]).toList();

  var dxxi = x.asMap().entries.map((e) => e.value - xixindex[e.key]).toList();
  var dxxid = x.asMap().entries.map((e) => e.value - xi1xindex[e.key]).toList();
  var dxxi2 = dxxi.map((e) => e * e).toList();
  var dxxid2 = dxxid.map((e) => e * e).toList();

  final y = _addListWithList(
    _addListWithList(
      _multiplyLists(_multiplyLists(_indexListWithList(yi, xIndex), dxxid2), _addToList(dxxi, h / 2)),
      _multiplyLists(_multiplyLists(_indexListWithList(yi, xIndex.map((e) => e + 1).toList()), dxxi2), _addToList(dxxid, -h / 2)).map((e) => -e).toList(),
    ).map((e) => e * (2 / (h * h * h))).toList(),
    _addListWithList(_multiplyLists(_multiplyLists(_indexListWithList(d, xIndex), dxxid2), dxxi), _multiplyLists(_multiplyLists(_indexListWithList(d, xIndex.map((e) => e + 1).toList()), dxxi2), dxxid)).map((e) => e * 1 / (h * h)).toList(),
  );

  return y;
}

List<T> _addListWithList<T extends num>(List<T> list, List<T> other) {
  if (list.length != other.length) {
    throw ArgumentError("Arrays must have the same length.");
  }

  final result = <num>[];

  for (int i = 0; i < list.length; i++) {
    result.add(list[i] + other[i]);
  }

  return result.map((e) => e as T).toList();
}

List<T> _addToList<T extends num>(List<T> list, T value) {
  return list.map((e) => e + value).map((e) => e as T).toList();
}

List<T> _multiplyLists<T extends num>(List<T> list, List<T> other) {
  if (list.length != other.length) {
    throw ArgumentError("Arrays must have the same length.");
  }

  final result = <num>[];

  for (int i = 0; i < list.length; i++) {
    result.add(list[i] * other[i]);
  }

  return result.map((e) => e as T).toList();
}

List<T> _indexListWithList<T>(List<T> list, List<int> indexList) {
  return indexList.map((i) => list[i]).toList();
}

(
  Path,
  List<double>
) _createSmoothGraphFromPoints(List<Offset> points, int accuracy, {int pointsFromEnd = 0}) {
  final path = Path();
  if (points.isEmpty) throw Exception("Path must not be empty.");

  final newX = List.generate(
    accuracy * points.length,
    (i) => points.first.dx + i / accuracy * (points[1].dx - points[0].dx),
  );

  final newY = pchipInterpolate(points.map((p) => p.dx).toList(), points.map((p) => p.dy).toList(), newX);

  path.moveTo(points.first.dx, points.first.dy);
  for (int i = 1; i < newX.length; i++) {
    path.lineTo(newX[i], newY[i]);
  }

  return (
    path,
    newY.skip(newY.length - 1 - accuracy * (pointsFromEnd + 1 + points.fold(0, (acc, p) => acc + (p.dx > 1.0 ? 1 : 0)))).take(1 + (1 + pointsFromEnd) * accuracy).toList()
  );
}

double _convertRadiusToSigma(double radius) {
  return radius * 0.57735 + 0.5;
}

class _PathPainter extends CustomPainter {
  _PathPainter({
    required this.path,
    required this.glow,
    required this.color,
  });

  final Paint _paint = Paint();
  final Path path;
  final bool glow;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    _paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = glow ? 30 : 1
      ..color = glow ? color.withOpacity(0.7) : color
      ..maskFilter = glow
          ? MaskFilter.blur(
              BlurStyle.normal,
              _convertRadiusToSigma(90),
            )
          : null;
    if (glow) {
      canvas
        ..saveLayer(Rect.largest, Paint())
        ..drawPath(path, _paint);
      final closedPath = path.shift(Offset.zero)
        ..relativeLineTo(0, -size.height * 2)
        ..relativeLineTo(-size.width * 2, 0)
        ..relativeLineTo(0, size.height * 2)
        ..close();
      canvas
        ..drawPath(
          closedPath,
          Paint()
            ..style = PaintingStyle.fill
            ..blendMode = BlendMode.clear,
        )
        ..restore();
    } else {
      canvas.drawPath(path, _paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}

class _GradientPainter extends CustomPainter {
  _GradientPainter({
    required this.strokeWidth,
    required this.radius,
    required this.gradient,
  });

  final Paint _paint = Paint();
  final double radius;
  final double strokeWidth;
  final Gradient gradient;

  @override
  void paint(Canvas canvas, Size size) {
    // create outer rectangle equals size
    final outerRect = Offset.zero & size;
    final outerRRect = RRect.fromRectAndRadius(outerRect, Radius.circular(radius));

    // create inner rectangle smaller by strokeWidth
    final innerRect = Rect.fromLTWH(
      strokeWidth,
      strokeWidth,
      size.width - strokeWidth * 2,
      size.height - strokeWidth * 2,
    );
    final innerRRect = RRect.fromRectAndRadius(
      innerRect,
      Radius.circular(radius - strokeWidth),
    );

    // apply gradient shader
    _paint.shader = gradient.createShader(outerRect);

    // create difference between outer and inner paths and draw it
    final path1 = Path()..addRRect(outerRRect);
    final path2 = Path()..addRRect(innerRRect);
    final path = Path.combine(PathOperation.difference, path1, path2);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}
