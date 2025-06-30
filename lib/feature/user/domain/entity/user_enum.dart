import 'package:json_annotation/json_annotation.dart';

enum HikerType {
  @JsonValue('new')
  newbie,
  @JsonValue('experienced')
  experienced,
}

enum AgeGroup {
  @JsonValue('18-24')
  age18to24,
  @JsonValue('24-35')
  age24to35,
  @JsonValue('35-44')
  age35to44,
  @JsonValue('45-54')
  age45to54,
  @JsonValue('55-64')
  age55to64,
  @JsonValue('65+')
  age65plus,
}

enum Role {
  @JsonValue('user')
  user,
  @JsonValue('guide')
  guide,
  @JsonValue('admin')
  admin,
}

enum Subscription {
  @JsonValue('basic')
  basic,
  @JsonValue('pro')
  pro,
  @JsonValue('premium')
  premium,
}
