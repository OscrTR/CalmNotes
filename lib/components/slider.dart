import 'package:calm_notes/colors.dart';
import 'package:flutter/material.dart';

class CustomSlider extends StatefulWidget {
  final ValueChanged<double>? onChanged;
  const CustomSlider({super.key, this.onChanged});

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

  static Map<double, Color> thumbColors = {
    0: AppColors.color0,
    1: AppColors.color1,
    2: AppColors.color2,
    3: AppColors.color3,
    4: AppColors.color4,
    5: AppColors.color5,
    6: AppColors.color6,
    7: AppColors.color7,
    8: AppColors.color8,
    9: AppColors.color9,
    10: AppColors.color10,
  };

  @override
  Widget build(BuildContext context) {
    final Color thumbColor =
        thumbColors[_currentSliderValue] ?? AppColors.color5;
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
            showValueIndicator: ShowValueIndicator.never,
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
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
          ),
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
    final Color color = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    ).evaluate(enableAnimation)!;

    final double radius = Tween<double>(
      begin: _disabledThumbRadius,
      end: enabledThumbRadius,
    ).evaluate(enableAnimation);

    final double evaluatedElevation = Tween<double>(
      begin: elevation,
      end: pressedElevation,
    ).evaluate(activationAnimation);

    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = AppColors.primaryColor // Border color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0; // Border width

    final Path path = Path()
      ..addOval(Rect.fromCenter(
          center: center, width: 2 * radius, height: 2 * radius));

    canvas.drawShadow(path, Colors.black, evaluatedElevation, true);
    canvas.drawCircle(center, radius, paint);
    canvas.drawCircle(center, radius, borderPaint);

    // TextPainter to draw the value above the thumb
    final TextSpan span = TextSpan(
      text: '${(value * 10).round()}', // Format the value
      style: const TextStyle(
        fontSize: 12.0,
        color: AppColors.backgroundColor,
      ),
    );

    final TextPainter textPainter = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: textDirection,
    );

    textPainter.layout();

    const double backgroundWidth = 40;
    const double backgroundHeight = 24;

    // Background rectangle position
    final Offset backgroundOffset = center -
        Offset(
          backgroundWidth / 2,
          radius +
              backgroundHeight +
              9, // Offset to place background above thumb
        );

    // Draw the background rectangle
    final Paint backgroundPaint = Paint()
      ..color = AppColors.primaryColor // Background color
      ..style = PaintingStyle.fill;

    final Rect backgroundRect = Rect.fromLTWH(
      backgroundOffset.dx,
      backgroundOffset.dy,
      backgroundWidth,
      backgroundHeight,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(backgroundRect, const Radius.circular(5)),
      backgroundPaint,
    );

    // Calculate the position to place the text within the background rectangle
    final Offset textOffset = center -
        Offset(
          textPainter.width / 2,
          21 + textPainter.height + 4, // Offset to place text above the thumb
        );

    // Paint the text on the canvas
    textPainter.paint(canvas, textOffset);
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

    final Paint activePaint = _createPaint(
        activeTrackGradient, trackRect, sliderTheme, enableAnimation, true);
    final Paint inactivePaint = _createPaint(
        inactiveTrackGradient, trackRect, sliderTheme, enableAnimation, false);

    final canvas = context.canvas;

    final Radius trackRadius = Radius.circular(trackRect.height / 2);
    final Radius activeTrackRadius =
        Radius.circular((trackRect.height + additionalActiveTrackHeight) / 2);

    _drawTrack(
      canvas: canvas,
      trackRect: trackRect,
      thumbCenter: thumbCenter,
      leftTrackPaint: activePaint,
      rightTrackPaint: inactivePaint,
      textDirection: textDirection,
      activeTrackRadius: activeTrackRadius,
      trackRadius: trackRadius,
    );

    if (trackBorder != null || trackBorderColor != null) {
      _drawTrackBorder(canvas, trackRect, trackRadius);
    }
  }

  Paint _createPaint(
      Gradient? gradient,
      Rect trackRect,
      SliderThemeData sliderTheme,
      Animation<double> enableAnimation,
      bool isActive) {
    final ColorTween colorTween = ColorTween(
      begin: isActive
          ? sliderTheme.disabledActiveTrackColor
          : sliderTheme.disabledInactiveTrackColor,
      end: isActive ? Colors.white : sliderTheme.inactiveTrackColor,
    );

    final Paint paint = Paint()..color = colorTween.evaluate(enableAnimation)!;

    if (gradient != null) {
      paint.shader = gradient.createShader(trackRect);
    }

    return paint;
  }

  void _drawTrack({
    required Canvas canvas,
    required Rect trackRect,
    required Offset thumbCenter,
    required Paint leftTrackPaint,
    required Paint rightTrackPaint,
    required TextDirection textDirection,
    required Radius activeTrackRadius,
    required Radius trackRadius,
  }) {
    switch (textDirection) {
      case TextDirection.ltr:
        canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            trackRect.left,
            trackRect.top - (activeTrackRadius.y - trackRadius.y),
            thumbCenter.dx,
            trackRect.bottom + (activeTrackRadius.y - trackRadius.y),
            topLeft: activeTrackRadius,
            bottomLeft: activeTrackRadius,
          ),
          leftTrackPaint,
        );

        canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            thumbCenter.dx,
            trackRect.top,
            trackRect.right,
            trackRect.bottom,
            topRight: trackRadius,
            bottomRight: trackRadius,
          ),
          rightTrackPaint,
        );
        break;

      case TextDirection.rtl:
        canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            trackRect.left,
            trackRect.top,
            thumbCenter.dx,
            trackRect.bottom,
            topLeft: trackRadius,
            bottomLeft: trackRadius,
          ),
          rightTrackPaint,
        );

        canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            thumbCenter.dx,
            trackRect.top - (activeTrackRadius.y - trackRadius.y),
            trackRect.right,
            trackRect.bottom + (activeTrackRadius.y - trackRadius.y),
            topRight: activeTrackRadius,
            bottomRight: activeTrackRadius,
          ),
          leftTrackPaint,
        );
        break;
    }
  }

  void _drawTrackBorder(Canvas canvas, Rect trackRect, Radius trackRadius) {
    final Paint strokePaint = Paint()
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
        trackRect.left,
        trackRect.top,
        trackRect.right,
        trackRect.bottom,
        topLeft: trackRadius,
        bottomLeft: trackRadius,
        bottomRight: trackRadius,
        topRight: trackRadius,
      ),
      strokePaint,
    );
  }
}
