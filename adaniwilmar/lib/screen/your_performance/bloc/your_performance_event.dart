import 'package:equatable/equatable.dart';

abstract class YourPerformanceEvent extends Equatable {
  const YourPerformanceEvent();

  @override
  List<Object> get props => [];
}

class LoadYourPerformanceScreen extends YourPerformanceEvent {
  int userId = 0;
  String fromDate = "";
  String toDate = "";
  int roleId = 0;
  bool isShowDealer = false;
  LoadYourPerformanceScreen(
      {required this.userId,
      required this.fromDate,
      required this.toDate,
      required this.roleId,
      required this.isShowDealer});

  @override
  // TODO: implement props
  List<Object> get props => [userId, fromDate, toDate, roleId, isShowDealer];
}

class LoadOverallData extends YourPerformanceEvent {
  int userId = 0;
  int dealerId = 0;
  LoadOverallData({required this.userId, required this.dealerId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, dealerId];
}

class LoadUserStatistics extends YourPerformanceEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  LoadUserStatistics({required this.userId, required this.selectedMethod});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod];
}

class NotLoggedIn extends YourPerformanceEvent {}
