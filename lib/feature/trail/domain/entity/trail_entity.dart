import 'package:equatable/equatable.dart';

class TrailEnitiy extends Equatable {
  final String? trailId;
  final String name;
  final String location;
  final double duration;
  final double? distance;
  final double elevation;
  final String difficult;
  final String image;
  final String description;

  const TrailEnitiy({
    this.trailId,
    required this.name,
    required this.location,
    required this.duration,
    required this.distance,
    required this.elevation,
    required this.difficult,
    required this.image,
    required this.description,
  });

  @override
  List<Object?> get props => [
    trailId,
    name,
    location,
    duration,
    elevation,
    difficult,
    image,
    distance,
    description,
  ];
}
