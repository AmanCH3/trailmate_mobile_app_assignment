import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/usecase/user_register_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view/login_view.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/login_view_model/login_state.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/register_view_model/register_event.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/register_view_model/register_state.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/register_view_model/register_view_model.dart';

// --- Mocks ---
class MockUserRegisterUseCase extends Mock implements UserRegisterUseCase {}

class MockLoginViewModel extends Mock implements LoginViewModel {}

class MockLoginState extends Mock implements LoginState {}

class MockBuildContext extends Mock implements BuildContext {}

class MockFailure extends Mock implements Failure {
  @override
  final String message;
  MockFailure([this.message = 'An error occurred']);
}

void main() {
  late RegisterViewModel registerViewModel;
  late MockUserRegisterUseCase mockUserRegisterUseCase;

  // Test data
  const tName = 'Test User';
  const tEmail = 'test@example.com';
  const tPhone = '1234567890';
  const tPassword = 'password123';
  final tParams = RegisterUserParams(
    name: tName,
    email: tEmail,
    phone: tPhone,
    password: tPassword,
  );

  setUpAll(() {
    // Register fallback for the custom params object
    registerFallbackValue(tParams);
  });

  setUp(() {
    mockUserRegisterUseCase = MockUserRegisterUseCase();
    registerViewModel = RegisterViewModel(mockUserRegisterUseCase);
  });

  tearDown(() {
    registerViewModel.close();
  });

  group('RegisterViewModel', () {
    test('initial state is RegisterState.initial()', () {
      expect(registerViewModel.state, const RegisterState.initial());
    });

    // Use blocTest for simple, synchronous state changes
    blocTest<RegisterViewModel, RegisterState>(
      'emits state with isPasswordVisible toggled when ShowHidePassword is added',
      build: () => registerViewModel,
      act:
          (bloc) => bloc.add(
            ShowHidePassword(
              context: MockBuildContext(), // Context is unused here
              isVisible: true,
            ),
          ),
      expect:
          () => [
            const RegisterState.initial().copyWith(isPasswordVisible: true),
          ],
    );
  });
}
