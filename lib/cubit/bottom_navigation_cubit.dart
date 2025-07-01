import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/app/service_locator/service_locator.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view_model/group_view_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/presentation/view/home_view.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/presentation/view_model/home_view_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/presentation/view/trail_list_view.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/presentation/view_model/trail_view_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view/profile_view.dart';
import 'package:trailmate_mobile_app_assignment/state/bottom_navigation_state.dart';
import 'package:trailmate_mobile_app_assignment/view/checklist_view.dart';
import 'package:trailmate_mobile_app_assignment/view/group_view.dart';

class BottomNavigationCubit extends Cubit<BottomNavigationState> {
  // Define the screens and titles once, as final lists inside the cubit.
  final List<Widget> _screens = [
    BlocProvider<HomeViewModel>.value(
      value: serviceLocator<HomeViewModel>(),
      child: HomeView(),
    ),
    BlocProvider<TrailViewModel>.value(
      value: serviceLocator<TrailViewModel>(),
      child: const TrailsListView(),
    ),
    const ChecklistView(),
    BlocProvider<GroupViewModel>.value(
      value: serviceLocator<GroupViewModel>(),
      child: const GroupView(),
    ),
    const GroupView(),
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
        // Initialize with the state for the first tab (index 0)
        BottomNavigationState(
          currentIndex: 0,
          currentScreen:
              [
                BlocProvider<HomeViewModel>.value(
                  value: serviceLocator<HomeViewModel>(),
                  child: HomeView(),
                ),
                BlocProvider<TrailViewModel>.value(
                  value: serviceLocator<TrailViewModel>(),
                  child: const TrailsListView(),
                ),
                const ChecklistView(),
                BlocProvider<GroupViewModel>.value(
                  value: serviceLocator<GroupViewModel>(),
                  child: GroupView(),
                ),
                const ProfileView(),
              ][0],
          appBarTitle:
              const ['Home', 'Trails', 'Checklist', 'Groups', 'Profile'][0],
        ),
      );

  void updateIndex(int index) {
    if (index >= 0 && index < _screens.length) {
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
