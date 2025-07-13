import 'package:equatable/equatable.dart';
import 'package:trailmate_mobile_app_assignment/feature/checklist/domain/entity/checklist_item_entity.dart';

abstract class ChecklistState extends Equatable {
  const ChecklistState();

  @override
  List<Object> get props => [];
}

/// The initial state before any action is taken.
class ChecklistInitial extends ChecklistState {
  const ChecklistInitial();
}

/// State when the checklist is being fetched from the API.
class ChecklistLoading extends ChecklistState {
  const ChecklistLoading();
}

/// State when the checklist has been successfully loaded.
class ChecklistLoadSuccess extends ChecklistState {
  final Map<String, List<CheckListEntity>> checklist;

  const ChecklistLoadSuccess({required this.checklist});

  /// Helper to create a new state with updated data, promoting immutability.
  ChecklistLoadSuccess copyWith({
    Map<String, List<CheckListEntity>>? checklist,
  }) {
    return ChecklistLoadSuccess(checklist: checklist ?? this.checklist);
  }

  @override
  List<Object> get props => [checklist];
}

/// State when an error occurred while fetching the checklist.
class ChecklistLoadFailure extends ChecklistState {
  final String message;

  const ChecklistLoadFailure({required this.message});

  @override
  List<Object> get props => [message];
}
