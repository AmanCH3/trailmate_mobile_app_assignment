import 'package:equatable/equatable.dart';

class CheckListEntity extends Equatable {
  final int id;
  final String name;
  final bool checked;

  const CheckListEntity({
    required this.id,
    required this.name,
    required this.checked,
  });

  CheckListEntity copyWith({int? id, String? name, bool? checked}) {
    return CheckListEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      checked: checked ?? this.checked,
    );
  }

  @override
  List<Object?> get props => [id, name, checked];
}
