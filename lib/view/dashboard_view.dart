// FILE: lib/feature/dashboard/presentation/view/dashboard_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/app/service_locator/service_locator.dart';
import 'package:trailmate_mobile_app_assignment/core/common/my_snackbar.dart';
import 'package:trailmate_mobile_app_assignment/core/common/shake_dectector.dart';
import 'package:trailmate_mobile_app_assignment/cubit/bottom_navigation_cubit.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/presentation/view_model/home_view_model.dart';
import 'package:trailmate_mobile_app_assignment/state/bottom_navigation_state.dart';
import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/presentation/view_model/step_view_model.dart';

class DashboardView extends StatefulWidget {
  final bool showSnackbar;

  const DashboardView({Key? key, this.showSnackbar = false}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  late ShakeDetector _shakeDetector;

  @override
  void initState() {
    super.initState();

    // Initialize ShakeDetector and pass the confirmation dialog function
    _shakeDetector = ShakeDetector(
      onPhoneShake: () {
        // Use our new confirmation dialog function
        _showLogoutConfirmationDialog(
          context,
          'Shake detected! Do you want to log out?',
        );
      },
    );
    _shakeDetector.startListening();

    // Handle the initial "Login Successful" snackbar
    if (widget.showSnackbar) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showMySnackBar(context: context, message: "Login Successful !");
        }
      });
    }
  }

  // --- 1. CREATE THE REUSABLE DIALOG FUNCTION ---
  Future<void> _showLogoutConfirmationDialog(
    BuildContext buildContext,
    String title,
  ) async {
    // Show the dialog
    return showDialog<void>(
      context: buildContext,
      barrierDismissible: false, // User must tap a button
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text('This action cannot be undone.')],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                // Close the dialog
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
              onPressed: () {
                // Close the dialog first
                Navigator.of(dialogContext).pop();
                // Then, show snackbar and perform logout
                showMySnackBar(
                  context: buildContext, // Use the original buildContext
                  message: 'Logging out...',
                  color: Colors.red,
                );
                // Trigger the logout from the ViewModel
                buildContext.read<HomeViewModel>().logout(buildContext);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _shakeDetector.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StepBloc>.value(
      value: serviceLocator<StepBloc>(),
      child: BlocBuilder<BottomNavigationCubit, BottomNavigationState>(
        builder: (context, state) {
          return Scaffold(
            appBar:
                state.currentIndex != 4
                    ? AppBar(
                      title: Text(state.appBarTitle),
                      actions: [
                        // ... your other actions
                        // --- 2. UPDATE THE LOGOUT BUTTON'S onPressed ---
                        IconButton(
                          icon: const Icon(Icons.logout),
                          onPressed: () {
                            // Call the new confirmation dialog function
                            _showLogoutConfirmationDialog(
                              context,
                              'Are you sure you want to log out?',
                            );
                          },
                        ),
                      ],
                    )
                    : null,
            body: state.currentScreen,
            bottomNavigationBar: BottomNavigationBar(
              // ... your bottom navigation bar properties
              currentIndex: state.currentIndex,
              selectedItemColor: Colors.green,
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                context.read<BottomNavigationCubit>().updateIndex(index);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Trails'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.checklist),
                  label: 'Checklist',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.group),
                  label: 'Groups',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
