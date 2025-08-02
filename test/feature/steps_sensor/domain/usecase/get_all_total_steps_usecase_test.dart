import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/domain/entity/step_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/domain/repository/step_repository.dart';
import 'package:trailmate_mobile_app_assignment/feature/steps_sensor/domain/usecase/get_all_total_steps_usecase.dart';

class MockStepRepository extends Mock implements StepRepository {}

void main() {
  late GetAllTotalStepsUsecase useCase;
  late MockStepRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(const StepEntity());
  });

  setUp(() {
    mockRepository = MockStepRepository();
    useCase = GetAllTotalStepsUsecase(stepRepository: mockRepository);
  });

  const tTotalSteps = 1500;

  group('GetAllTotalStepsUsecase', () {
    test('should get total steps from repository successfully', () async {
      // arrange
      when(
        () => mockRepository.getTotalSteps(),
      ).thenAnswer((_) async => const Right(tTotalSteps));

      // act
      final result = await useCase();

      // assert
      expect(result, const Right(tTotalSteps));
      verify(() => mockRepository.getTotalSteps()).called(1);
    });

    test('should return failure when repository fails', () async {
      // arrange
      const failure = ApiFailure(
        statusCode: 500,
        message: 'Failed to fetch total steps',
      );
      when(
        () => mockRepository.getTotalSteps(),
      ).thenAnswer((_) async => const Left(failure));

      // act
      final result = await useCase();

      // assert
      expect(result, const Left(failure));
      verify(() => mockRepository.getTotalSteps()).called(1);
    });

    test(
      'should return local database failure when repository throws',
      () async {
        // arrange
        const failure = LocalDataBaseFailure(
          message: 'Database connection failed',
        );
        when(
          () => mockRepository.getTotalSteps(),
        ).thenAnswer((_) async => const Left(failure));

        // act
        final result = await useCase();

        // assert
        expect(result, const Left(failure));
        verify(() => mockRepository.getTotalSteps()).called(1);
      },
    );
  });
}
