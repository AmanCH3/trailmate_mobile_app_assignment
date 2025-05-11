import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:trailmate_mobile_app_assignment/view/screen_1.dart';

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({super.key});

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

      nextScreen: const Screen1(),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.white,
    );
  }
}