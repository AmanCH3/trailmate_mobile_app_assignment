import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/usecase/user_login_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/login_view_model/login_event.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/login_view_model/login_state.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:trailmate_mobile_app_assignment/view/dashboard_view.dart';

// --- Mocks ---
class MockUserLoginUseCase extends Mock implements UserLoginUseCase {}

class MockBuildContext extends Mock implements BuildContext {}

class MockFailure extends Mock implements Failure {
  @override
  final String message;
  MockFailure([this.message = 'An error occurred']);
}

void main() {
  late LoginViewModel loginViewModel;
  late MockUserLoginUseCase mockUserLoginUseCase;
  late MockBuildContext mockContext;

  setUpAll(() {
    // Register fallback values for complex types used in mocks
    registerFallbackValue(const LoginParams(email: '', password: ''));
  });

  setUp(() {
    mockUserLoginUseCase = MockUserLoginUseCase();
    mockContext = MockBuildContext();
    loginViewModel = LoginViewModel(mockUserLoginUseCase);
  });

  tearDown(() {
    loginViewModel.close();
  });

  group('LoginViewModel', () {
    test('initial state is correct', () {
      expect(loginViewModel.state, LoginState.initial());
    });

    // Test for a simple, synchronous state change
    blocTest<LoginViewModel, LoginState>(
      'emits state with isPasswordVisible toggled when ShowHidePassword is added',
      build: () => loginViewModel,
      act:
          (bloc) => bloc.add(
            ShowHidePassword(
              context:
                  mockContext, // Context isn't used in this handler, so mock is fine
              isVisible: false,
            ),
          ),
      expect:
          () => [
            // Using a Matcher is safer when state is not fully controlled
            isA<LoginState>().having(
              (s) => s.isPasswordVisible,
              'isPasswordVisible',
              false,
            ),
          ],
    );
  });
}
