import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object> get props => [];
}

class InitialLoginState extends LoginState {}

class ShowProgressBar extends LoginState {}

class HideProgressBar extends LoginState {}

class OnSuccess extends LoginState {

}

class OnOTPSuccess extends LoginState {
  final int userId;
  OnOTPSuccess({required this.userId});
  @override
  // TODO: implement props
  List<Object> get props => [userId];
}

class OnFailure extends LoginState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}
