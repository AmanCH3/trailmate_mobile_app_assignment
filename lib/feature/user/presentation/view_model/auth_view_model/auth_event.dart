abstract class AuthEvent {}

class LogoutRequested extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});
}

class CheckAuthStatus extends AuthEvent {}
