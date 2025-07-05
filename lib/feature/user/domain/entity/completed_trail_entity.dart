import 'package:equatable/equatable.dart';

class CompletedTrailEntity extends Equatable {
  final String trailId;
  final DateTime completedAt;

  const CompletedTrailEntity({
    required this.trailId,
    required this.completedAt,
  });

  @override
  List<Object?> get props => [trailId, completedAt];
}
