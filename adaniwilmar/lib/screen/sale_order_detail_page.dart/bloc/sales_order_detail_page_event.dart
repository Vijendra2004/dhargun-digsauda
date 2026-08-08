import 'package:adaniwilmar/models/sales_order_approval_request.dart';
import 'package:equatable/equatable.dart';

abstract class SalesOrderDetailPageEvent extends Equatable {
  const SalesOrderDetailPageEvent();

  @override
  List<Object> get props => [];
}

class LoadSalesOrderDetailPageScreen extends SalesOrderDetailPageEvent {
  int userId = 0;
  int id = 0;
  LoadSalesOrderDetailPageScreen({required this.userId, required this.id});

  @override
  // TODO: implement props
  List<Object> get props => [userId, id];
}

class LoadOverallData extends SalesOrderDetailPageEvent {
  int userId = 0;
  int dealerId = 0;
  LoadOverallData({required this.userId, required this.dealerId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, dealerId];
}

class LoadUserStatistics extends SalesOrderDetailPageEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  LoadUserStatistics({required this.userId, required this.selectedMethod});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod];
}

class SaveSalesOrderApproval extends SalesOrderDetailPageEvent {
  SaveSalesOrderApprovalRequest request;
  SaveSalesOrderApproval({required this.request});

  @override
  // TODO: implement props
  List<Object> get props => [request];
}

class NotLoggedIn extends SalesOrderDetailPageEvent {}
