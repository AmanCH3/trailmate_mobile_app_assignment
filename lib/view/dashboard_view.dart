import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/app/service_locator/service_locator.dart';
import 'package:trailmate_mobile_app_assignment/core/common/my_snackbar.dart';
import 'package:trailmate_mobile_app_assignment/core/common/shake_dectector.dart';
import 'package:trailmate_mobile_app_assignment/cubit/bottom_navigation_cubit.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/presentation/view/bot_view.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/presentation/view_model/bot_view_model.dart';
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

  // No changes needed in initState, _showLogoutConfirmationDialog, or dispose
  @override
  void initState() {
    super.initState();
    _shakeDetector = ShakeDetector(
      onPhoneShake: () {
        _showLogoutConfirmationDialog(
          context,
          'Shake detected! Do you want to log out?',
        );
      },
    );
    // Note: The logic for starting/stopping the shake detector is now in build()
    if (widget.showSnackbar) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showMySnackBar(context: context, message: "Login Successful !");
        }
      });
    }
  }

  Future<void> _showLogoutConfirmationDialog(
    BuildContext buildContext,
    String title,
  ) async {
    return showDialog<void>(
      context: buildContext,
      barrierDismissible: false,
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
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                showMySnackBar(
                  context: buildContext,
                  message: 'Logging out...',
                  color: Colors.red,
                );
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
          if (state.currentIndex == 4) {
            // Profile Tab
            _shakeDetector.startListening();
          } else {
            _shakeDetector.stopListening();
          }

          return Scaffold(
            appBar:
                state.currentIndex != 4
                    ? AppBar(
                      title: Text(state.appBarTitle),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.logout),
                          onPressed: () {
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

            // 2. ADD THE FLOATING ACTION BUTTON
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => BlocProvider(
                          create: (context) => serviceLocator<ChatBloc>(),
                          child: const BotView(),
                        ),
                  ),
                );
              },
              backgroundColor: Colors.green.shade800,
              shape: const CircleBorder(),
              child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,

            // 3. WRAP BOTTOMNAVIGATIONBAR WITH BOTTOMAPPBAR FOR A CLEAN LOOK
            bottomNavigationBar: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 8.0,
              child: BottomNavigationBar(
                currentIndex: state.currentIndex,
                selectedItemColor: Colors.green,
                unselectedItemColor: Colors.grey,
                type: BottomNavigationBarType.fixed,
                onTap: (index) {
                  context.read<BottomNavigationCubit>().updateIndex(index);
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.map),
                    label: 'Trails',
                  ),
                  // This is a placeholder for the FAB notch
                  BottomNavigationBarItem(
                    label: 'Chat',
                    icon: SizedBox.shrink(),
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
            ),
          );
        },
      ),
    );
  }
}
