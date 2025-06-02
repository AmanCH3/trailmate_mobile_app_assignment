import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/cubit/bottom_navigation_cubit.dart';
import 'package:trailmate_mobile_app_assignment/theme/theme_data.dart';
import 'package:trailmate_mobile_app_assignment/view/dashboard_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Splash Screen",
      theme: getApplicationTheme(),
      home: BlocProvider(
        create: (context) => BottomNavigationCubit(),
        child: DashboardView(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
