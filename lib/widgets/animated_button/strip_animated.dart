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
    if (animationType == StripTransitionType.bottomToTop ||
        animationType == StripTransitionType.topToBottom) {
      return Column(
        children: [
          if (animationType == StripTransitionType.topToBottom)
            Container(
              width: double.infinity,
              height: stripSize,
              color: stripColor,
            ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  top: animationType == StripTransitionType.topToBottom
                      ? 0
                      : stripSize,
                  bottom: animationType == StripTransitionType.bottomToTop
                      ? 0
                      : stripSize),
              child: Align(
                alignment: textAlignment,
                child: text,
              ),
            ),
          ),
          if (animationType == StripTransitionType.bottomToTop)
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
          if (animationType == StripTransitionType.leftToRight)
            Container(
                width: stripSize, height: double.infinity, color: stripColor),
          Expanded(
              child: Align(
            alignment: textAlignment,
            child: text,
          )),
          if (animationType == StripTransitionType.rightToLeft)
            Container(
                width: stripSize, height: double.infinity, color: stripColor)
        ],
      );
    }
  }
}
