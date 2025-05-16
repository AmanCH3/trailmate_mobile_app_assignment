import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:trailmate_mobile_app_assignment/view/on_boarding_screen.dart';
import 'package:trailmate_mobile_app_assignment/view/screen_1.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  late AnimationController _controller;

  late Animation<double> _opacityAnimation;

  late Animation<double> _progressAnimation;

  double _progressValue = 0.0;

  //Define theme colors

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      // Shorter duration (2 seconds is enough)
      duration: 2000,

      // Simple splash content with error handling
      splash: Image.asset(
        'assets/images/splash_screen.png',
        fit: BoxFit.contain,
      ),

      nextScreen: const OnboardingScreen(),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.white,
    );
  }
}
