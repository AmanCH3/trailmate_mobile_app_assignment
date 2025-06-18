import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../user/presentation/view_model/login_view_model/login_view_model.dart';
import 'home_state.dart';

class HomeViewModel extends Cubit<HomeState> {
  HomeViewModel({required this.loginViewModel}) : super(HomeState.initial());

  final LoginViewModel? loginViewModel;

  void onTabTapped(int index) {
    emit(state.copyWith(selectedIndex: index));
  }
}
