import 'package:flutter_test/flutter_test.dart';
import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/presentation/view_model/step_event.dart';

void main() {
  group('StepEvent', () {
    group('LoadTotalSteps', () {
      test('should be equal to another LoadTotalSteps', () {
        // arrange
        final event1 = LoadTotalSteps();
        final event2 = LoadTotalSteps();

        // assert
        expect(event1, equals(event2));
      });

      test('should have empty props', () {
        // arrange
        final event = LoadTotalSteps();

        // act
        final props = event.props;

        // assert
        expect(props, isEmpty);
      });
    });

    group('StartStepTracking', () {
      test('should be equal when trailId is the same', () {
        // arrange
        const event1 = StartStepTracking(trailId: 'trail_123');
        const event2 = StartStepTracking(trailId: 'trail_123');

        // assert
        expect(event1, equals(event2));
      });

      test('should not be equal when trailId is different', () {
        // arrange
        const event1 = StartStepTracking(trailId: 'trail_123');
        const event2 = StartStepTracking(trailId: 'trail_456');

        // assert
        expect(event1, isNot(equals(event2)));
      });

      test('should have trailId in props', () {
        // arrange
        const event = StartStepTracking(trailId: 'trail_123');

        // act
        final props = event.props;

        // assert
        expect(props, contains('trail_123'));
        expect(props.length, equals(1));
      });
    });

    group('StopStepTracking', () {
      test('should be equal to another StopStepTracking', () {
        // arrange
        final event1 = StopStepTracking();
        final event2 = StopStepTracking();

        // assert
        expect(event1, equals(event2));
      });

      test('should have empty props', () {
        // arrange
        final event = StopStepTracking();

        // act
        final props = event.props;

        // assert
        expect(props, isEmpty);
      });
    });

    group('PedometerUpdated', () {
      test('should be equal when newStepCount is the same', () {
        // arrange
        const event1 = PedometerUpdated(500);
        const event2 = PedometerUpdated(500);

        // assert
        expect(event1, equals(event2));
      });

      test('should not be equal when newStepCount is different', () {
        // arrange
        const event1 = PedometerUpdated(500);
        const event2 = PedometerUpdated(1000);

        // assert
        expect(event1, isNot(equals(event2)));
      });

      test('should have newStepCount in props', () {
        // arrange
        const event = PedometerUpdated(750);

        // act
        final props = event.props;

        // assert
        expect(props, contains(750));
        expect(props.length, equals(1));
      });

      test('should handle zero steps', () {
        // arrange
        const event = PedometerUpdated(0);

        // act
        final props = event.props;

        // assert
        expect(props, contains(0));
        expect(event, equals(const PedometerUpdated(0)));
      });

      test('should handle negative steps', () {
        // arrange
        const event = PedometerUpdated(-100);

        // act
        final props = event.props;

        // assert
        expect(props, contains(-100));
        expect(event, equals(const PedometerUpdated(-100)));
      });
    });
  });
}
