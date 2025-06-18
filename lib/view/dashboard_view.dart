import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/core/common/my_snackbar.dart';
import 'package:trailmate_mobile_app_assignment/cubit/bottom_navigation_cubit.dart';

import '../feature/home/presentation/view_model/home_view_model.dart';
import '../state/bottom_navigation_state.dart';

class DashboardView extends StatelessWidget {
  final bool showSnackbar;

  const DashboardView({Key? key, this.showSnackbar = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (showSnackbar) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showMySnackBar(context: context, message: "Login Successful !");
      });
    }

    return BlocBuilder<BottomNavigationCubit, BottomNavigationState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Dashboard"),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  // Logout code
                  showMySnackBar(
                    context: context,
                    message: 'Logging out...',
                    color: Colors.red,
                  );

                  context.read<HomeViewModel>().logout(context);
                },
              ),
            ],
          ),
          body: state.currentScreen,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.currentIndex,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.grey,
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
              BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Groups'),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
