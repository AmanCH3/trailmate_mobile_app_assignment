import 'package:flutter/material.dart';
import 'package:trailmate_mobile_app_assignment/view/splash_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Splash Screen",
      theme: ThemeData(primarySwatch: Colors.green),
      home: SplashScreenView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
