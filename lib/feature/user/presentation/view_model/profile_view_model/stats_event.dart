// lib/feature/user/presentation/view_model/profile_view_model/stats_event.dart
import 'package:equatable/equatable.dart';

sealed class StatsEvent extends Equatable {
  const StatsEvent();

  @override
  List<Object> get props => [];
}

class InitializePedometer extends StatsEvent {}

class StartHikeTracking extends StatsEvent {}

class StopHikeTracking extends StatsEvent {}
