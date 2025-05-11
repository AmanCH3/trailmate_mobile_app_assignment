import 'package:flutter/material.dart';
import 'package:trailmate_mobile_app_assignment/view/login_view.dart';
import 'package:trailmate_mobile_app_assignment/view/screen_1.dart';
import 'package:trailmate_mobile_app_assignment/view/signup_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Screen1(), debugShowCheckedModeBanner: false);
  }
}
