import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Import the necessary files from your project
import 'package:trailmate_mobile_app_assignment/app/service_locator/service_locator.dart';
import 'package:trailmate_mobile_app_assignment/core/common/common_textform_view.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view/signup_view.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/register_view_model/register_event.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/register_view_model/register_state.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/presentation/view_model/register_view_model/register_view_model.dart';

// Use MockBloc for a streamlined mocking experience with BLoC.
class MockRegisterViewModel extends MockBloc<RegisterEvent, RegisterState>
    implements RegisterViewModel {}

// A simple mock for BuildContext, required for registering fallback values.
class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late MockRegisterViewModel mockRegisterViewModel;

  // setUpAll runs once before all tests. It's a good place to register fallbacks.
  setUpAll(() {
    // Mocktail requires fallback values for custom types used in matchers like `any()`.
    registerFallbackValue(
      RegisterUserEvent(
        context: MockBuildContext(),
        name: '',
        email: '',
        password: '',
        phone: '',
      ),
    );
  });

  // setUp runs before each individual test.
  setUp(() {
    // Create a new mock instance for each test to ensure isolation.
    mockRegisterViewModel = MockRegisterViewModel();

    // IMPORTANT: Since SignupView uses serviceLocator, we must override its
    // registration to return our mock instance for the test.
    if (serviceLocator.isRegistered<RegisterViewModel>()) {
      serviceLocator.unregister<RegisterViewModel>();
    }
    serviceLocator.registerFactory<RegisterViewModel>(
      () => mockRegisterViewModel,
    );
  });

  // tearDown runs after each test, perfect for cleanup.
  tearDown(() {
    if (serviceLocator.isRegistered<RegisterViewModel>()) {
      serviceLocator.unregister<RegisterViewModel>();
    }
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      // We use BlocProvider.value because we are providing an existing instance (our mock).
      home: BlocProvider<RegisterViewModel>.value(
        value: mockRegisterViewModel,
        child: const SignupView(),
      ),
    );
  }

  group('SignupView', () {
    testWidgets(
      'shows validation errors when sign in is tapped with empty fields',
      (tester) async {
        // Arrange
        when(
          () => mockRegisterViewModel.state,
        ).thenReturn(RegisterState.initial());
        await tester.pumpWidget(createWidgetUnderTest());

        // Act: Tap the first sign in button (registration button)
        await tester.tap(find.byType(ElevatedButton).first);
        await tester.pump();

        // Assert: Check for validation messages
        expect(find.text('Please enter your name'), findsOneWidget);
        expect(
          find.text('Please provide your valid email address'),
          findsOneWidget,
        );
        expect(
          find.text('Please enter your password'),
          findsNWidgets(2),
        ); // Password and Confirm Password
        expect(find.text('Phone number is required'), findsOneWidget);
      },
    );

    testWidgets('shows validation error for short password', (tester) async {
      // Arrange
      when(
        () => mockRegisterViewModel.state,
      ).thenReturn(RegisterState.initial());
      await tester.pumpWidget(createWidgetUnderTest());

      // Act: Fill in fields with short password
      await tester.enterText(
        find.widgetWithText(CommonTextformView, 'Fullname'),
        'John Doe',
      );
      await tester.enterText(
        find.widgetWithText(CommonTextformView, 'Email address'),
        'john@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        '123',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm password'),
        '123',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Contact no'),
        '1234567890',
      );

      await tester.tap(find.byType(ElevatedButton).first);
      await tester.pump();

      // Assert: Check for password validation messages
      expect(
        find.text('Password must be at least 6 charcters'),
        findsNWidgets(2), // Both password fields should show this error
      );
    });

    testWidgets('shows validation error for invalid phone number', (
      tester,
    ) async {
      // Arrange
      when(
        () => mockRegisterViewModel.state,
      ).thenReturn(RegisterState.initial());
      await tester.pumpWidget(createWidgetUnderTest());

      // Act: Fill in fields with invalid phone number
      await tester.enterText(
        find.widgetWithText(CommonTextformView, 'Fullname'),
        'John Doe',
      );
      await tester.enterText(
        find.widgetWithText(CommonTextformView, 'Email address'),
        'john@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm password'),
        'password123',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Contact no'),
        '123', // Invalid phone number
      );

      await tester.tap(find.byType(ElevatedButton).first);
      await tester.pump();

      // Assert: Check for phone validation message
      expect(find.text('Enter a valid 10-digit number'), findsOneWidget);
    });

    testWidgets('adds RegisterUserEvent when form is valid', (tester) async {
      // Arrange
      when(
        () => mockRegisterViewModel.state,
      ).thenReturn(RegisterState.initial());
      await tester.pumpWidget(createWidgetUnderTest());

      const name = 'John Doe';
      const email = 'john@example.com';
      const password = 'password123';
      const phone = '1234567890';

      // Act: Enter valid data and tap the registration button
      await tester.enterText(
        find.widgetWithText(CommonTextformView, 'Fullname'),
        name,
      );
      await tester.enterText(
        find.widgetWithText(CommonTextformView, 'Email address'),
        email,
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        password,
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm password'),
        password,
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Contact no'),
        phone,
      );

      await tester.tap(find.byType(ElevatedButton).first);
      await tester.pump();

      // Assert: Verify that the correct event was added to the BLoC.
      verify(
        () => mockRegisterViewModel.add(
          any(
            that: isA<RegisterUserEvent>()
                .having((e) => e.name, 'name', name)
                .having((e) => e.email, 'email', email)
                .having((e) => e.password, 'password', password)
                .having((e) => e.phone, 'phone', phone),
          ),
        ),
      ).called(1);
    });
    group('Form Validation Edge Cases', () {
      testWidgets('validates phone number with letters', (tester) async {
        when(
          () => mockRegisterViewModel.state,
        ).thenReturn(RegisterState.initial());
        await tester.pumpWidget(createWidgetUnderTest());

        // Enter phone number with letters
        await tester.enterText(
          find.widgetWithText(CommonTextformView, 'Fullname'),
          'John Doe',
        );
        await tester.enterText(
          find.widgetWithText(CommonTextformView, 'Email address'),
          'john@example.com',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'),
          'password123',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Confirm password'),
          'password123',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Contact no'),
          '12345abcde',
        );

        await tester.tap(find.byType(ElevatedButton).first);
        await tester.pump();

        expect(find.text('Enter a valid 10-digit number'), findsOneWidget);
      });

      testWidgets('validates phone number with special characters', (
        tester,
      ) async {
        when(
          () => mockRegisterViewModel.state,
        ).thenReturn(RegisterState.initial());
        await tester.pumpWidget(createWidgetUnderTest());

        await tester.enterText(
          find.widgetWithText(CommonTextformView, 'Fullname'),
          'John Doe',
        );
        await tester.enterText(
          find.widgetWithText(CommonTextformView, 'Email address'),
          'john@example.com',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'),
          'password123',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Confirm password'),
          'password123',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Contact no'),
          '123-456-789',
        );

        await tester.tap(find.byType(ElevatedButton).first);
        await tester.pump();

        expect(find.text('Enter a valid 10-digit number'), findsOneWidget);
      });

      testWidgets('handles extremely long inputs', (tester) async {
        when(
          () => mockRegisterViewModel.state,
        ).thenReturn(RegisterState.initial());
        await tester.pumpWidget(createWidgetUnderTest());

        final longName = 'A' * 100;
        final longEmail = 'a' * 50 + '@example.com';

        await tester.enterText(
          find.widgetWithText(CommonTextformView, 'Fullname'),
          longName,
        );
        await tester.enterText(
          find.widgetWithText(CommonTextformView, 'Email address'),
          longEmail,
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'),
          'password123',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Confirm password'),
          'password123',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Contact no'),
          '1234567890',
        );

        await tester.tap(find.byType(ElevatedButton).first);
        await tester.pump();

        verify(
          () => mockRegisterViewModel.add(
            any(
              that: isA<RegisterUserEvent>()
                  .having((e) => e.name, 'name', longName)
                  .having((e) => e.email, 'email', longEmail),
            ),
          ),
        ).called(1);
      });
    });
  });
}
