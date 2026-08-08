import 'package:equatable/equatable.dart';

abstract class SalesEvent extends Equatable {
  const SalesEvent();

  @override
  List<Object> get props => [];
}

class LoadSalesScreen extends SalesEvent {
  int userId = 0;
  String fromDate = "";
  String toDate = "";
  bool isBulkPack = false;
  String selectedMethod = "MTD";
  LoadSalesScreen(
      {required this.userId,
      required this.fromDate,
      required this.toDate,
      required this.isBulkPack,
      this.selectedMethod = "MTD"});

  @override
  // TODO: implement props
  List<Object> get props =>
      [userId, fromDate, toDate, isBulkPack, selectedMethod];
}

class LoadSalesChart extends SalesEvent {
  int userId = 0;
  String fromDate = "";
  String toDate = "";
  bool isBulkPack = false;
  String selectedMethod = "MTD";
  LoadSalesChart(
      {required this.userId,
      required this.fromDate,
      required this.toDate,
      required this.isBulkPack,
      this.selectedMethod = "MTD"});

  @override
  // TODO: implement props
  List<Object> get props =>
      [userId, fromDate, toDate, isBulkPack, selectedMethod];
}

class LoadDealerSales extends SalesEvent {
  int userId = 0;
  String fromDate = "";
  String toDate = "";
  bool isBulkPack = false;
  String selectedMethod = "MTD";
  LoadDealerSales(
      {required this.userId,
      required this.fromDate,
      required this.toDate,
      required this.isBulkPack,
      this.selectedMethod = "MTD"});

  @override
  // TODO: implement props
  List<Object> get props =>
      [userId, fromDate, toDate, isBulkPack, selectedMethod];
}

class LoadSalesList extends SalesEvent {
  int userId = 0;
  LoadSalesList({required this.userId});

  @override
  // TODO: implement props
  List<Object> get props => [userId];
}

class NotLoggedIn extends SalesEvent {}
