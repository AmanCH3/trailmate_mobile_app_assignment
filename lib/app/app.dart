import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/app/service_locator/service_locator.dart';
import 'package:trailmate_mobile_app_assignment/app/theme/theme_data.dart';
import 'package:trailmate_mobile_app_assignment/feature/splash/view/splash_screen.dart';
import 'package:trailmate_mobile_app_assignment/feature/splash/view_model/splash_view_model.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Trail Mate",
      theme: getApplicationTheme(),
      home: BlocProvider.value(
        value: serviceLocator<SplashViewModel>(),
        child: SplashScreenView(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
