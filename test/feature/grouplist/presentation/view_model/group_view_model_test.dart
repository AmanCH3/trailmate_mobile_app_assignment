// file: test/feature/grouplist/presentation/view_model/group_view_model_test.dart

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/entity/group_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/usecase/GetAll_group_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/usecase/create_group_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/domain/usecase/request_to_join_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view_model/group_event.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view_model/group_state.dart';
import 'package:trailmate_mobile_app_assignment/feature/grouplist/presentation/view_model/group_view_model.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/entity/user_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/user/domain/usecase/user_get_usecase.dart';

// --- MOCK CLASSES ---
class MockCreateGroupUseCase extends Mock implements CreateGroupUseCase {}

class MockGetAllGroupsUseCase extends Mock implements GetAllGroupsUseCase {}

class MockRequestToJoinGroupUseCase extends Mock
    implements RequestToJoinGroupUseCase {}

class MockUserGetUseCase extends Mock implements UserGetUseCase {}

void main() {
  // Declare all necessary variables
  late GroupViewModel groupViewModel;
  late MockGetAllGroupsUseCase mockGetAllGroupsUseCase;
  late MockCreateGroupUseCase mockCreateGroupUseCase;
  late MockRequestToJoinGroupUseCase mockRequestToJoinGroupUseCase;
  late MockUserGetUseCase mockUserGetUseCase;

  const tUser = UserEntity(
    userId: 'user-123',
    name: 'Test User',
    email: 'test@test.com',
    phone: '123-456-7890',
    password: 'password123',
  );
  final tGroup1 = GroupEntity(
    id: 'group-1',
    title: 'Test Group',
    date: DateTime.now(),
    description: '',
    maxSize: 10,
    participants: [],
    status: 'upcoming',
    meetingPointDescription: '',
    requirements: [],
    difficulty: 'Easy',
    photos: [],
    comments: [],
  );
  final tGroupList = [tGroup1];
  final tCreateParams = CreateGroupParams(
    title: 'New Group',
    trailId: 'trail-1',
    date: DateTime.timestamp(),
    description: '',
    maxSize: 10,
    photoPaths: [],
  );
  final tRequestParams = RequestToJoinGroupParams(groupId: tGroup1.id);
  const tFailure = ApiFailure(message: 'An error occurred', statusCode: 500);

  // Register fallback values for custom types used with `any()`
  setUpAll(() {
    registerFallbackValue(tCreateParams);
    registerFallbackValue(tRequestParams);
  });

  // Instantiate fresh mocks before each test
  setUp(() {
    mockGetAllGroupsUseCase = MockGetAllGroupsUseCase();
    mockCreateGroupUseCase = MockCreateGroupUseCase();
    mockRequestToJoinGroupUseCase = MockRequestToJoinGroupUseCase();
    mockUserGetUseCase = MockUserGetUseCase();
  });

  // Helper to build the ViewModel, ensuring mocks are always passed
  GroupViewModel buildViewModel() {
    return GroupViewModel(
      getAllGroupsUseCase: mockGetAllGroupsUseCase,
      createGroupUseCase: mockCreateGroupUseCase,
      requestToJoinGroupUseCase: mockRequestToJoinGroupUseCase,
      userGetUseCase: mockUserGetUseCase,
    );
  }

  group('Initial State & Constructor Auto-Fetch', () {
    blocTest<GroupViewModel, GroupState>(
      'emits [Loading, Loaded] when created and all fetches are successful',
      // ARRANGE: Mock ALL dependencies called in the constructor
      setUp: () {
        when(
          () => mockUserGetUseCase.call(),
        ).thenAnswer((_) async => const Right(tUser));
        when(
          () => mockGetAllGroupsUseCase.call(),
        ).thenAnswer((_) async => Right(tGroupList));
      },
      // ACT: Build the BLoC. Actions happen in the constructor.
      build: buildViewModel,
      // EXPECT: Verify the sequence of states. The final state should include groups.
      expect:
          () => <GroupState>[GroupLoading(), GroupsLoaded(groups: tGroupList)],
      // VERIFY: Check that constructor-triggered use cases were called.
      verify: (_) {
        verify(() => mockUserGetUseCase.call()).called(1);
        verify(() => mockGetAllGroupsUseCase.call()).called(1);
      },
    );

    blocTest<GroupViewModel, GroupState>(
      'emits [Loading, Failure] when fetching groups fails on creation',
      setUp: () {
        when(
          () => mockUserGetUseCase.call(),
        ).thenAnswer((_) async => const Right(tUser));
        // Mock the group fetch to fail
        when(
          () => mockGetAllGroupsUseCase.call(),
        ).thenAnswer((_) async => const Left(tFailure));
      },
      build: buildViewModel,
      expect:
          () => <GroupState>[
            GroupLoading(),
            const GroupFailure(message: 'An error occurred'),
          ],
    );
  });

  group('FetchAllGroupsEvent (Manual Trigger)', () {
    blocTest<GroupViewModel, GroupState>(
      'emits [Loading, Loaded] on successful manual fetch',
      // ARRANGE: Set up a successful initial state from the constructor
      setUp: () {
        when(
          () => mockUserGetUseCase.call(),
        ).thenAnswer((_) async => const Right(tUser));
        when(
          () => mockGetAllGroupsUseCase.call(),
        ).thenAnswer((_) async => const Right([]));
      },
      build: buildViewModel,
      // ACT: Now mock the response for the *second* fetch and trigger the event.
      act: (bloc) {
        when(
          () => mockGetAllGroupsUseCase.call(),
        ).thenAnswer((_) async => Right(tGroupList));
        bloc.add(FetchAllGroupsEvent());
      },
      // We skip the emissions from the constructor (Loading, Loaded with empty list).
      skip: 2,
      expect:
          () => <GroupState>[GroupLoading(), GroupsLoaded(groups: tGroupList)],
    );
  });
}
