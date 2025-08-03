import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';

// Import all necessary production code
import 'package:trailmate_mobile_app_assignment/feature/home/presentation/view_model/home_state.dart';
import 'package:trailmate_mobile_app_assignment/feature/home/presentation/view_model/home_view_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/usecase/user_logout_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view/login_view.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/login_view_model/login_view_model.dart';

// --- Mocks ---
class MockUserLogoutUseCase extends Mock implements UserLogoutUseCase {}

class MockLoginViewModel extends Mock implements LoginViewModel {}

class MockFailure extends Mock implements Failure {
  @override
  final String message;
  MockFailure([this.message = 'Something went wrong']);
}

void main() {
  late HomeViewModel homeViewModel;
  late MockUserLogoutUseCase mockUserLogoutUseCase;
  late MockLoginViewModel mockLoginViewModel;

  setUp(() {
    // Initialize mocks and the ViewModel before each test
    mockUserLogoutUseCase = MockUserLogoutUseCase();
    mockLoginViewModel = MockLoginViewModel();
    homeViewModel = HomeViewModel(
      loginViewModel: mockLoginViewModel,
      userLogoutUseCase: mockUserLogoutUseCase,
    );
  });

  group('HomeViewModel', () {
    // This test is simple and doesn't require a widget environment
    test('initial state is correct', () {
      expect(homeViewModel.state, HomeState.initial());
    });

    // This test uses bloc_test and works because it doesn't have UI dependencies
    blocTest<HomeViewModel, HomeState>(
      'emits state with updated selectedIndex when onTabTapped is called',
      build: () => homeViewModel,
      act: (cubit) => cubit.onTabTapped(2),
      expect:
          () => [
            // Using a matcher to avoid Equatable issues since we can't change the state
            isA<HomeState>().having(
              (state) => state.selectedIndex,
              'selectedIndex',
              2,
            ),
          ],
    );

    group('logout', () {
      // For methods with BuildContext, we MUST use testWidgets
      testWidgets('should call use case and show SnackBar on failure', (
        WidgetTester tester,
      ) async {
        // ARRANGE: Stub the use case to return a failure
        final tFailure = MockFailure('Logout failed');
        when(
          () => mockUserLogoutUseCase(),
        ).thenAnswer((_) async => Left(tFailure));

        // ACT: Pump a widget with a Scaffold to host the SnackBar
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              // Scaffold is necessary for ScaffoldMessenger
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => homeViewModel.logout(context),
                    child: const Text('Logout'),
                  );
                },
              ),
            ),
          ),
        );

        // Tap the button to trigger the logout method
        await tester.tap(find.byType(ElevatedButton));
        // pump() allows the SnackBar to build and appear
        await tester.pump();

        // ASSERT
        // 1. Verify the business logic was called
        verify(() => mockUserLogoutUseCase()).called(1);

        // 2. Verify the UI side-effect: The SnackBar with the error message is visible
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Logout failed. Please try again.'), findsOneWidget);
      });
    });
  });
}
