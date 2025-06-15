import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/core/common/my_snackbar.dart';
import 'package:trailmate_mobile_app_assignment/cubit/bottom_navigation_cubit.dart';

import '../state/bottom_navigation_state.dart';

class DashboardView extends StatelessWidget {
  final bool showSnackbar;

  const DashboardView({Key? key, this.showSnackbar = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (showSnackbar) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // showMySnackbar(context: context, message : "Login Successful!");
        showMySnackBar(context: context, message: "Login Successful !");
      });
    }

    return BlocBuilder<BottomNavigationCubit, BottomNavigationState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text("Dashboard")),
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
