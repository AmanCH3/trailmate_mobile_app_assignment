import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/feature/splash/view_model/splash_event.dart';
import 'package:trailmate_mobile_app_assignment/feature/splash/view_model/splash_state.dart';

import 'package:trailmate_mobile_app_assignment/feature/user/domain/usecase/check_auth_status_usecase.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;

  SplashBloc(this._checkAuthStatusUseCase) : super(SplashState.initial()) {
    // Register the event handler for when the UI dispatches the event.
    on<CheckAuthenticationStatus>(_onCheckAuthenticationStatus);
  }

  Future<void> _onCheckAuthenticationStatus(
    CheckAuthenticationStatus event,
    Emitter<SplashState> emit,
  ) async {
    await Future.delayed(const Duration(seconds: 2));

    final result = await _checkAuthStatusUseCase();

    result.fold(
      (failure) {
        emit(state.copyWith(status: AuthStatus.unauthenticated));
      },
      (token) {
        if (token != null && token.isNotEmpty) {
          emit(state.copyWith(status: AuthStatus.authenticated));
        } else {
          emit(state.copyWith(status: AuthStatus.unauthenticated));
        }
      },
    );
  }
}
