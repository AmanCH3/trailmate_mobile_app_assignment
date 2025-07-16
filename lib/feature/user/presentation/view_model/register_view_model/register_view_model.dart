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
    on<ShowHidePassword>(_onShowHidePassword);
  }

  Future<void> _onRegisterUser(
    RegisterUserEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _userRegisterUseCase(
      RegisterUserParams(
        email: event.email,
        name: event.name,
        password: event.password,
        phone: event.phone,
      ),
    );

    // CORRECTED: fold((Failure), (Success))
    result.fold(
      // Failure Case
      (failure) async {
        emit(state.copyWith(isLoading: false));
        if (event.context.mounted) {
          await AppFlushbar.show(
            message: 'Failed to register',
            context: event.context,
            icon: const Icon(Icons.error, color: Colors.white),
            backgroundColor: Colors.red,
          );
        }
      },
      // Success Case
      (success) async {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        if (event.context.mounted) {
          // Navigate first, then show snackbar on the new screen
          Navigator.pushReplacement(
            // Use pushReplacement to prevent going back
            event.context,
            MaterialPageRoute(
              builder:
                  (context) => BlocProvider.value(
                    value: serviceLocator<LoginViewModel>(),
                    child: const LoginView(
                      // Pass a flag to show a success message on the login pag
                    ),
                  ),
            ),
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
                child: const LoginView(),
              ),
        ),
      );
    }
  }

  void _onShowHidePassword(
    ShowHidePassword event,
    Emitter<RegisterState> emit,
  ) {
    // This correctly toggles the state property
    emit(state.copyWith(isPasswordVisible: event.isVisible));
  }
}
