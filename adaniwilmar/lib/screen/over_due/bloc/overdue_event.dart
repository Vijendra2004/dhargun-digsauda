import 'package:equatable/equatable.dart';

abstract class OverDueEvent extends Equatable {
  const OverDueEvent();

  @override
  List<Object> get props => [];
}

class LoadOverDueScreen extends OverDueEvent {
  int userId = 0;
  int bdoId=0;

  LoadOverDueScreen({
    required this.userId,
    this.bdoId=0
  });

  @override
  // TODO: implement props
  List<Object> get props => [userId,bdoId];
}

class LoadOverallData extends OverDueEvent {
  int userId = 0;
  int dealerId = 0;
  int bdoId=0;
  int statusId=0;
  LoadOverallData({required this.userId, required this.dealerId,this.statusId=0});

  @override
  // TODO: implement props
  List<Object> get props => [userId, dealerId,statusId];
}

class LoadUserStatistics extends OverDueEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  LoadUserStatistics({required this.userId, required this.selectedMethod});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod];
}

class NotLoggedIn extends OverDueEvent {}
