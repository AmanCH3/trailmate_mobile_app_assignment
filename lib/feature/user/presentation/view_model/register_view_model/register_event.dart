import 'package:flutter/cupertino.dart';

@immutable
sealed class RegisterEvent {}

class NavigateToLoginEvent extends RegisterEvent {
  final BuildContext context;

  NavigateToLoginEvent({required this.context});
}

class RegisterUserEvent extends RegisterEvent {
  final BuildContext context;

  final String name;
  final String password;
  final String email;
  final String phone;

  RegisterUserEvent({
    required this.context,
    required this.name,
    required this.password,
    required this.phone,
    required this.email,
  });
}

class ShowHidePassword extends RegisterEvent {
  final BuildContext context;
  final bool isVisible;

  ShowHidePassword({required this.context, required this.isVisible});
}
