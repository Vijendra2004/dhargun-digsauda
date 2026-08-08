import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class LoggedIn extends AuthenticationEvent {
  final String token;

  const LoggedIn({required this.token});

  @override
  List<Object> get props => [token];

  @override
  String toString() => 'LoggedIn { token: $token }';
}

class CheckLoggedIn extends AuthenticationEvent {
  const CheckLoggedIn();

  @override
  List<Object> get props => [];
}

class LoggedOut extends AuthenticationEvent {}

class Authendicated extends AuthenticationEvent {}

class UnAuthendicated extends AuthenticationEvent {}
