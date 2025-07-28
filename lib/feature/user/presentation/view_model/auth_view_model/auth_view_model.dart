import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/usecase/user_logout_usecase.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserLogoutUseCase _logoutUseCase;

  AuthBloc({required UserLogoutUseCase logoutUseCase})
    : _logoutUseCase = logoutUseCase,
      super(AuthInitial()) {
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _logoutUseCase();
    result.fold(
      (failure) {
        emit(AuthError(failure.message));
      },
      (success) {
        emit(Unauthenticated());
      },
    );
  }
}
