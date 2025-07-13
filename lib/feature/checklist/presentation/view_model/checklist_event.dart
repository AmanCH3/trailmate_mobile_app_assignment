import 'package:equatable/equatable.dart';

abstract class ChecklistEvent extends Equatable {
  const ChecklistEvent();

  @override
  List<Object> get props => [];
}

/// Event triggered when the user clicks the "Generate Checklist" button.
class GenerateChecklistRequested extends ChecklistEvent {
  final String experience;
  final String duration;
  final String weather;

  const GenerateChecklistRequested({
    required this.experience,
    required this.duration,
    required this.weather,
  });

  @override
  List<Object> get props => [experience, duration, weather];
}

class ToggleChecklistItem extends ChecklistEvent {
  final String category;
  final int itemId;

  const ToggleChecklistItem({required this.category, required this.itemId});

  @override
  List<Object> get props => [category, itemId];
}

class ResetChecklist extends ChecklistEvent {}
