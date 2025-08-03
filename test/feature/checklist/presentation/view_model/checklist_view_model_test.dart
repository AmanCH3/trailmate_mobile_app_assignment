import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trailmate_mobile_app_assignment/core/error/failure.dart';
import 'package:trailmate_mobile_app_assignment/feature/checklist/domain/entity/checklist_item_entity.dart';
import 'package:trailmate_mobile_app_assignment/feature/checklist/domain/usecase/generate_checklist_usecase.dart';
import 'package:trailmate_mobile_app_assignment/feature/checklist/presentation/view_model/checklist_event.dart';
import 'package:trailmate_mobile_app_assignment/feature/checklist/presentation/view_model/checklist_state.dart';
import 'package:trailmate_mobile_app_assignment/feature/checklist/presentation/view_model/checklist_view_model.dart';

// Mock the use case dependency
class MockGenerateChecklistUsecase extends Mock
    implements GenerateChecklistUsecase {}

// Mock the Failure class for error testing
class MockFailure extends Mock implements Failure {
  @override
  final String message;
  MockFailure([this.message = 'An error occurred']);
}

void main() {
  late ChecklistBloc checklistBloc;
  late MockGenerateChecklistUsecase mockGenerateChecklistUsecase;

  // Mock data for use in tests
  const tParams = GenerateChecklistParams(
    experience: 'Beginner',
    duration: '1-3 days',
    weather: 'Sunny',
  );

  final tChecklist = {
    'Essentials': [
      const CheckListEntity(id: 1, name: 'Backpack', checked: false),
      const CheckListEntity(id: 2, name: 'Water Bottle', checked: false),
    ],
    'Clothing': [
      const CheckListEntity(id: 3, name: 'Hiking Boots', checked: false),
    ],
  };

  setUp(() {
    mockGenerateChecklistUsecase = MockGenerateChecklistUsecase();
    checklistBloc = ChecklistBloc(
      generateChecklistUseCase: mockGenerateChecklistUsecase,
    );
  });

  tearDown(() {
    checklistBloc.close();
  });

  group('ChecklistBloc', () {
    test('initial state should be ChecklistInitial', () {
      expect(checklistBloc.state, const ChecklistInitial());
    });

    group('GenerateChecklistRequested', () {
      blocTest<ChecklistBloc, ChecklistState>(
        'emits [ChecklistLoading, ChecklistLoadSuccess] when use case succeeds',
        setUp: () {
          // Arrange: Stub the use case to return a successful result
          when(
            () => mockGenerateChecklistUsecase(tParams),
          ).thenAnswer((_) async => Right(tChecklist));
        },
        build: () => checklistBloc,
        act:
            (bloc) => bloc.add(
              const GenerateChecklistRequested(
                experience: 'Beginner',
                duration: '1-3 days',
                weather: 'Sunny',
              ),
            ),
        expect:
            () => [
              const ChecklistLoading(),
              ChecklistLoadSuccess(checklist: tChecklist),
            ],
        verify: (_) {
          // Assert: Ensure the use case was called with the correct parameters
          verify(() => mockGenerateChecklistUsecase(tParams)).called(1);
        },
      );

      blocTest<ChecklistBloc, ChecklistState>(
        'emits [ChecklistLoading, ChecklistLoadFailure] when use case fails',
        setUp: () {
          // Arrange: Stub the use case to return a failure
          final failure = MockFailure('Failed to generate checklist');
          when(
            () => mockGenerateChecklistUsecase(tParams),
          ).thenAnswer((_) async => Left(failure));
        },
        build: () => checklistBloc,
        act:
            (bloc) => bloc.add(
              const GenerateChecklistRequested(
                experience: 'Beginner',
                duration: '1-3 days',
                weather: 'Sunny',
              ),
            ),
        expect:
            () => [
              const ChecklistLoading(),
              const ChecklistLoadFailure(
                message: 'Failed to generate checklist',
              ),
            ],
        verify: (_) {
          verify(() => mockGenerateChecklistUsecase(tParams)).called(1);
        },
      );
    });

    group('ToggleChecklistItem', () {
      // Create the expected "after" state for the toggle test
      final tUpdatedChecklist = {
        'Essentials': [
          const CheckListEntity(
            id: 1,
            name: 'Backpack',
            checked: true,
          ), // This item is toggled
          const CheckListEntity(id: 2, name: 'Water Bottle', checked: false),
        ],
        'Clothing': [
          const CheckListEntity(id: 3, name: 'Hiking Boots', checked: false),
        ],
      };

      blocTest<ChecklistBloc, ChecklistState>(
        'emits updated ChecklistLoadSuccess when an item is toggled',
        // Arrange: Start the BLoC in a loaded state
        seed: () => ChecklistLoadSuccess(checklist: tChecklist),
        build: () => checklistBloc,
        act:
            (bloc) => bloc.add(
              const ToggleChecklistItem(category: 'Essentials', itemId: 1),
            ),
        expect: () => [ChecklistLoadSuccess(checklist: tUpdatedChecklist)],
      );

      blocTest<ChecklistBloc, ChecklistState>(
        'emits nothing when ToggleChecklistItem is called on a non-success state',
        // Arrange: Start the BLoC in an initial state
        seed: () => const ChecklistInitial(),
        build: () => checklistBloc,
        act:
            (bloc) => bloc.add(
              const ToggleChecklistItem(category: 'Essentials', itemId: 1),
            ),
        // Assert: No state should be emitted because of the `if (state is ...)` guard
        expect: () => [],
      );
    });

    group('ResetChecklist', () {
      blocTest<ChecklistBloc, ChecklistState>(
        'emits [ChecklistInitial] when ResetChecklist is added',
        // Arrange: Start from a loaded state to prove it resets
        seed: () => ChecklistLoadSuccess(checklist: tChecklist),
        build: () => checklistBloc,
        act: (bloc) => bloc.add(ResetChecklist()),
        expect: () => [const ChecklistInitial()],
      );
    });
  });
}
