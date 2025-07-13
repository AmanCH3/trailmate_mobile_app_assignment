import 'package:json_annotation/json_annotation.dart';

enum ExperienceLevel {
  @JsonValue('new')
  newbie,
  @JsonValue('experienced')
  experienced,
}

enum DurationLevel {
  @JsonValue('half-day')
  half_day,
  @JsonValue('full-day')
  full_day,
  @JsonValue('multi-day')
  multi_day,
}

enum WeatherLevel {
  @JsonValue('mild')
  mild,
  @JsonValue('hot')
  hot,
  @JsonValue('cold')
  cold,
  @JsonValue('rainy')
  rainy,
}

enum ItemCategory {
  @JsonValue('essentials')
  essentials,
  @JsonValue('clothing')
  clothing,
  @JsonValue('equipment')
  equipment,
  @JsonValue('advanced')
  advanced,
  @JsonValue('special')
  special,
}
