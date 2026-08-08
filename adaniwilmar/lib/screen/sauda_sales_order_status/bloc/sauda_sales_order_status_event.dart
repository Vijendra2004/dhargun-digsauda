import 'package:equatable/equatable.dart';

abstract class SaudaSalesOrderStatusEvent extends Equatable {
  const SaudaSalesOrderStatusEvent();

  @override
  List<Object> get props => [];
}

class LoadSaudaSalesOrderStatusScreen extends SaudaSalesOrderStatusEvent {
  int userId = 0;
  int bdoId = 0;
  int statusId = 0;
  LoadSaudaSalesOrderStatusScreen(
      {required this.userId, required this.bdoId, required this.statusId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, bdoId, statusId];
}

class LoadOverallData extends SaudaSalesOrderStatusEvent {
  int userId = 0;
  int dealerId = 0;
  LoadOverallData({required this.userId, required this.dealerId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, dealerId];
}

class LoadUserStatistics extends SaudaSalesOrderStatusEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  LoadUserStatistics({required this.userId, required this.selectedMethod});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod];
}

class NotLoggedIn extends SaudaSalesOrderStatusEvent {}
