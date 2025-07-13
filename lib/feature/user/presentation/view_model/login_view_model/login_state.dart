// feature/user/presentation/view_model/login_view_model/login_state.dart

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class LoginState extends Equatable {
  final bool isLoading;
  final bool? isSuccess;
  final bool obscurePassword;
  final bool rememberMe;

  const LoginState({
    required this.isLoading,
    this.isSuccess,
    required this.obscurePassword,
    required this.rememberMe,
  });

  factory LoginState.initial() {
    return const LoginState(
      isLoading: false,
      isSuccess: null,
      obscurePassword: true,
      rememberMe: false,
    );
  }

  LoginState copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? obscurePassword,
    bool? rememberMe,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isSuccess,
    obscurePassword,
    rememberMe,
  ];
}
