import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/presentation/view/home_view.dart';
import 'package:trailmate_mobile_app_assignment/view/checklist_view.dart';
import 'package:trailmate_mobile_app_assignment/view/group_view.dart';
import 'package:trailmate_mobile_app_assignment/view/profile_view.dart';
import 'package:trailmate_mobile_app_assignment/view/trail_view.dart';

import '../app/service_locator/service_locator.dart'; // Ensure this is imported
import '../feature/home/presentation/view_model/home_view_model.dart';

class BottomNavigationState {
  final int currentIndex;
  final List<Widget> screens;

  BottomNavigationState({required this.currentIndex})
    : screens = [
        BlocProvider<HomeViewModel>.value(
          value: serviceLocator<HomeViewModel>(),
          child: HomeView(),
        ),
        TrailView(),
        ChecklistView(),
        GroupView(),
        ProfileView(),
      ];

  Widget get currentScreen => screens[currentIndex];
}
