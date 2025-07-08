import 'package:bloc/bloc.dart';
import 'package:trailmate_mobile_app_assignment/feature/checklist/domain/entity/checklist_item_entity.dart';

import '../../domain/usecase/generate_checklist_usecase.dart';
import 'checklist_event.dart';
import 'checklist_state.dart';

class ChecklistBloc extends Bloc<ChecklistEvent, ChecklistState> {
  final GenerateChecklist _generateChecklistUseCase;

  ChecklistBloc({required GenerateChecklist generateChecklistUseCase})
    : _generateChecklistUseCase = generateChecklistUseCase,
      super(const ChecklistInitial()) {
    // Register event handlers
    on<GenerateChecklistRequested>(_onGenerateChecklistRequested);
    on<ToggleChecklistItem>(_onToggleChecklistItem);
    on<ResetChecklist>(_onResetChecklist);
  }

  /// Handler for the GenerateChecklistRequested event
  Future<void> _onGenerateChecklistRequested(
    GenerateChecklistRequested event,
    Emitter<ChecklistState> emit,
  ) async {
    emit(const ChecklistLoading());

    final params = GenerateChecklistParams(
      experience: event.experience,
      duration: event.duration,
      weather: event.weather,
    );

    final result = await _generateChecklistUseCase(params);

    result.fold(
      (failure) => emit(ChecklistLoadFailure(message: failure.message)),
      (checklist) => emit(ChecklistLoadSuccess(checklist: checklist)),
    );
  }

  /// Handler for the ToggleChecklistItem event
  void _onToggleChecklistItem(
    ToggleChecklistItem event,
    Emitter<ChecklistState> emit,
  ) {
    // Ensure we can only toggle items when the list is successfully loaded
    if (state is ChecklistLoadSuccess) {
      final currentState = state as ChecklistLoadSuccess;
      final Map<String, List<CheckListEntity>> updatedChecklist = Map.from(
        currentState.checklist,
      );

      final categoryList = updatedChecklist[event.category];
      if (categoryList == null) return;

      final itemIndex = categoryList.indexWhere(
        (item) => item.id == event.itemId,
      );
      if (itemIndex != -1) {
        // Create a new list and update the specific item immutably
        final newList = List<CheckListEntity>.from(categoryList);
        final oldItem = newList[itemIndex];
        newList[itemIndex] = oldItem.copyWith(checked: !oldItem.checked);

        updatedChecklist[event.category] = newList;

        // Emit a new success state with the updated checklist
        emit(currentState.copyWith(checklist: updatedChecklist));
      }
    }
  }

  /// Handler for the ResetChecklist event
  void _onResetChecklist(ResetChecklist event, Emitter<ChecklistState> emit) {
    emit(const ChecklistInitial());
  }
}
