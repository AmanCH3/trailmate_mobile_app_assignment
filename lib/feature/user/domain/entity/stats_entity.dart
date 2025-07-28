import 'package:equatable/equatable.dart';

class StatsEntity extends Equatable {
  final int totalSteps;
  final int totalHikes;
  final double totalDistance;
  final double totalElevation;
  final double totalHours;
  final int hikesJoined;
  final int hikesLed;

  const StatsEntity({
    required this.totalSteps,
    required this.totalHikes,
    required this.totalDistance,
    required this.totalElevation,
    required this.totalHours,
    required this.hikesJoined,
    required this.hikesLed,
  });

  @override
  List<Object?> get props => [
    totalSteps,
    totalHikes,
    totalDistance,
    totalElevation,
    totalHours,
    hikesJoined,
    hikesLed,
  ];
}
