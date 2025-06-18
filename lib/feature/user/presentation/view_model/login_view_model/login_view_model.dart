import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/core/common/my_snackbar.dart';
import 'package:trailmate_mobile_app_assignment/cubit/bottom_navigation_cubit.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/usecase/user_login_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view/signup_view.dart';
import 'package:trailmate_mobile_app_assignment/view/dashboard_view.dart';

import '../../../../../app/service_locator/service_locator.dart';
import '../register_view_model/register_view_model.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUseCase _userLoginUseCase;

  LoginViewModel(this._userLoginUseCase) : super(LoginState.initial()) {
    on<NavigateToRegisterView>(_onNavigateToRegisterView);
    on<NavigateToHomeView>(_onNavigateToHomeView);
    on<LoginWithEmailAndPassword>(_onLoginWithEmailAndPassword);
  }

  void _onNavigateToRegisterView(
    NavigateToRegisterView event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder:
              (_) => BlocProvider.value(
                value: serviceLocator<RegisterViewModel>(),
                child: const SignupView(),
              ),
        ),
      );
    }
  }

  void _onNavigateToHomeView(
    NavigateToHomeView event,
    Emitter<LoginState> emit,
  ) async {
    Navigator.pushAndRemoveUntil(
      event.context,
      MaterialPageRoute(
        builder:
            (_) => BlocProvider(
              create: (_) => BottomNavigationCubit(),
              child: DashboardView(showSnackbar: true),
            ),
      ),
      (route) => false,
    );
  }

  void _onLoginWithEmailAndPassword(
    LoginWithEmailAndPassword event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _userLoginUseCase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) {
        // Handle failure case
        emit(state.copyWith(isLoading: false, isSuccess: false));

        showMySnackBar(
          context: event.context,
          message: 'Invalid credentials. Please try again.',
          color: Colors.red,
        );
      },
      (email) {
        // Handle success case
        emit(state.copyWith(isLoading: false, isSuccess: true));
        add(NavigateToHomeView(context: event.context));
      },
    );
  }
}
