import 'package:flutter_test/flutter_test.dart';
import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/domain/entity/step_entity.dart';

void main() {
  group('StepEntity', () {
    test('should be equal when all properties are the same', () {
      // arrange
      const stepEntity1 = StepEntity(
        stepId: 'step_123',
        step: 1000,
        timeStamps: null,
      );
      const stepEntity2 = StepEntity(
        stepId: 'step_123',
        step: 1000,
        timeStamps: null,
      );

      // assert
      expect(stepEntity1, equals(stepEntity2));
    });

    test('should not be equal when properties are different', () {
      // arrange
      const stepEntity1 = StepEntity(
        stepId: 'step_123',
        step: 1000,
        timeStamps: null,
      );
      const stepEntity2 = StepEntity(
        stepId: 'step_456',
        step: 1000,
        timeStamps: null,
      );

      // assert
      expect(stepEntity1, isNot(equals(stepEntity2)));
    });

    test('should not be equal when step count is different', () {
      // arrange
      const stepEntity1 = StepEntity(
        stepId: 'step_123',
        step: 1000,
        timeStamps: null,
      );
      const stepEntity2 = StepEntity(
        stepId: 'step_123',
        step: 2000,
        timeStamps: null,
      );

      // assert
      expect(stepEntity1, isNot(equals(stepEntity2)));
    });

    test('should handle null values correctly', () {
      // arrange
      const stepEntity1 = StepEntity();
      const stepEntity2 = StepEntity();

      // assert
      expect(stepEntity1, equals(stepEntity2));
    });

    test('should have correct props', () {
      // arrange
      const stepEntity = StepEntity(
        stepId: 'step_123',
        step: 1000,
        timeStamps: null,
      );

      // act
      final props = stepEntity.props;

      // assert
      expect(props, contains('step_123'));
      expect(props, contains(1000));
      expect(props, contains(null));
    });

    test('should handle DateTime in props', () {
      // arrange
      final now = DateTime.now();
      final stepEntity = StepEntity(
        stepId: 'step_123',
        step: 1000,
        timeStamps: now,
      );

      // act
      final props = stepEntity.props;

      // assert
      expect(props, contains(now));
    });
  });
} 