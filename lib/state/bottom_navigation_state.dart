import 'package:flutter/cupertino.dart';
import 'package:trailmate_mobile_app_assignment/view/checklist_view.dart';
import 'package:trailmate_mobile_app_assignment/view/dashboard_view.dart';
import 'package:trailmate_mobile_app_assignment/view/group_view.dart';
import 'package:trailmate_mobile_app_assignment/view/profile_view.dart';
import 'package:trailmate_mobile_app_assignment/view/trail_view.dart';

class BottomNavigationState {
  final List<Widget> _screens = [
    DashboardView(),
    TrailView(),
    ChecklistView(),
    GroupView(),
    ProfileView(),
  ];
}
