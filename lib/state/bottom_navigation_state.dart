import 'package:flutter/material.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/presentation/view/home_view.dart';
import 'package:trailmate_mobile_app_assignment/view/checklist_view.dart';
import 'package:trailmate_mobile_app_assignment/view/group_view.dart';
import 'package:trailmate_mobile_app_assignment/view/profile_view.dart';
import 'package:trailmate_mobile_app_assignment/view/trail_view.dart';

class BottomNavigationState {
  final int currentIndex;
  final List<Widget> screens;

  BottomNavigationState({required this.currentIndex})
    : screens = [
        HomeView(),
        TrailView(),
        ChecklistView(),
        GroupView(),
        ProfileView(),
      ];

  Widget get currentScreen => screens[currentIndex];
}
