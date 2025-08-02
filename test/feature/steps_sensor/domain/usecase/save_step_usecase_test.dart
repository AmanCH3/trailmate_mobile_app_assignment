import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/domain/entity/step_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/domain/repository/step_repository.dart';
import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/domain/usecase/save_step_usecase.dart';

class MockStepRepository extends Mock implements StepRepository {}

void main() {
  late SaveSteps useCase;
  late MockStepRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(const StepEntity());
  });

  setUp(() {
    mockRepository = MockStepRepository();
    useCase = SaveSteps(mockRepository);
  });

  final tStepEntity = const StepEntity(
    stepId: 'step_123',
    step: 1000,
    timeStamps: null,
  );

  group('SaveSteps', () {
    test('should save steps successfully', () async {
      // arrange
      when(
        () => mockRepository.saveSteps(tStepEntity),
      ).thenAnswer((_) async => const Right(null));

      // act
      final result = await useCase(tStepEntity);

      // assert
      expect(result, const Right(null));
      verify(() => mockRepository.saveSteps(tStepEntity)).called(1);
    });

    test('should return failure when repository fails to save', () async {
      // arrange
      const failure = ApiFailure(
        statusCode: 400,
        message: 'Failed to save steps',
      );
      when(
        () => mockRepository.saveSteps(tStepEntity),
      ).thenAnswer((_) async => const Left(failure));

      // act
      final result = await useCase(tStepEntity);

      // assert
      expect(result, const Left(failure));
      verify(() => mockRepository.saveSteps(tStepEntity)).called(1);
    });

    test(
      'should return local database failure when repository throws',
      () async {
        // arrange
        const failure = LocalDataBaseFailure(
          message: 'Database connection failed',
        );
        when(
          () => mockRepository.saveSteps(tStepEntity),
        ).thenAnswer((_) async => const Left(failure));

        // act
        final result = await useCase(tStepEntity);

        // assert
        expect(result, const Left(failure));
        verify(() => mockRepository.saveSteps(tStepEntity)).called(1);
      },
    );

    test('should handle null step entity', () async {
      // arrange
      const nullStepEntity = StepEntity();
      when(
        () => mockRepository.saveSteps(nullStepEntity),
      ).thenAnswer((_) async => const Right(null));

      // act
      final result = await useCase(nullStepEntity);

      // assert
      expect(result, const Right(null));
      verify(() => mockRepository.saveSteps(nullStepEntity)).called(1);
    });
  });
}
