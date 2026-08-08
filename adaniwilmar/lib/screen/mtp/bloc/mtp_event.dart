import 'package:equatable/equatable.dart';

abstract class MtpEvent extends Equatable {
  const MtpEvent();

  @override
  List<Object> get props => [];
}

class LoadMtpScreen extends MtpEvent {
  int userId = 0;

  LoadMtpScreen({
    required this.userId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [userId];
}

class LoadMtpViewScreen extends MtpEvent {
  int userId = 0;
  int id=0;

  LoadMtpViewScreen({
    required this.userId,
    required this.id
  });

  @override
  // TODO: implement props
  List<Object> get props => [userId,id];
}

class LoadOverallData extends MtpEvent {
  int userId = 0;
  int dealerId = 0;
  LoadOverallData({required this.userId, required this.dealerId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, dealerId];
}

class LoadUserStatistics extends MtpEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  LoadUserStatistics({required this.userId, required this.selectedMethod});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod];
}

class NotLoggedIn extends MtpEvent {}
