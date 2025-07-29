import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/presentation/view_model/home_state.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/presentation/view_model/home_view_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/usecase/user_logout_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/login_view_model/login_view_model.dart';

class MockUserLogoutUseCase extends Mock implements UserLogoutUseCase {}

class MockLoginViewModel extends Mock implements LoginViewModel {}

class MockBuildContext extends Mock implements BuildContext {}

class MockFailure extends Mock implements Failure {}

void main() {
  late HomeViewModel homeViewModel;
  late MockUserLogoutUseCase mockUserLogoutUseCase;
  late MockLoginViewModel mockLoginViewModel;

  setUp(() {
    mockUserLogoutUseCase = MockUserLogoutUseCase();
    mockLoginViewModel = MockLoginViewModel();
    homeViewModel = HomeViewModel(
      loginViewModel: mockLoginViewModel,
      userLogoutUseCase: mockUserLogoutUseCase,
    );
  });

  tearDown(() {
    homeViewModel.close();
  });

  group('HomeViewModel', () {
    test('initial state is correct', () {
      expect(homeViewModel.state, HomeState.initial());
      expect(homeViewModel.state.selectedIndex, 0);
    });

    blocTest<HomeViewModel, HomeState>(
      'emits state with updated selectedIndex when onTabTapped is called',
      build: () => homeViewModel,
      act: (cubit) => cubit.onTabTapped(2),
      expect: () => [HomeState(selectedIndex: 2)],
    );

    group('logout (Success)', () {
      test(
        'calls UserLogoutUseCase and triggers navigation on success',
        () async {
          when(
            () => mockUserLogoutUseCase.call(),
          ).thenAnswer((_) async => const Right(null));

          final mockContext = MockBuildContext();
          when(() => mockContext.mounted).thenReturn(true);

          // ACT: Call the logout method.
          await homeViewModel.logout(mockContext);
          verify(() => mockUserLogoutUseCase.call()).called(1);
        },
      );
    });

    group('logout (Failure)', () {
      test(
        'calls UserLogoutUseCase and handles failure without changing state',
        () async {
          final tFailure = MockFailure();
          when(
            () => mockUserLogoutUseCase.call(),
          ).thenAnswer((_) async => Left(tFailure));

          final mockContext = MockBuildContext();
          when(() => mockContext.mounted).thenReturn(true);

          await homeViewModel.logout(mockContext);

          verify(() => mockUserLogoutUseCase.call()).called(1);
        },
      );
    });
  });
}
