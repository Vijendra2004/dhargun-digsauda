import 'package:equatable/equatable.dart';

abstract class SalesOrderDetailEvent extends Equatable {
  const SalesOrderDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadSalesOrderDetailScreen extends SalesOrderDetailEvent {
  int userId = 0;
  int dealerId = 0;
  int statusId = 0;
  String fromDate = "";
  String toDate = "";
  bool isFilter = false;
  LoadSalesOrderDetailScreen(
      {required this.userId,
      required this.dealerId,
      required this.statusId,
      required this.fromDate,
      required this.toDate,
      required this.isFilter});

  @override
  // TODO: implement props
  List<Object> get props => [userId, dealerId, statusId, fromDate, toDate, isFilter];
}

class LoadOverallData extends SalesOrderDetailEvent {
  int userId = 0;
  int dealerId = 0;
  LoadOverallData({required this.userId, required this.dealerId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, dealerId];
}

class LoadUserStatistics extends SalesOrderDetailEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  LoadUserStatistics({required this.userId, required this.selectedMethod});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod];
}

class NotLoggedIn extends SalesOrderDetailEvent {}
