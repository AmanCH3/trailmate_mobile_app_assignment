import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/cubit/bottom_navigation_cubit.dart';
import 'package:trailmate_mobile_app_assignment/feature/splash/view_model/splash_event.dart';
import 'package:trailmate_mobile_app_assignment/feature/splash/view_model/splash_state.dart';
import 'package:trailmate_mobile_app_assignment/feature/splash/view_model/splash_view_model.dart';
import 'package:trailmate_mobile_app_assignment/view/dashboard_view.dart';
import 'package:trailmate_mobile_app_assignment/view/on_boarding_screen.dart';

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    // Dispatch the event to check authentication status when the widget is built.
    context.read<SplashBloc>().add(CheckAuthenticationStatus());

    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
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
            // Set a specific width to decrease the image size
            width: 100,
            height: 80,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
