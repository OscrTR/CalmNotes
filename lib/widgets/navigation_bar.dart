import 'package:calm_notes/providers/emotion_provider.dart';
import 'package:calm_notes/providers/tag_provider.dart';
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
          IconButton(
              onPressed: () async {
                if (GoRouterState.of(context).uri.toString() != '/entry') {
                  GoRouter.of(context).push('/entry');
                }
              },
              icon: const Icon(
                Icons.add_circle,
                size: 40,
              )),
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
