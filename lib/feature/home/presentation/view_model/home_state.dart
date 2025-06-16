import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/presentation/view/home_view.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/presentation/view_model/home_view_model.dart';

import '../../../../app/service_locator/service_locator.dart';
import '../../../../view/dashboard_view.dart';

class HomeState {
  final int selectedIndex;
  final List<Widget> views;

  const HomeState({required this.selectedIndex, required this.views});

  // Initial state
  static HomeState initial() {
    return HomeState(
      selectedIndex: 0,
      views: [
        DashboardView(),
        BlocProvider.value(
          value: serviceLocator<HomeViewModel>(),
          child: HomeView(),
        ),
        //   BlocProvider.value(
        //     value: serviceLocator<BatchViewModel>(),
        //     child: BatchView(),
        //   ),
        //   AccountView(),
      ],
    );
  }

  HomeState copyWith({int? selectedIndex, List<Widget>? views}) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      views: views ?? this.views,
    );
  }
}
