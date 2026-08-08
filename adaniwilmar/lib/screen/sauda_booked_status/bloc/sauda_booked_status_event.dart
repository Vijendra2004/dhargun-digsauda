import 'package:equatable/equatable.dart';

abstract class SaudaBookedStatusEvent extends Equatable {
  const SaudaBookedStatusEvent();

  @override
  List<Object> get props => [];
}

class LoadSaudaBookedStatusScreen extends SaudaBookedStatusEvent {
  int userId = 0;
  String fromDate = "";
  String toDate = "";
  int bdoId=0;
  LoadSaudaBookedStatusScreen(
      {required this.userId, required this.fromDate, required this.toDate,this.bdoId=0});

  @override
  // TODO: implement props
  List<Object> get props => [userId, fromDate, toDate,bdoId];
}

class LoadOverallData extends SaudaBookedStatusEvent {
  int userId = 0;
  int dealerId = 0;
  LoadOverallData({required this.userId, required this.dealerId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, dealerId];
}

class LoadUserStatistics extends SaudaBookedStatusEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  LoadUserStatistics({required this.userId, required this.selectedMethod});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod];
}

class NotLoggedIn extends SaudaBookedStatusEvent {}
