import 'package:calm_notes/colors.dart';
import 'package:calm_notes/providers/animation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimBtn extends StatefulWidget {
  final String btnText;
  final String countText;
  final bool isSelected;
  final VoidCallback? onPress;
  final VoidCallback? onLongPress;
  final double height;
  final double width;
  final double borderWidth;
  final double borderRadius;
  final Color borderColor;
  final EdgeInsetsGeometry? padding;
  final bool? enableAnimation;

  const AnimBtn({
    super.key,
    required this.btnText,
    this.countText = '',
    required this.isSelected,
    this.onPress,
    this.onLongPress,
    this.height = 40,
    this.width = 100,
    this.borderWidth = 0,
    this.borderRadius = 0,
    this.borderColor = Colors.transparent,
    this.padding,
    this.enableAnimation,
  });

  @override
  State<AnimBtn> createState() => _AnimBtnState();
}

class _AnimBtnState extends State<AnimBtn> {
  @override
  Widget build(BuildContext context) {
    final animationProvider = context.watch<AnimationStateNotifier>();
    bool animationDisabled = false;

    if (widget.enableAnimation != null && widget.enableAnimation == false) {
      animationDisabled = true;
    }

    final borderRadius = BorderRadius.circular(widget.borderRadius);
    final animationDuration = animationProvider.animate
        ? const Duration(milliseconds: 300)
        : Duration.zero;

    return InkWell(
      onTap: onPressed,
      onLongPress: onLongPressed,
      borderRadius: borderRadius,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(children: [
          AnimatedContainer(
            duration: animationDisabled ? Duration.zero : animationDuration,
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              color: CustomColors.backgroundColor,
              border: Border.all(
                  color: widget.borderColor, width: widget.borderWidth),
              borderRadius: borderRadius,
            ),
          ),
          AnimatedPositioned(
            duration: animationDisabled ? Duration.zero : animationDuration,
            left: widget.isSelected ? 0 : -widget.width,
            child: Container(
              height: widget.height,
              width: widget.width,
              decoration: BoxDecoration(
                color: CustomColors.primaryColor,
                border: Border.all(color: CustomColors.primaryColor),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          AnimatedContainer(
            duration: animationDisabled ? Duration.zero : animationDuration,
            padding: widget.padding ??
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            height: widget.height,
            width: widget.width,
            child: IntrinsicWidth(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      widget.btnText,
                      style: TextStyle(
                        color: widget.isSelected
                            ? CustomColors.backgroundColor
                            : CustomColors.primaryColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  if (widget.isSelected)
                    Text(
                      widget.countText,
                      style: const TextStyle(
                        color: CustomColors.backgroundColor,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void onPressed() {
    widget.onPress?.call();
  }

  void onLongPressed() {
    widget.onLongPress?.call();
  }
}
