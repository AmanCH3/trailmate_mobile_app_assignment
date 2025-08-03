import 'package:equatable/equatable.dart';

enum AuthStatus { initial, authenticated, unauthenticated }

class SplashState extends Equatable {
  final AuthStatus status;

  const SplashState({required this.status});

  // The factory constructor provides a clean way to get the initial state.
  factory SplashState.initial() {
    return const SplashState(status: AuthStatus.initial);
  }

  @override
  List<Object?> get props => [status];

  SplashState copyWith({AuthStatus? status}) {
    return SplashState(status: status ?? this.status);
  }
}
