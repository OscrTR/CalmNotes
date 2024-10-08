import 'package:calm_notes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomSlider extends StatefulWidget {
  final double? initialValue;
  final ValueChanged<double>? onChanged;

  const CustomSlider({
    super.key,
    this.onChanged,
    this.initialValue,
  });

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  double _sliderValue = 5;
  final Gradient _activeTrackGradient = const LinearGradient(
    colors: [CustomColors.color0, CustomColors.color5, CustomColors.color10],
  );
  final Gradient _inactiveTrackGradient = const LinearGradient(
    colors: [CustomColors.secondaryColor, CustomColors.secondaryColor],
  );

  @override
  void initState() {
    super.initState();
    _sliderValue = widget.initialValue ?? 5.0;
  }

  @override
  Widget build(BuildContext context) {
    final Color thumbColor = moodColors[_sliderValue.toInt()];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              'assets/images/mood0.svg',
              height: 22,
              width: 22,
            ),
            Expanded(child: _buildSlider(thumbColor)),
            SvgPicture.asset(
              'assets/images/mood10.svg',
              height: 22,
              width: 22,
            ),
          ],
        ),
      ],
    );
  }

  SliderTheme _buildSlider(Color thumbColor) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 8.0,
        inactiveTrackColor: CustomColors.secondaryColor,
        trackShape: CustomSliderTrackShape(
          activeTrackGradient: _activeTrackGradient,
          inactiveTrackGradient: _inactiveTrackGradient,
          trackBorder: 1,
          trackBorderColor: CustomColors.primaryColor,
        ),
        thumbShape: const CustomSliderThumbShape(enabledThumbRadius: 12.0),
        thumbColor: thumbColor,
        inactiveTickMarkColor: Colors.transparent,
        activeTickMarkColor: Colors.transparent,
        showValueIndicator: ShowValueIndicator.never,
      ),
      child: Slider(
        value: _sliderValue,
        min: 0,
        max: 10,
        divisions: 10,
        label: _sliderValue.toStringAsFixed(1),
        onChanged: (double value) {
          setState(() {
            _sliderValue = value;
          });
          widget.onChanged?.call(value);
        },
      ),
    );
  }
}

class CustomSliderThumbShape extends RoundSliderThumbShape {
  final double _enabledThumbRadius;

  const CustomSliderThumbShape({
    double enabledThumbRadius = 12.0,
  }) : _enabledThumbRadius = enabledThumbRadius;

  double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(isEnabled
        ? _enabledThumbRadius
        : disabledThumbRadius ?? _enabledThumbRadius);
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
      ..color = CustomColors.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final Path path = Path()
      ..addOval(Rect.fromCenter(
          center: center, width: 2 * radius, height: 2 * radius));

    canvas.drawShadow(path, Colors.black, evaluatedElevation, true);
    canvas.drawCircle(center, radius, paint);
    canvas.drawCircle(center, radius, borderPaint);

    // TextPainter to draw the value above the thumb
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: '${(value * 10).round()}',
        style: const TextStyle(
            fontSize: 12.0, color: CustomColors.backgroundColor),
      ),
      textAlign: TextAlign.center,
      textDirection: textDirection,
    )..layout();

    // Background rectangle position
    final Offset backgroundOffset = center - Offset(20, radius + 34.5);
    final Rect backgroundRect = Rect.fromLTWH(
      backgroundOffset.dx,
      backgroundOffset.dy,
      40,
      24,
    );

    // Draw the background rectangle
    final Paint backgroundPaint = Paint()
      ..color = CustomColors.primaryColor
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(backgroundRect, const Radius.circular(5)),
      backgroundPaint,
    );

    // Calculate the position to place the text within the background rectangle
    final Offset textOffset = center -
        Offset(
          textPainter.width / 2,
          21 + textPainter.height + 4,
        );

    // Paint the text on the canvas
    textPainter.paint(canvas, textOffset);
  }
}

class CustomSliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  final Gradient activeTrackGradient;
  final Gradient? inactiveTrackGradient;
  final double? trackBorder;
  final Color? trackBorderColor;

  CustomSliderTrackShape({
    required this.activeTrackGradient,
    this.inactiveTrackGradient,
    this.trackBorder,
    this.trackBorderColor,
  });

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
