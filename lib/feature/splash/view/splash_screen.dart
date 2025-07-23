import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/cubit/bottom_navigation_cubit.dart';
import 'package:trailmate_mobile_app_assignment/feature/splash/view_model/splash_event.dart';
import 'package:trailmate_mobile_app_assignment/feature/splash/view_model/splash_state.dart';
import 'package:trailmate_mobile_app_assignment/feature/splash/view_model/splash_view_model.dart';
import 'package:trailmate_mobile_app_assignment/view/dashboard_view.dart';
import 'package:trailmate_mobile_app_assignment/view/on_boarding_screen.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  @override
  void initState() {
    super.initState();
    // Instead of calling a function, we ADD an event to the BLoC.
    context.read<SplashBloc>().add(CheckAuthenticationStatus());
  }

  @override
  Widget build(BuildContext context) {
    // The BlocListener handles navigation based on state changes.
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          // If authenticated, navigate to the Dashboard.
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder:
                  (_) => BlocProvider(
                    create: (_) => BottomNavigationCubit(),
                    child: const DashboardView(showSnackbar: false),
                  ),
            ),
            (route) => false,
          );
        } else if (state.status == AuthStatus.unauthenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const OnboardingScreen()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image.asset(
            'assets/images/splash_screen.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
