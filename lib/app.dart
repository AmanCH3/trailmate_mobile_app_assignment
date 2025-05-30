import 'package:flutter/material.dart';
import 'package:trailmate_mobile_app_assignment/theme/theme_data.dart';
import 'package:trailmate_mobile_app_assignment/view/dashboard_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Splash Screen",
      theme: getApplicationTheme(),
      home: DashboardView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
