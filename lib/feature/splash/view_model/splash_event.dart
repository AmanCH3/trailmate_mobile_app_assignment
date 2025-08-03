import 'package:equatable/equatable.dart';

abstract class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object> get props => [];
}

// This event will be added from the UI to trigger the authentication check.
class CheckAuthenticationStatus extends SplashEvent {}
