import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailmate_mobile_app_assignment/state/bottom_navigation_state.dart';

class BottomNavigationCubit extends Cubit<BottomNavigationState> {
  BottomNavigationCubit() : super(BottomNavigationState(currentIndex: 0));

  void updateIndex(int index) {
    emit(BottomNavigationState(currentIndex: index));
  }
}
