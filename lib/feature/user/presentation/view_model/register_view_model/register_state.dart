import 'package:equatable/equatable.dart';

class RegisterState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final bool? isPasswordVisible;
  final String? error;

  const RegisterState({
    required this.isLoading,
    required this.isSuccess,
    this.isPasswordVisible,
    this.error,
  });

  const RegisterState.initial()
    : isLoading = false,
      isSuccess = false,
      isPasswordVisible = false,
      error = '';

  RegisterState copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? isPasswordVisible,
    String? error,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isSuccess, isLoading, isPasswordVisible, error];
}
