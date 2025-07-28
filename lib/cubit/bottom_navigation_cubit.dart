import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/app/service_locator/service_locator.dart';
// --- CHANGE ---: Remove unused imports for ViewModels, as they are no longer provided here.
import 'package:trailmate_mobile_app_assignment/feature/checklist/presentation/view/checklist_view.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view/group_home_page.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view_model/group_view_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/presentation/view/home_view.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/presentation/view/trail_list_view.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view/profile_view.dart';
import 'package:trailmate_mobile_app_assignment/state/bottom_navigation_state.dart';

import '../feature/grouplist/presentation/view_model/group_event.dart';

class BottomNavigationCubit extends Cubit<BottomNavigationState> {
  final List<Widget> _screens = [
    HomeView(),
    const TrailsListView(),
    const ChecklistBody(),
    const GroupHomePage(),
    const ProfileView(),
  ];

  final List<String> _appBarTitles = [
    'Home',
    'Trails',
    'Checklist',
    'Groups',
    'Profile',
  ];

  BottomNavigationCubit()
    : super(
        BottomNavigationState(
          currentIndex: 0,
          // --- CHANGE ---: Use the plain widget directly for the initial screen.
          currentScreen: HomeView(),
          appBarTitle: 'Home',
        ),
      );

  void updateIndex(int index) {
    if (index >= 0 && index < _screens.length) {
      if (index == 3) {
        // This is fine. It uses the globally available serviceLocator to get the ViewModel.
        serviceLocator<GroupViewModel>().add(FetchAllGroupsEvent());
      }
      emit(
        BottomNavigationState(
          currentIndex: index,
          currentScreen: _screens[index],
          appBarTitle: _appBarTitles[index],
        ),
      );
    }
  }
}
