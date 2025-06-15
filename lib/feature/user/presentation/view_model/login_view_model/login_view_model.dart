import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/service_locator/service_locator.dart';
import '../register_view_model/register_view_model.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  LoginViewModel() : super(LoginState.initial()) {
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
                child: event.destination,
              ),
        ),
      );
    }
  }

  void _onNavigateToHomeView(
    NavigateToHomeView event,
    Emitter<LoginState> emit,
  ) {
    // Logic to navigate to Home View
    // if (event.context.mounted) {
    //   Navigator.pushReplacement(
    //     event.context,
    //     MaterialPageRoute(
    //       builder: (context) => BlocProvider.value(
    //         value: serviceLocator<HomeViewModel>(),
    //         child: event.destination,
    //       ),
    //     ),
    //   );
    // }
  }

  void _onLoginWithEmailAndPassword(
    LoginWithEmailAndPassword event,
    Emitter<LoginState> emit,
  ) {}
}
