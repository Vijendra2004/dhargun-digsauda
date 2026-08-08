import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginButtonPressed extends LoginEvent {
  String mobileNumber = "";
  String password = "";
  int verticalId = 0;
  bool isRequestFromWeb = false;
  String email = "";

  LoginButtonPressed({
    required this.mobileNumber,
    required this.password,
    required this.verticalId,
    required this.isRequestFromWeb,
    required this.email,
  });

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoginOutEvent extends LoginEvent {
  int userId = 0;

  LoginOutEvent({
    required this.userId
  });

  @override
  // TODO: implement props
  List<Object> get props => [userId];
}

class ForgotPassordOTP extends LoginEvent {
  String mobileNumber = "";

  ForgotPassordOTP({
    required this.mobileNumber,
  });

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ResendForgotPassordOTP extends LoginEvent {
  int userId;

  ResendForgotPassordOTP({
    required this.userId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ForgotPasswordSubmit extends LoginEvent {
  int userId = 0;
  String password = "";
  String otpNumber = "";

  ForgotPasswordSubmit({
    required this.userId,
    required this.password,
    required this.otpNumber
  });

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class NotLoggedIn extends LoginEvent {}
