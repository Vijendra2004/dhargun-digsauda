import 'package:equatable/equatable.dart';

abstract class StpEvent extends Equatable {
  const StpEvent();

  @override
  List<Object> get props => [];
}

class LoadStpScreen extends StpEvent {
  int userId = 0;
  int financialYearId = 0;
  String fromDate = "";
  String toDate = "";

  LoadStpScreen(
      {required this.userId,
      required this.financialYearId,
      required this.fromDate,
      required this.toDate});

  @override
  // TODO: implement props
  List<Object> get props => [userId, financialYearId, fromDate, toDate];
}

class LoadOverallData extends StpEvent {
  int userId = 0;
  int dealerId = 0;
  LoadOverallData({required this.userId, required this.dealerId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, dealerId];
}

class LoadUserStatistics extends StpEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  LoadUserStatistics({required this.userId, required this.selectedMethod});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod];
}

class NotLoggedIn extends StpEvent {}
