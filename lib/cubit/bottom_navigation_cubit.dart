import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/app/service_locator/service_locator.dart';
import 'package:trailmate_mobile_app_assignment/feature/checklist/presentation/view/checklist_view.dart';
import 'package:trailmate_mobile_app_assignment/feature/checklist/presentation/view_model/checklist_view_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view/group_home_page.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view_model/group_view_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/presentation/view/home_view.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/presentation/view_model/home_view_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/presentation/view/trail_list_view.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/presentation/view_model/trail_view_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view/profile_view.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/profile_view_model/profile_view_model.dart';
import 'package:trailmate_mobile_app_assignment/state/bottom_navigation_state.dart';

import '../feature/grouplist/presentation/view_model/group_event.dart';

class BottomNavigationCubit extends Cubit<BottomNavigationState> {
  static final Widget _homeScreen = MultiBlocProvider(
    providers: [
      BlocProvider.value(value: serviceLocator<HomeViewModel>()),
      BlocProvider.value(value: serviceLocator<TrailViewModel>()),
    ],
    child: HomeView(),
  );

  final List<Widget> _screens = [
    _homeScreen,
    BlocProvider<TrailViewModel>.value(
      value: serviceLocator<TrailViewModel>(),
      child: const TrailsListView(),
    ),
    BlocProvider<ChecklistBloc>.value(
      value: serviceLocator<ChecklistBloc>(),
      child: const ChecklistBody(),
    ),
    MultiBlocProvider(
      providers: [
        BlocProvider<GroupViewModel>.value(
          value: serviceLocator<GroupViewModel>(),
        ),
        BlocProvider<ProfileViewModel>.value(
          value: serviceLocator<ProfileViewModel>(),
        ),
      ],
      child: const GroupHomePage(),
    ),
    BlocProvider<ProfileViewModel>.value(
      value: serviceLocator<ProfileViewModel>(),
      child: const ProfileView(),
    ),
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
          currentScreen: _homeScreen,
          appBarTitle: 'Home',
        ),
      );

  void updateIndex(int index) {
    if (index >= 0 && index < _screens.length) {
      if (index == 3) {
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
