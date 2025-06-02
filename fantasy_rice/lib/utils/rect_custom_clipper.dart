import 'package:flutter/rendering.dart';

class RRectCustomClipper extends CustomClipper<RRect> {
  const RRectCustomClipper(RRect Function(Size size) getClip)
      : _getClip = getClip;

  final RRect Function(Size size) _getClip;

  @override
  RRect getClip(Size size) => _getClip(size);

  @override
  bool shouldReclip(covariant CustomClipper<RRect> oldClipper) =>
      oldClipper != this;
}

class RectCustomClipper extends CustomClipper<Rect> {
  const RectCustomClipper(Rect Function(Size size) getClip)
      : _getClip = getClip;

  final Rect Function(Size size) _getClip;

  @override
  Rect getClip(Size size) => _getClip(size);

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) =>
      oldClipper != this;
}
