import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/app/app.dart';
import 'package:trailmate_mobile_app_assignment/app/service_locator/service_locator.dart';
import 'package:trailmate_mobile_app_assignment/core/network/local/hive_service.dart';
// Import all your Blocs and ViewModels
import 'package:trailmate_mobile_app_assignment/cubit/bottom_navigation_cubit.dart';
import 'package:trailmate_mobile_app_assignment/feature/checklist/presentation/view_model/checklist_view_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view_model/group_view_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/presentation/view_model/bot_view_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/presentation/view_model/home_view_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/presentation/view_model/step_view_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/trail/presentation/view_model/trail_view_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/auth_view_model/auth_view_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/profile_view_model/profile_view_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/profile_view_model/stats_view_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/register_view_model/register_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  // init Hive service
  await HiveService().init();

  runApp(
    MultiBlocProvider(
      providers: [
        // --- Application-Level Blocs ---
        // Manages authentication state for the whole app
        BlocProvider<LoginViewModel>(
          create: (context) => serviceLocator<LoginViewModel>(),
        ),
        BlocProvider<RegisterViewModel>(
          create: (context) => serviceLocator<RegisterViewModel>(),
        ),
        BlocProvider<AuthBloc>(create: (context) => serviceLocator<AuthBloc>()),
        // Manages the bottom navigation bar state
        BlocProvider<BottomNavigationCubit>(
          create: (context) => serviceLocator<BottomNavigationCubit>(),
        ),

        // --- Feature-Level ViewModels/Blocs ---
        // These are now available to any part of the app that needs them.
        BlocProvider<HomeViewModel>(
          create: (context) => serviceLocator<HomeViewModel>(),
        ),
        BlocProvider<TrailViewModel>(
          create: (context) => serviceLocator<TrailViewModel>(),
        ),
        BlocProvider<ChecklistBloc>(
          create: (context) => serviceLocator<ChecklistBloc>(),
        ),
        BlocProvider<GroupViewModel>(
          create: (context) => serviceLocator<GroupViewModel>(),
        ),
        BlocProvider<ProfileViewModel>(
          create: (context) => serviceLocator<ProfileViewModel>(),
        ),
        BlocProvider<StatsViewModel>(
          create: (context) => serviceLocator<StatsViewModel>(),
        ),
        BlocProvider<StepBloc>(create: (context) => serviceLocator<StepBloc>()),

        BlocProvider<ChatBloc>(create: (context) => serviceLocator<ChatBloc>()),
      ],
      child: App(), // Your main App widget
    ),
  );
}
