import 'package:calm_notes/providers/animation_provider.dart';
import 'package:calm_notes/providers/emotion_provider.dart';
import 'package:calm_notes/providers/tag_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  double _getTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: ui.TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size.width + 5;
  }

  @override
  Widget build(BuildContext context) {
    final double statsWidth = _getTextWidth(
        context.tr('navigation_statistics'), const TextStyle(fontSize: 16));
    bool isStatsPage =
        GoRouterState.of(context).uri.toString() == '/statistics';
    final double entriesWidth = _getTextWidth(
        context.tr('navigation_entries'), const TextStyle(fontSize: 16));
    bool isHomePage = GoRouterState.of(context).uri.toString() == '/home';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 80,
      child: Stack(
        children: [
          Positioned(
              right: MediaQuery.of(context).size.width / 4 - (statsWidth + 30),
              bottom: 24,
              width: statsWidth + 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LottieIconButton(
                    lottieAsset: 'assets/lottie/analytics_animation.json',
                    iconSize: 30,
                    customAction: () {
                      if (!isStatsPage) {
                        GoRouter.of(context).go('/statistics');
                      }
                    },
                  ),
                  AnimatedContainer(
                    width: isStatsPage ? statsWidth : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        context.tr('navigation_statistics'),
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              )),
          Positioned(
              left: MediaQuery.of(context).size.width / 4 - (entriesWidth + 30),
              bottom: 24,
              width: entriesWidth + 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LottieIconButton(
                    lottieAsset: 'assets/lottie/entries_animation.json',
                    iconSize: 30,
                    customAction: () {
                      if (!isHomePage) {
                        GoRouter.of(context).go('/home');
                      }
                    },
                  ),
                  AnimatedContainer(
                    width: isHomePage ? entriesWidth : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        context.tr('navigation_entries'),
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                      ),
                    ),
                  )
                ],
              )),
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 48,
            bottom: 12,
            child: IconButton(
                onPressed: () async {
                  if (context.mounted) {
                    await context
                        .read<AnimationStateNotifier>()
                        .setAnimate(true);
                  }
                  if (context.mounted) {
                    context.read<EmotionProvider>().resetEmotions();
                    context.read<TagProvider>().resetTags();
                    if (GoRouterState.of(context).uri.toString() != '/entry') {
                      GoRouter.of(context).go('/entry');
                    }
                  }
                },
                icon: const Icon(
                  Icons.add_circle,
                  size: 40,
                )),
          )
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
