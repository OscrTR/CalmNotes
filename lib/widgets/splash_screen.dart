import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:calm_notes/colors.dart';
import 'package:calm_notes/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen(
      backgroundColor: CustomColors.backgroundColor,
      splashScreenBody: Center(
        child: Lottie.asset(
          "assets/lottie/splash_screen.json",
          repeat: false,
        ),
      ),
      asyncNavigationCallback: () async {
        await Future.delayed(const Duration(seconds: 3));
        if (context.mounted) {
          GoRouter.of(context).go("/home");
        }
      },
    );
  }
}
