import 'package:calm_notes/colors.dart';
import 'package:calm_notes/providers/animation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimBtn extends StatefulWidget {
  final String btnText;
  final ValueNotifier<bool> isSelectedNotifier;
  final VoidCallback? onPress;
  final VoidCallback? onLongPress;
  final double height;
  final double width;
  final double borderWidth;
  final double borderRadius;
  final Color borderColor;

  const AnimBtn({
    super.key,
    required this.btnText,
    required this.isSelectedNotifier,
    this.onPress,
    this.onLongPress,
    this.height = 40,
    this.width = 100,
    this.borderWidth = 0,
    this.borderRadius = 0,
    this.borderColor = Colors.transparent,
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
        return InkWell(
          onTap: () => onPressed(),
          onLongPress: () => onLongPressed(),
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: ClipRRect(
            borderRadius:
                BorderRadius.all(Radius.circular(widget.borderRadius)),
            child: Stack(children: [
              AnimatedContainer(
                duration: animationProvider.animate
                    ? const Duration(milliseconds: 300)
                    : Duration.zero,
                height: widget.height,
                width: widget.width,
                decoration: BoxDecoration(
                  color: CustomColors.backgroundColor,
                  border: Border.all(
                      color: widget.borderColor, width: widget.borderWidth),
                  borderRadius:
                      BorderRadius.all(Radius.circular(widget.borderRadius)),
                ),
              ),
              AnimatedPositioned(
                duration: animationProvider.animate
                    ? const Duration(milliseconds: 300)
                    : Duration.zero,
                left: isSelected ? 0 : -widget.width,
                child: Container(
                  height: widget.height,
                  width: widget.width,
                  decoration: BoxDecoration(
                      color: CustomColors.primaryColor,
                      border: Border.all(color: CustomColors.primaryColor),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                ),
              ),
              AnimatedContainer(
                duration: animationProvider.animate
                    ? const Duration(milliseconds: 300)
                    : Duration.zero,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                height: widget.height,
                width: widget.width,
                child: Align(
                  child: Text(
                    widget.btnText,
                    style: TextStyle(
                        color: isSelected
                            ? CustomColors.backgroundColor
                            : CustomColors.primaryColor,
                        overflow: TextOverflow.ellipsis),
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
