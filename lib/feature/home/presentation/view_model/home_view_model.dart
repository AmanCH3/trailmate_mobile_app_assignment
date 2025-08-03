import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/core/common/my_snackbar.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/usecase/user_logout_usecase.dart';

import '../../../user/presentation/view/login_view.dart';
import '../../../user/presentation/view_model/login_view_model/login_view_model.dart';
import 'home_state.dart';

class HomeViewModel extends Cubit<HomeState> {
  final UserLogoutUseCase _userLogoutUseCase;
  HomeViewModel({
    required this.loginViewModel,
    required UserLogoutUseCase userLogoutUseCase,
  }) : _userLogoutUseCase = userLogoutUseCase,
       super(HomeState.initial());

  final LoginViewModel loginViewModel;

  void onTabTapped(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  Future<void> logout(BuildContext context) async {
    final result = await _userLogoutUseCase();

    result.fold(
      (failure) {
        showMySnackBar(
          context: context,
          message: 'Logout failed. Please try again.',
          color: Colors.red,
        );
      },
      (success) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
          (Route<dynamic> route) => false,
        );
      },
    );
  }
}
