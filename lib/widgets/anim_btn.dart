import 'package:calm_notes/colors.dart';
import 'package:calm_notes/providers/animation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimBtn extends StatefulWidget {
  final String btnText;
  final String countText;
  final ValueNotifier<bool> isSelectedNotifier;
  final VoidCallback? onPress;
  final VoidCallback? onLongPress;
  final double height;
  final double width;
  final double borderWidth;
  final double borderRadius;
  final Color borderColor;
  final EdgeInsetsGeometry? padding;

  const AnimBtn({
    super.key,
    required this.btnText,
    this.countText = '',
    required this.isSelectedNotifier,
    this.onPress,
    this.onLongPress,
    this.height = 40,
    this.width = 100,
    this.borderWidth = 0,
    this.borderRadius = 0,
    this.borderColor = Colors.transparent,
    this.padding,
  });

  @override
  State<AnimBtn> createState() => _AnimBtnState();
}

class _AnimBtnState extends State<AnimBtn> {
  @override
  Widget build(BuildContext context) {
    final animationProvider = context.watch<AnimationStateNotifier>();

    return ValueListenableBuilder<bool>(
      valueListenable: widget.isSelectedNotifier,
      builder: (context, isSelected, child) {
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
                duration: animationDuration,
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
                duration: animationDuration,
                left: isSelected ? 0 : -widget.width,
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
                duration: animationDuration,
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
                            color: isSelected
                                ? CustomColors.backgroundColor
                                : CustomColors.primaryColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      if (isSelected)
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
      },
    );
  }

  void onPressed() {
    if (!widget.isSelectedNotifier.value) {
      widget.isSelectedNotifier.value = true;
    }
    widget.onPress?.call();
  }

  void onLongPressed() {
    if (widget.isSelectedNotifier.value) {
      widget.isSelectedNotifier.value = false;
    }
    widget.onLongPress?.call();
  }
}
