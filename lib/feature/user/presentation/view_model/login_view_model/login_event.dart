// feature/user/presentation/view_model/login_view_model/login_event.dart

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
sealed class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object?> get props => [];
}

// Event for navigating to the register screen
class NavigateToRegisterView extends LoginEvent {
  final BuildContext context;
  const NavigateToRegisterView({required this.context});
}

// Event for navigating to the home screen (internal to the BLoC)
class NavigateToHomeView extends LoginEvent {
  final BuildContext context;
  const NavigateToHomeView({required this.context});
}

// Event for submitting the login form
class LoginWithEmailAndPassword extends LoginEvent {
  final BuildContext context;
  final String email;
  final String password;

  const LoginWithEmailAndPassword({
    required this.context,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [context, email, password];
}

// Event to toggle the password's visibility
class TogglePasswordVisibility extends LoginEvent {}

// Event to update the "Remember Me" checkbox status
class ToggleRememberMe extends LoginEvent {
  final bool value;
  const ToggleRememberMe({required this.value});

  @override
  List<Object> get props => [value];
}
