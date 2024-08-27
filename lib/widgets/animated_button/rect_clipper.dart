import 'package:flutter/material.dart';
import '/widgets/animated_button/transition_type.dart';
import 'dart:math';

class RectClipper extends CustomClipper<Path> {
  final double clipFactor;
  final TransitionType transitionType;

  RectClipper(this.clipFactor, this.transitionType);

  @override
  Path getClip(Size size) {
    Path path = Path();

    switch (transitionType) {
      case TransitionType.leftToRight:
        path.lineTo(size.width * clipFactor, 0.0);
        path.lineTo(size.width * clipFactor, size.height);
        path.lineTo(0.0, size.height);
        break;
      case TransitionType.rightToLeft:
        path.moveTo(size.width, 0.0);
        path.lineTo(size.width * clipFactor, 0.0);
        path.lineTo(size.width * clipFactor, size.height);
        path.lineTo(size.width, size.height);
        break;

      case TransitionType.topToBottom:
        path.lineTo(0.0, size.height * clipFactor);
        path.lineTo(size.width, size.height * clipFactor);
        path.lineTo(size.width, 0.0);
        break;
      case TransitionType.bottomToTop:
        path.moveTo(0.0, size.height);
        path.lineTo(0.0, size.height * clipFactor);
        path.lineTo(size.width, size.height * clipFactor);
        path.lineTo(size.width, size.height);

        break;
      case TransitionType.centerLRIn:
        path.moveTo(size.width / 2 * clipFactor, 0);
        path.lineTo(0, 0);
        path.lineTo(0, size.height);
        path.lineTo(size.width, size.height);
        path.lineTo(size.width, 0);
        path.lineTo(size.width - (size.width / 2 * clipFactor), 0);
        path.lineTo(size.width - (size.width / 2 * clipFactor), size.height);
        path.lineTo(size.width / 2 * clipFactor, size.height);

        break;
      case TransitionType.centerTBIn:
        path.moveTo(0, size.height / 2 * clipFactor);
        path.lineTo(0, 0);
        path.lineTo(size.width, 0);
        path.lineTo(size.width, size.height / 2 * clipFactor);
        path.lineTo(0, size.height / 2 * clipFactor);
        path.lineTo(0, size.height);
        path.lineTo(size.width, size.height);
        path.lineTo(size.width, size.height - (size.height / 2 * clipFactor));
        path.lineTo(0, size.height - (size.height / 2 * clipFactor));
        break;
      case TransitionType.centerLROut:
        var halfWidth = size.width / 2;
        var clipFactorWidth = halfWidth * clipFactor;
        path.moveTo(halfWidth, 0.0);
        path.lineTo(halfWidth - clipFactorWidth, 0);
        path.lineTo(halfWidth - clipFactorWidth, size.height);
        path.lineTo(halfWidth + clipFactorWidth, size.height);
        path.lineTo(halfWidth + clipFactorWidth, 0);
        break;
      case TransitionType.centerTBOut:
        var halfHeight = size.height / 2;
        var clipFactorHeight = halfHeight * clipFactor;
        path.moveTo(0.0, halfHeight);
        path.lineTo(0, halfHeight - clipFactorHeight);
        path.lineTo(size.width, halfHeight - clipFactorHeight);
        path.lineTo(size.width, halfHeight + clipFactorHeight);
        path.lineTo(0.0, halfHeight + clipFactorHeight);
        break;
      case TransitionType.leftTopRounder:
        path.addOval(Rect.fromCircle(
            center: const Offset(0, 0),
            radius:
                (sqrt((size.width * size.width) + (size.height * size.height)) *
                    clipFactor)));
        break;
      case TransitionType.leftBottomRounder:
        path.addOval(Rect.fromCircle(
            center: Offset(0, size.height),
            radius:
                (sqrt((size.width * size.width) + (size.height * size.height)) *
                    clipFactor)));
        break;
      case TransitionType.leftCenterRounder:
        path.addOval(Rect.fromCircle(
            center: Offset(0, size.height / 2),
            radius:
                (sqrt((size.width * size.width) + (size.height * size.height)) *
                    clipFactor)));
        break;
      case TransitionType.rightBottomRounder:
        path.addOval(Rect.fromCircle(
            center: Offset(size.width, size.height),
            radius:
                (sqrt((size.width * size.width) + (size.height * size.height)) *
                    clipFactor)));
        break;
      case TransitionType.rightTopRounder:
        path.addOval(Rect.fromCircle(
            center: Offset(size.width, 0),
            radius:
                (sqrt((size.width * size.width) + (size.height * size.height)) *
                    clipFactor)));
        break;
      case TransitionType.rightCenterRounder:
        path.addOval(Rect.fromCircle(
            center: Offset(size.width, size.height / 2),
            radius:
                (sqrt((size.width * size.width) + (size.height * size.height)) *
                    clipFactor)));
        break;
      case TransitionType.topCenterRounder:
        path.addOval(Rect.fromCircle(
            center: Offset(size.width / 2, 0),
            radius:
                (sqrt((size.width * size.width) + (size.height * size.height)) *
                    clipFactor)));
        break;
      case TransitionType.bottomCenterRounder:
        path.addOval(Rect.fromCircle(
            center: Offset(size.width / 2, size.height),
            radius:
                (sqrt((size.width * size.width) + (size.height * size.height)) *
                    clipFactor)));
        break;
      case TransitionType.centerRounder:
        path.addOval(Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2),
            radius:
                (sqrt((size.width * size.width) + (size.height * size.height)) *
                    clipFactor)));
        break;
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class RectStripClipper extends CustomClipper<Path> {
  final double clipFactor;
  final StripTransitionType transitionType;

  RectStripClipper(this.clipFactor, this.transitionType);

  @override
  Path getClip(Size size) {
    Path path = Path();

    switch (transitionType) {
      case StripTransitionType.leftToRight:
        path.lineTo(size.width * clipFactor, 0.0);
        path.lineTo(size.width * clipFactor, size.height);
        path.lineTo(0.0, size.height);
        break;
      case StripTransitionType.rightToLeft:
        path.moveTo(size.width, 0.0);
        path.lineTo(size.width * clipFactor, 0.0);
        path.lineTo(size.width * clipFactor, size.height);
        path.lineTo(size.width, size.height);
        break;

      case StripTransitionType.topToBottom:
        path.lineTo(0.0, size.height * clipFactor);
        path.lineTo(size.width, size.height * clipFactor);
        path.lineTo(size.width, 0.0);
        break;
      case StripTransitionType.bottomToTop:
        path.moveTo(0.0, size.height);
        path.lineTo(0.0, size.height * clipFactor);
        path.lineTo(size.width, size.height * clipFactor);
        path.lineTo(size.width, size.height);

        break;
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
