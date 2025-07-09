import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/checklist/domain/entity/checklist_item_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/checklist/domain/usecase/generate_checklist_usecase.dart';

import 'repository_mock.dart';

void main() {
  late MockChecklistRepository repository;
  late GenerateChecklistUsecase usecase;

  setUp(() {
    repository = MockChecklistRepository();
    usecase = GenerateChecklistUsecase(repository);
  });

  const tParams = GenerateChecklistParams(
    experience: 'Beginner',
    duration: '1 day',
    weather: 'Sunny',
  );

  final tChecklistMap = {
    'Essentials': [
      const CheckListEntity(id: 1, name: 'Water Bottle', checked: true),
      const CheckListEntity(id: 2, name: 'Snacks', checked: false),
    ],
    'Clothing': [
      const CheckListEntity(id: 3, name: 'Hiking Boots', checked: true),
      const CheckListEntity(id: 4, name: 'Sun Hat', checked: true),
    ],
  };

  const tFailure = ApiFailure(
    message: 'Failed to generate checklist.',
    statusCode: 500,
  );

  group('GenerateChecklistUsecase', () {
    // Test the success case: when the repository returns data
    test(
      'should get a checklist map from the repository when the call is successful',
      () async {
        // Arrange: a.k.a. Given
        // Configure the mock repository to return a successful result (Right)
        // when generateCheckList is called with matching parameters.
        when(
          () => repository.generateCheckList(
            experience: tParams.experience,
            duration: tParams.duration,
            weather: tParams.weather,
          ),
        ).thenAnswer((_) async => Right(tChecklistMap));

        final result = await usecase(tParams);
        expect(result, Right(tChecklistMap));
        verify(
          () => repository.generateCheckList(
            experience: tParams.experience,
            duration: tParams.duration,
            weather: tParams.weather,
          ),
        ).called(1);

        // 3. Ensure no other methods were called on the mock repository.
        verifyNoMoreInteractions(repository);
      },
    );

    // Test the failure case: when the repository returns a Failure
    test(
      'should return a Failure from the repository when the call is unsuccessful',
      () async {
        // Arrange: a.k.a. Given
        // Configure the mock repository to return a failure (Left)
        // when generateCheckList is called.
        when(
          () => repository.generateCheckList(
            experience: tParams.experience,
            duration: tParams.duration,
            weather: tParams.weather,
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act: a.k.a. When
        // Call the use case.
        final result = await usecase(tParams);

        // Assert: a.k.a. Then
        // 1. Check that the result is the expected failure.
        expect(result, const Left(tFailure));

        // 2. Verify that the repository method was called as expected.
        verify(
          () => repository.generateCheckList(
            experience: tParams.experience,
            duration: tParams.duration,
            weather: tParams.weather,
          ),
        ).called(1);

        // 3. Ensure no other interactions with the mock.
        verifyNoMoreInteractions(repository);
      },
    );
  });
}
