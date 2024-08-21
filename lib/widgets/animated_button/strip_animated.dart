import 'package:flutter/widgets.dart';
import 'transition_type.dart';

class StripAnimated extends StatelessWidget {
  final StripTransitionType animationType;
  final Color stripColor;
  final double stripSize;
  final Text text;
  final AlignmentGeometry textAlignment;

  const StripAnimated(
      {super.key,
      required this.animationType,
      required this.stripColor,
      required this.stripSize,
      required this.text,
      required this.textAlignment});

  @override
  Widget build(BuildContext context) {
    if (animationType == StripTransitionType.BOTTOM_TO_TOP ||
        animationType == StripTransitionType.TOP_TO_BOTTOM) {
      return Column(
        children: [
          if (animationType == StripTransitionType.TOP_TO_BOTTOM)
            Container(
              width: double.infinity,
              height: stripSize,
              color: stripColor,
            ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  top: animationType == StripTransitionType.TOP_TO_BOTTOM
                      ? 0
                      : stripSize,
                  bottom: animationType == StripTransitionType.BOTTOM_TO_TOP
                      ? 0
                      : stripSize),
              child: Align(
                alignment: textAlignment,
                child: text,
              ),
            ),
          ),
          if (animationType == StripTransitionType.BOTTOM_TO_TOP)
            Container(
              width: double.infinity,
              height: stripSize,
              color: stripColor,
            ),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (animationType == StripTransitionType.LEFT_TO_RIGHT)
            Container(
                width: stripSize, height: double.infinity, color: stripColor),
          Expanded(
              child: Align(
            alignment: textAlignment,
            child: text,
          )),
          if (animationType == StripTransitionType.RIGHT_TO_LEFT)
            Container(
                width: stripSize, height: double.infinity, color: stripColor)
        ],
      );
    }
  }
}
