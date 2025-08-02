// 1. Import necessary packages
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/entity/group_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/repository/group_repository.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/usecase/GetAll_group_usecase.dart';

// 3. Create a mock class using Mocktail's 'Mock'
class MockGroupRepository extends Mock implements IGroupRepository {}

void main() {
  late GetAllGroupsUseCase usecase;
  late MockGroupRepository mockGroupRepository;

  // *** THE FIX IS HERE ***
  // This block runs once before all tests in this file.
  // It registers a default non-null value for DateTime.
  setUpAll(() {
    registerFallbackValue(DateTime(2023));
  });
  // **********************

  setUp(() {
    mockGroupRepository = MockGroupRepository();
    usecase = GetAllGroupsUseCase(groupRepository: mockGroupRepository);
  });

  final tGroupList = [
    GroupEntity(
      id: '1',
      description: 'Desc 1',
      title: '',
      date: null, // Note: your entity allows a nullable date
      maxSize: 8,
      participants: [],
      status: '',
      meetingPointDescription: '',
      requirements: [],
      difficulty: '',
      photos: [],
    ),
    GroupEntity(
      id: '2',
      description: 'Desc 2',
      title: '',
      date: null,
      maxSize: 9,
      participants: [],
      status: '',
      meetingPointDescription: '',
      requirements: [],
      difficulty: '',
      photos: [],
    ),
  ];
  final tServerFailure = ApiFailure(
    message: 'Could not fetch data from server',
    statusCode: 500,
  );

  group('GetAllGroupsUseCase', () {
    test(
      'should get a list of groups from the repository when the call is successful',
      () async {
        // Arrange
        when(
          () => mockGroupRepository.getAllGroups(),
        ).thenAnswer((_) async => Right(tGroupList));

        // Act
        final result = await usecase();

        // Assert
        expect(result, Right(tGroupList));
        verify(() => mockGroupRepository.getAllGroups()).called(1);
        verifyNoMoreInteractions(mockGroupRepository);
      },
    );

    test(
      'should return a failure when the call to the repository is unsuccessful',
      () async {
        // Arrange
        when(
          () => mockGroupRepository.getAllGroups(),
        ).thenAnswer((_) async => Left(tServerFailure));

        // Act
        final result = await usecase();

        // Assert
        expect(result, Left(tServerFailure));
        verify(() => mockGroupRepository.getAllGroups()).called(1);
        verifyNoMoreInteractions(mockGroupRepository);
      },
    );
  });
}
