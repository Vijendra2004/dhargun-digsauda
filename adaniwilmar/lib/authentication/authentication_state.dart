import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  @override
  List<Object> get props => [];
}

class AuthenticationUninitialized extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {}

class AuthenticationUnauthenticated extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AppExitDialog extends AuthenticationState {}

class CheckLoggedInState extends AuthenticationState {
  final bool loggedIn;

  const CheckLoggedInState({this.loggedIn=false});

  @override
  // TODO: implement props
  List<Object> get props => [loggedIn];
}