import 'package:equatable/equatable.dart';

class EmergencyContactEntity extends Equatable {
  final String name;
  final String phone;

  const EmergencyContactEntity({required this.name, required this.phone});

  @override
  List<Object?> get props => [name, phone];
}
