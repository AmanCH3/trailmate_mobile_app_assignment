import 'package:flutter/material.dart' hide StepState;
import 'package:flutter_test/flutter_test.dart';
import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/presentation/enum_step_status.dart';
import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/presentation/view_model/step_state.dart';

class StepCounterWidget extends StatelessWidget {
  final StepState state;
  final VoidCallback? onStartTracking;
  final VoidCallback? onStopTracking;

  const StepCounterWidget({
    Key? key,
    required this.state,
    this.onStartTracking,
    this.onStopTracking,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Step Counter',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStepInfo('Total Steps', state.totalSteps.toString()),
                _buildStepInfo('Session Steps', state.sessionSteps.toString()),
              ],
            ),
            const SizedBox(height: 16),
            _buildActionButton(),
            if (state.status == StepStatus.loading)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: CircularProgressIndicator(),
              ),
            if (state.status == StepStatus.error && state.errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  state.errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepInfo(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    if (state.status == StepStatus.tracking) {
      return ElevatedButton(
        onPressed: onStopTracking,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        child: const Text('Stop Tracking'),
      );
    } else {
      return ElevatedButton(
        onPressed: state.status == StepStatus.loading ? null : onStartTracking,
        child: const Text('Start Tracking'),
      );
    }
  }
}

void main() {
  group('StepCounterWidget', () {
    testWidgets('should display total and session steps correctly', (tester) async {
      // arrange
      const state = StepState(
        status: StepStatus.success,
        sessionSteps: 500,
        totalSteps: 2500,
        errorMessage: '',
      );

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StepCounterWidget(
              state: state,
              onStartTracking: () {},
              onStopTracking: () {},
            ),
          ),
        ),
      );

      // assert
      expect(find.text('Step Counter'), findsOneWidget);
      expect(find.text('Total Steps'), findsOneWidget);
      expect(find.text('Session Steps'), findsOneWidget);
      expect(find.text('2500'), findsOneWidget);
      expect(find.text('500'), findsOneWidget);
    });

    testWidgets('should show start tracking button when not tracking', (tester) async {
      // arrange
      const state = StepState(
        status: StepStatus.success,
        sessionSteps: 0,
        totalSteps: 0,
        errorMessage: '',
      );

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StepCounterWidget(
              state: state,
              onStartTracking: () {},
              onStopTracking: () {},
            ),
          ),
        ),
      );

      // assert
      expect(find.text('Start Tracking'), findsOneWidget);
      expect(find.text('Stop Tracking'), findsNothing);
    });

    testWidgets('should show stop tracking button when tracking', (tester) async {
      // arrange
      const state = StepState(
        status: StepStatus.tracking,
        sessionSteps: 100,
        totalSteps: 1000,
        errorMessage: '',
      );

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StepCounterWidget(
              state: state,
              onStartTracking: () {},
              onStopTracking: () {},
            ),
          ),
        ),
      );

      // assert
      expect(find.text('Stop Tracking'), findsOneWidget);
      expect(find.text('Start Tracking'), findsNothing);
    });

    testWidgets('should call onStartTracking when start button is pressed', (tester) async {
      // arrange
      bool startTrackingCalled = false;
      const state = StepState(
        status: StepStatus.success,
        sessionSteps: 0,
        totalSteps: 0,
        errorMessage: '',
      );

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StepCounterWidget(
              state: state,
              onStartTracking: () => startTrackingCalled = true,
              onStopTracking: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.text('Start Tracking'));
      await tester.pump();

      // assert
      expect(startTrackingCalled, isTrue);
    });

    testWidgets('should call onStopTracking when stop button is pressed', (tester) async {
      // arrange
      bool stopTrackingCalled = false;
      const state = StepState(
        status: StepStatus.tracking,
        sessionSteps: 100,
        totalSteps: 1000,
        errorMessage: '',
      );

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StepCounterWidget(
              state: state,
              onStartTracking: () {},
              onStopTracking: () => stopTrackingCalled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Stop Tracking'));
      await tester.pump();

      // assert
      expect(stopTrackingCalled, isTrue);
    });

    testWidgets('should show loading indicator when status is loading', (tester) async {
      // arrange
      const state = StepState(
        status: StepStatus.loading,
        sessionSteps: 0,
        totalSteps: 0,
        errorMessage: '',
      );

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StepCounterWidget(
              state: state,
              onStartTracking: () {},
              onStopTracking: () {},
            ),
          ),
        ),
      );

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should disable start button when loading', (tester) async {
      // arrange
      const state = StepState(
        status: StepStatus.loading,
        sessionSteps: 0,
        totalSteps: 0,
        errorMessage: '',
      );

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StepCounterWidget(
              state: state,
              onStartTracking: () {},
              onStopTracking: () {},
            ),
          ),
        ),
      );

      // assert
      final startButton = tester.widget<ElevatedButton>(find.text('Start Tracking'));
      expect(startButton.onPressed, isNull);
    });

    testWidgets('should show error message when status is error', (tester) async {
      // arrange
      const state = StepState(
        status: StepStatus.error,
        sessionSteps: 0,
        totalSteps: 0,
        errorMessage: 'Test error message',
      );

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StepCounterWidget(
              state: state,
              onStartTracking: () {},
              onStopTracking: () {},
            ),
          ),
        ),
      );

      // assert
      expect(find.text('Test error message'), findsOneWidget);
    });

    testWidgets('should not show error message when error message is empty', (tester) async {
      // arrange
      const state = StepState(
        status: StepStatus.error,
        sessionSteps: 0,
        totalSteps: 0,
        errorMessage: '',
      );

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StepCounterWidget(
              state: state,
              onStartTracking: () {},
              onStopTracking: () {},
            ),
          ),
        ),
      );

      // assert
      expect(find.text('Test error message'), findsNothing);
    });

    testWidgets('should handle zero steps correctly', (tester) async {
      // arrange
      const state = StepState(
        status: StepStatus.success,
        sessionSteps: 0,
        totalSteps: 0,
        errorMessage: '',
      );

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StepCounterWidget(
              state: state,
              onStartTracking: () {},
              onStopTracking: () {},
            ),
          ),
        ),
      );

      // assert
      expect(find.text('0'), findsNWidgets(2)); // Both total and session steps
    });

    testWidgets('should handle large step numbers correctly', (tester) async {
      // arrange
      const state = StepState(
        status: StepStatus.success,
        sessionSteps: 999999,
        totalSteps: 1234567,
        errorMessage: '',
      );

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StepCounterWidget(
              state: state,
              onStartTracking: () {},
              onStopTracking: () {},
            ),
          ),
        ),
      );

      // assert
      expect(find.text('999999'), findsOneWidget);
      expect(find.text('1234567'), findsOneWidget);
    });
  });
} 