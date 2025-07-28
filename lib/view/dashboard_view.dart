// lib/feature/dashboard/presentation/view/dashboard_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/app/service_locator/service_locator.dart';
import 'package:trailmate_mobile_app_assignment/core/common/my_snackbar.dart';
import 'package:trailmate_mobile_app_assignment/core/common/shake_dectector.dart';
import 'package:trailmate_mobile_app_assignment/cubit/bottom_navigation_cubit.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/presentation/view_model/home_view_model.dart';
import 'package:trailmate_mobile_app_assignment/state/bottom_navigation_state.dart';
import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/presentation/view_model/step_view_model.dart';

// 1. Convert to StatefulWidget
class DashboardView extends StatefulWidget {
  final bool showSnackbar;

  const DashboardView({Key? key, this.showSnackbar = false}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  // 2. Declare the ShakeDetector
  late ShakeDetector _shakeDetector;

  @override
  void initState() {
    super.initState();

    // 3. Initialize and start the ShakeDetector
    _shakeDetector = ShakeDetector(
      onPhoneShake: () {
        // Ensure the widget is still mounted before interacting with context
        if (mounted) {
          showMySnackBar(
            context: context,
            message: 'Shake detected! Logging out...',
            color: Colors.red,
          );
          // Trigger the logout action from the ViewModel
          context.read<HomeViewModel>().logout(context);
        }
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

  @override
  void dispose() {
    // 4. Stop the detector to prevent memory leaks
    _shakeDetector.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The original build logic is now here
    return BlocProvider<StepBloc>.value(
      value: serviceLocator<StepBloc>(),
      child: BlocBuilder<BottomNavigationCubit, BottomNavigationState>(
        builder: (context, state) {
          return Scaffold(
            appBar:
                state.currentIndex !=
                        4 // Only show AppBar when not on Profile tab
                    ? AppBar(
                      title: Text(state.appBarTitle),
                      actions: [
                        if (state.currentIndex == 3)
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            tooltip: 'Create Group',
                            onPressed: () {
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder:
                              //         (_) => BlocProvider.value(
                              //           value: BlocProvider.of<GroupViewModel>(context),
                              //           child: const CreateGroupPage(),
                              //         ),
                              //   ),
                              // );
                            },
                          ),
                        IconButton(
                          icon: const Icon(Icons.logout),
                          onPressed: () {
                            showMySnackBar(
                              context: context,
                              message: 'Logging out...',
                              color: Colors.red,
                            );
                            context.read<HomeViewModel>().logout(context);
                          },
                        ),
                      ],
                    )
                    : null, // No AppBar for Profile tab
            body: state.currentScreen,
            bottomNavigationBar: BottomNavigationBar(
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
