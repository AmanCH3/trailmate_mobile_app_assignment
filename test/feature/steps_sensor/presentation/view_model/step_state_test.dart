import 'package:flutter_test/flutter_test.dart';
import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/presentation/enum_step_status.dart';
import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/presentation/view_model/step_state.dart';

void main() {
  group('StepState', () {
    group('initial', () {
      test('should return initial state with correct values', () {
        // act
        final state = StepState.initial();

        // assert
        expect(state.status, equals(StepStatus.idle));
        expect(state.sessionSteps, equals(0));
        expect(state.totalSteps, equals(0));
        expect(state.errorMessage, equals(''));
      });

      test('should be equal to another initial state', () {
        // arrange
        final state1 = StepState.initial();
        final state2 = StepState.initial();

        // assert
        expect(state1, equals(state2));
      });
    });

    group('copyWith', () {
      test('should return same state when no parameters are provided', () {
        // arrange
        const originalState = StepState(
          status: StepStatus.success,
          sessionSteps: 100,
          totalSteps: 1500,
          errorMessage: '',
        );

        // act
        final newState = originalState.copyWith();

        // assert
        expect(newState, equals(originalState));
      });

      test('should update status when provided', () {
        // arrange
        const originalState = StepState(
          status: StepStatus.idle,
          sessionSteps: 0,
          totalSteps: 0,
          errorMessage: '',
        );

        // act
        final newState = originalState.copyWith(status: StepStatus.tracking);

        // assert
        expect(newState.status, equals(StepStatus.tracking));
        expect(newState.sessionSteps, equals(0));
        expect(newState.totalSteps, equals(0));
        expect(newState.errorMessage, equals(''));
      });

      test('should update sessionSteps when provided', () {
        // arrange
        const originalState = StepState(
          status: StepStatus.tracking,
          sessionSteps: 0,
          totalSteps: 0,
          errorMessage: '',
        );

        // act
        final newState = originalState.copyWith(sessionSteps: 500);

        // assert
        expect(newState.status, equals(StepStatus.tracking));
        expect(newState.sessionSteps, equals(500));
        expect(newState.totalSteps, equals(0));
        expect(newState.errorMessage, equals(''));
      });

      test('should update totalSteps when provided', () {
        // arrange
        const originalState = StepState(
          status: StepStatus.success,
          sessionSteps: 0,
          totalSteps: 1000,
          errorMessage: '',
        );

        // act
        final newState = originalState.copyWith(totalSteps: 2000);

        // assert
        expect(newState.status, equals(StepStatus.success));
        expect(newState.sessionSteps, equals(0));
        expect(newState.totalSteps, equals(2000));
        expect(newState.errorMessage, equals(''));
      });

      test('should update errorMessage when provided', () {
        // arrange
        const originalState = StepState(
          status: StepStatus.success,
          sessionSteps: 0,
          totalSteps: 0,
          errorMessage: '',
        );

        // act
        final newState = originalState.copyWith(
          errorMessage: 'An error occurred',
        );

        // assert
        expect(newState.status, equals(StepStatus.success));
        expect(newState.sessionSteps, equals(0));
        expect(newState.totalSteps, equals(0));
        expect(newState.errorMessage, equals('An error occurred'));
      });

      test('should update multiple properties when provided', () {
        // arrange
        const originalState = StepState(
          status: StepStatus.idle,
          sessionSteps: 0,
          totalSteps: 0,
          errorMessage: '',
        );

        // act
        final newState = originalState.copyWith(
          status: StepStatus.error,
          sessionSteps: 100,
          totalSteps: 1500,
          errorMessage: 'Multiple errors',
        );

        // assert
        expect(newState.status, equals(StepStatus.error));
        expect(newState.sessionSteps, equals(100));
        expect(newState.totalSteps, equals(1500));
        expect(newState.errorMessage, equals('Multiple errors'));
      });
    });

    group('equality', () {
      test('should be equal when all properties are the same', () {
        // arrange
        const state1 = StepState(
          status: StepStatus.success,
          sessionSteps: 100,
          totalSteps: 1500,
          errorMessage: '',
        );
        const state2 = StepState(
          status: StepStatus.success,
          sessionSteps: 100,
          totalSteps: 1500,
          errorMessage: '',
        );

        // assert
        expect(state1, equals(state2));
      });

      test('should not be equal when status is different', () {
        // arrange
        const state1 = StepState(
          status: StepStatus.success,
          sessionSteps: 100,
          totalSteps: 1500,
          errorMessage: '',
        );
        const state2 = StepState(
          status: StepStatus.error,
          sessionSteps: 100,
          totalSteps: 1500,
          errorMessage: '',
        );

        // assert
        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when sessionSteps is different', () {
        // arrange
        const state1 = StepState(
          status: StepStatus.success,
          sessionSteps: 100,
          totalSteps: 1500,
          errorMessage: '',
        );
        const state2 = StepState(
          status: StepStatus.success,
          sessionSteps: 200,
          totalSteps: 1500,
          errorMessage: '',
        );

        // assert
        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when totalSteps is different', () {
        // arrange
        const state1 = StepState(
          status: StepStatus.success,
          sessionSteps: 100,
          totalSteps: 1500,
          errorMessage: '',
        );
        const state2 = StepState(
          status: StepStatus.success,
          sessionSteps: 100,
          totalSteps: 2000,
          errorMessage: '',
        );

        // assert
        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when errorMessage is different', () {
        // arrange
        const state1 = StepState(
          status: StepStatus.success,
          sessionSteps: 100,
          totalSteps: 1500,
          errorMessage: '',
        );
        const state2 = StepState(
          status: StepStatus.success,
          sessionSteps: 100,
          totalSteps: 1500,
          errorMessage: 'Error message',
        );

        // assert
        expect(state1, isNot(equals(state2)));
      });
    });

    group('props', () {
      test('should contain all properties in correct order', () {
        // arrange
        const state = StepState(
          status: StepStatus.tracking,
          sessionSteps: 500,
          totalSteps: 2000,
          errorMessage: 'Test error',
        );

        // act
        final props = state.props;

        // assert
        expect(props, contains(StepStatus.tracking));
        expect(props, contains(500));
        expect(props, contains(2000));
        expect(props, contains('Test error'));
        expect(props.length, equals(4));
      });
    });
  });
} 