import 'package:equatable/equatable.dart';

class SenderEntity extends Equatable {
  final String? senderId;
  final String? name;
  final String? profileImage;

  const SenderEntity({this.senderId, this.name, this.profileImage});

  @override
  // TODO: implement props
  List<Object?> get props => [senderId, name, profileImage];
}
