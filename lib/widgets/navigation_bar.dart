import 'package:calm_notes/colors.dart';
import 'package:calm_notes/providers/emotion_provider.dart';
import 'package:calm_notes/providers/tag_provider.dart';
import 'package:calm_notes/widgets/entry_create_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          LottieIconButton(
            lottieAsset: 'assets/lottie/entries_animation.json',
            iconSize: 30,
            customAction: () {
              if (GoRouterState.of(context).uri.toString() != '/home') {
                GoRouter.of(context).push('/home');
              }
            },
          ),
          LottieIconButton(
            lottieAsset: 'assets/lottie/add_button_animation.json',
            iconSize: 50,
            customAction: () async {
              await showModalBottomSheet(
                context: context,
                useRootNavigator: true,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return DraggableScrollableSheet(
                      initialChildSize: 0.9,
                      maxChildSize: 0.9,
                      minChildSize: 0.5,
                      snap: true,
                      snapSizes: const [0.9],
                      builder: (context, scrollController) {
                        return Container(
                          decoration: const BoxDecoration(
                              color: CustomColors.backgroundColor,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          child: SingleChildScrollView(
                              clipBehavior: Clip.none,
                              controller: scrollController,
                              child: EntryCreate(
                                scrollController: scrollController,
                              )),
                        );
                      });
                },
              );
              Future.microtask(() => onModalSheetClosed(context));
            },
          ),
          LottieIconButton(
            lottieAsset: 'assets/lottie/analytics_animation.json',
            iconSize: 30,
            customAction: () {
              if (GoRouterState.of(context).uri.toString() != '/statistics') {
                GoRouter.of(context).push('/statistics');
              }
            },
          ),
        ],
      ),
    );
  }
}

void onModalSheetClosed(BuildContext context) {
  Provider.of<EmotionProvider>(context, listen: false).resetEmotions();
  Provider.of<TagProvider>(context, listen: false).resetTags();
}

class LottieIconButton extends StatefulWidget {
  final String lottieAsset;
  final double iconSize;
  final VoidCallback? customAction;

  const LottieIconButton({
    super.key,
    required this.lottieAsset,
    required this.iconSize,
    this.customAction,
  });

  @override
  LottieIconButtonState createState() => LottieIconButtonState();
}

class LottieIconButtonState extends State<LottieIconButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward(from: 0.0);
        if (widget.customAction != null) {
          widget.customAction!();
        }
      },
      child: Lottie.asset(
        widget.lottieAsset,
        controller: _controller,
        width: widget.iconSize,
        height: widget.iconSize,
        onLoaded: (composition) {
          _controller.duration = composition.duration;
        },
      ),
    );
  }
}
