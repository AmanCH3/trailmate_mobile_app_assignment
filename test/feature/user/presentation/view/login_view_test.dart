import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Import the necessary files from your project
import 'package:trailmate_mobile_app_assignment/app/service_locator/service_locator.dart';
import 'package:trailmate_mobile_app_assignment/core/common/trail_mate_loading.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view/login_view.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/login_view_model/login_event.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/login_view_model/login_state.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/login_view_model/login_view_model.dart';

// Use MockBloc for a streamlined mocking experience with BLoC.
class MockLoginViewModel extends MockBloc<LoginEvent, LoginState>
    implements LoginViewModel {}

// A simple mock for BuildContext, required for registering fallback values.
class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late MockLoginViewModel mockLoginViewModel;

  // setUpAll runs once before all tests. It's a good place to register fallbacks.
  setUpAll(() {
    // Mocktail requires fallback values for custom types used in matchers like `any()`.
    registerFallbackValue(
      LoginWithEmailAndPassword(
        context: MockBuildContext(),
        email: '',
        password: '',
      ),
    );
    registerFallbackValue(NavigateToRegisterView(context: MockBuildContext()));
  });

  // setUp runs before each individual test.
  setUp(() {
    // Create a new mock instance for each test to ensure isolation.
    mockLoginViewModel = MockLoginViewModel();

    // IMPORTANT: Since LoginView uses serviceLocator, we must override its
    // registration to return our mock instance for the test.
    if (serviceLocator.isRegistered<LoginViewModel>()) {
      serviceLocator.unregister<LoginViewModel>();
    }
    serviceLocator.registerFactory<LoginViewModel>(() => mockLoginViewModel);
  });

  // tearDown runs after each test, perfect for cleanup.
  tearDown(() {
    serviceLocator.unregister<LoginViewModel>();
  });

  // A helper function to build the widget tree for tests.
  // This reduces boilerplate code in each test case.
  Widget createWidgetUnderTest() {
    return MaterialApp(
      // We use BlocProvider.value because we are providing an existing instance (our mock).
      home: BlocProvider<LoginViewModel>.value(
        value: mockLoginViewModel,
        child: const LoginView(),
      ),
    );
  }

  group('LoginView', () {
    testWidgets('renders initial UI elements correctly', (tester) async {
      // Arrange: Stub the BLoC to return the initial state.
      when(() => mockLoginViewModel.state).thenReturn(LoginState.initial());

      // Act: Build and render the widget.
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert: Check for the presence of key widgets using their text or type.
      expect(find.text('Welcome!'), findsOneWidget);
      expect(
        find.widgetWithText(TextFormField, 'Email Address'),
        findsOneWidget,
      );
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);
      expect(find.text("Don't have an account? Sign up"), findsOneWidget);
      expect(
        find.byType(TrailMateLoading),
        findsOneWidget,
      ); // The wrapper is always there
      expect(
        find.byType(CircularProgressIndicator),
        findsNothing,
      ); // The indicator inside is not
    });

    testWidgets(
      'shows validation errors when sign in is tapped with empty fields',
      (tester) async {
        // Arrange
        when(() => mockLoginViewModel.state).thenReturn(LoginState.initial());
        await tester.pumpWidget(createWidgetUnderTest());

        await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
        await tester.pump();
        expect(find.text('Please enter your email address'), findsOneWidget);
        expect(find.text('Please enter your password'), findsOneWidget);
      },
    );

    testWidgets('shows validation error for short password', (tester) async {
      // Arrange
      when(() => mockLoginViewModel.state).thenReturn(LoginState.initial());
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email Address'),
        'test@test.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        '123',
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      // Assert: Check for the password-specific validation message.
      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
      // Ensure the email validation message does not show up.
      expect(find.text('Please enter your email address'), findsNothing);
    });

    testWidgets('adds LoginWithEmailAndPassword event when form is valid', (
      tester,
    ) async {
      // Arrange
      when(() => mockLoginViewModel.state).thenReturn(LoginState.initial());
      await tester.pumpWidget(createWidgetUnderTest());

      const email = 'test@example.com';
      const password = 'password123';

      // Act: Enter valid data and tap the button.
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email Address'),
        email,
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        password,
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      // Assert: Verify that the correct event was added to the BLoC.
      // The matcher checks that the event is of the right type with the right data.
      verify(
        () => mockLoginViewModel.add(
          any(
            that: isA<LoginWithEmailAndPassword>()
                .having((e) => e.email, 'email', email)
                .having((e) => e.password, 'password', password),
          ),
        ),
      ).called(1);
    });

    testWidgets(
      'shows loading indicator and disables button when state is loading',
      (tester) async {
        // Arrange: Stub the BLoC to return a loading state.
        when(
          () => mockLoginViewModel.state,
        ).thenReturn(LoginState(isLoading: true));

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        // 1. The custom loading widget should be in its loading state.
        final loadingWidget = tester.widget<TrailMateLoading>(
          find.byType(TrailMateLoading),
        );
        expect(loadingWidget.isLoading, isTrue);

        // 2. The ElevatedButton should be disabled (onPressed is null).
        final signInButton = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(signInButton.onPressed, isNull);
      },
    );

    testWidgets(
      'adds NavigateToRegisterView event when signup text is tapped',
      (tester) async {
        // Arrange
        when(() => mockLoginViewModel.state).thenReturn(LoginState.initial());
        await tester.pumpWidget(createWidgetUnderTest());

        // Act: Find and tap the "Sign up" text.
        await tester.tap(find.text("Don't have an account? Sign up"));
        await tester.pump();

        // Assert: Verify the correct navigation event was added.
        verify(
          () =>
              mockLoginViewModel.add(any(that: isA<NavigateToRegisterView>())),
        ).called(1);
      },
    );
  });
}
