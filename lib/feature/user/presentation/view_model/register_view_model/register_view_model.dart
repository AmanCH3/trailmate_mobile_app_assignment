import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/app/service_locator/service_locator.dart';
import 'package:trailmate_mobile_app_assignment/core/common/app_flush.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/usecase/user_register_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view/login_view.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/register_view_model/register_event.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/register_view_model/register_state.dart';

class RegisterViewModel extends Bloc<RegisterEvent, RegisterState> {
  final UserRegisterUseCase _userRegisterUseCase;

  RegisterViewModel(this._userRegisterUseCase)
    : super(RegisterState.initial()) {
    on<RegisterUserEvent>(_onRegisterUser);
    on<NavigateToLoginEvent>(_onNavigateToLoginEvent);
  }

  Future<void> _onRegisterUser(
    RegisterUserEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    await Future.delayed(const Duration(seconds: 1));

    final result = await _userRegisterUseCase(
      RegisterUserParams(
        email: event.email,
        name: event.name,
        password: event.password,
        phone: event.phone,
      ),
    );

    result.fold(
      (r) async {
        emit(state.copyWith(isLoading: false));

        if (event.context.mounted) {
          await AppFlushbar.show(
            context: event.context,
            message: "Something went wrong!",
            icon: const Icon(Icons.error, color: Colors.white),
            backgroundColor: Colors.red, // Change this line
          );
        }
      },
      (l) async {
        emit(state.copyWith(isLoading: false, isSuccess: true));

        if (event.context.mounted) {
          Navigator.push(
            event.context,
            MaterialPageRoute(
              builder:
                  (context) => BlocProvider.value(
                    value: serviceLocator<LoginViewModel>(),
                    child: LoginView(),
                  ),
            ),
          );
          await AppFlushbar.show(
            context: event.context,
            message: "Signup successful!",
            icon: const Icon(Icons.check_circle, color: Colors.white),
            backgroundColor: Colors.cyan,
          );
        }
      },
    );
  }

  void _onNavigateToLoginEvent(
    NavigateToLoginEvent event,
    Emitter<RegisterState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder:
              (context) => BlocProvider.value(
                value: serviceLocator<LoginViewModel>(),
                child: LoginView(),
              ),
        ),
      );
    }
  }
}
