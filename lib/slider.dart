import 'package:calm_notes/colors.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomSlider extends StatefulWidget {
  const CustomSlider({super.key});

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  double _currentSliderValue = 5;
  final activeTrackGradient = const LinearGradient(
      colors: [AppColors.color0, AppColors.color5, AppColors.color10]);
  final inactiveTrackGradient = const LinearGradient(
      colors: [AppColors.secondaryColor, AppColors.secondaryColor]);
  final trackBorder = 1.0;
  final trackBorderColor = AppColors.primaryColor;
  Color thumbColor = AppColors.color5;

  @override
  Widget build(BuildContext context) {
    switch (_currentSliderValue) {
      case 0:
        thumbColor = AppColors.color0;
        break;
      case 1:
        thumbColor = AppColors.color1;
        break;
      case 2:
        thumbColor = AppColors.color2;
        break;
      case 3:
        thumbColor = AppColors.color3;
        break;
      case 4:
        thumbColor = AppColors.color4;
        break;
      case 5:
        thumbColor = AppColors.color5;
        break;
      case 6:
        thumbColor = AppColors.color6;
        break;
      case 7:
        thumbColor = AppColors.color7;
        break;
      case 8:
        thumbColor = AppColors.color8;
        break;
      case 9:
        thumbColor = AppColors.color9;
        break;
      case 10:
        thumbColor = AppColors.color10;
        break;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 8.0,
            inactiveTrackColor: AppColors.secondaryColor,
            trackShape: CustomSliderTrackShape(
              activeTrackGradient: activeTrackGradient,
              inactiveTrackGradient: inactiveTrackGradient,
              trackBorder: trackBorder,
              trackBorderColor: trackBorderColor,
            ),
            thumbShape: const CustomSliderThumbShape(enabledThumbRadius: 12.0),
            thumbColor: thumbColor,
            inactiveTickMarkColor: Colors.transparent,
            activeTickMarkColor: Colors.transparent,
          ),
          child: Slider(
            value: _currentSliderValue,
            min: 0,
            max: 10,
            divisions: 10,
            label: _currentSliderValue.toStringAsFixed(1),
            onChanged: (double value) {
              setState(() {
                _currentSliderValue = value;
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Value: ${_currentSliderValue.toStringAsFixed(1)}',
          style: const TextStyle(fontSize: 24),
        ),
      ],
    );
  }
}

class CustomSliderThumbShape extends RoundSliderThumbShape {
  @override
  final double enabledThumbRadius;

  const CustomSliderThumbShape({
    this.enabledThumbRadius = 10.0,
  });

  double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(
        isEnabled ? enabledThumbRadius : _disabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    final ColorTween colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );
    final Tween<double> radiusTween = Tween<double>(
      begin: _disabledThumbRadius,
      end: enabledThumbRadius,
    );
    final Tween<double> elevationTween = Tween<double>(
      begin: elevation,
      end: pressedElevation,
    );

    final Color color = colorTween.evaluate(enableAnimation)!;
    final double radius = radiusTween.evaluate(enableAnimation);
    final double evaluatedElevation =
        elevationTween.evaluate(activationAnimation);

    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = AppColors.primaryColor // Border color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0; // Border width

    if (sliderTheme.disabledThumbColor != null &&
        sliderTheme.thumbColor != null) {
      final Path path = Path()
        ..addOval(Rect.fromCenter(
            center: center, width: 2 * radius, height: 2 * radius));

      canvas.drawShadow(path, Colors.black, evaluatedElevation, true);
      canvas.drawCircle(center, radius, paint);
      canvas.drawCircle(center, radius, borderPaint);
    }
  }
}

class CustomSliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  CustomSliderTrackShape({
    required this.activeTrackGradient,
    this.inactiveTrackGradient,
    this.trackBorder,
    this.trackBorderColor,
  });
  final Gradient activeTrackGradient;
  final Gradient? inactiveTrackGradient;
  final double? trackBorder;
  final Color? trackBorderColor;

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = false,
    bool isDiscrete = false,
    double additionalActiveTrackHeight = 2,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final ColorTween activeTrackColorTween = ColorTween(
        begin: sliderTheme.disabledActiveTrackColor, end: Colors.white);
    final ColorTween inactiveTrackColorTween = ColorTween(
        begin: sliderTheme.disabledInactiveTrackColor,
        end: inactiveTrackGradient != null
            ? Colors.white
            : sliderTheme.inactiveTrackColor);
    final Paint activePaint = Paint()
      ..shader = activeTrackGradient.createShader(trackRect)
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint inactivePaint = Paint()
      ..color = inactiveTrackColorTween.evaluate(enableAnimation)!;
    if (inactiveTrackGradient != null) {
      inactivePaint.shader = inactiveTrackGradient!.createShader(trackRect);
    }
    final canvas = context.canvas;
    final Paint leftTrackPaint;
    final Paint rightTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        break;
    }
    final Radius trackRadius = Radius.circular(trackRect.height / 2);
    final Radius activeTrackRadius =
        Radius.circular((trackRect.height + additionalActiveTrackHeight) / 2);

    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        trackRect.left,
        (textDirection == TextDirection.ltr)
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        thumbCenter.dx,
        (textDirection == TextDirection.ltr)
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        topLeft: (textDirection == TextDirection.ltr)
            ? activeTrackRadius
            : trackRadius,
        bottomLeft: (textDirection == TextDirection.ltr)
            ? activeTrackRadius
            : trackRadius,
      ),
      leftTrackPaint,
    );
    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        thumbCenter.dx,
        (textDirection == TextDirection.rtl)
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        trackRect.right,
        (textDirection == TextDirection.rtl)
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        topRight: (textDirection == TextDirection.rtl)
            ? activeTrackRadius
            : trackRadius,
        bottomRight: (textDirection == TextDirection.rtl)
            ? activeTrackRadius
            : trackRadius,
      ),
      rightTrackPaint,
    );
    if (trackBorder != null || trackBorderColor != null) {
      final strokePaint = Paint()
        ..color = trackBorderColor ?? Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = trackBorder != null
            ? trackBorder! < trackRect.height / 2
                ? trackBorder!
                : trackRect.height / 2
            : 1
        ..strokeCap = StrokeCap.round;
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(
              trackRect.left, trackRect.top, trackRect.right, trackRect.bottom,
              topLeft: trackRadius,
              bottomLeft: trackRadius,
              bottomRight: trackRadius,
              topRight: trackRadius),
          strokePaint);
    }
  }
}
