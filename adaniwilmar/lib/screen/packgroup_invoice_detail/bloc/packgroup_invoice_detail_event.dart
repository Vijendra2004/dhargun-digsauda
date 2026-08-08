import 'package:equatable/equatable.dart';

abstract class PackGroupInvoiceDetailEvent extends Equatable {
  const PackGroupInvoiceDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadPackGroupInvoiceDetailScreen extends PackGroupInvoiceDetailEvent {
  int userId = 0;
  int id = 0;
  bool isPendingSauda = false;
  bool isBulkPack = false;
  LoadPackGroupInvoiceDetailScreen(
      {required this.userId,
      required this.id,
      required this.isBulkPack,
      this.isPendingSauda = false});

  @override
  // TODO: implement props
  List<Object> get props => [userId, id, isBulkPack, isPendingSauda];
}

class LoadOverallData extends PackGroupInvoiceDetailEvent {
  int userId = 0;
  int dealerId = 0;
  LoadOverallData({required this.userId, required this.dealerId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, dealerId];
}

class LoadUserStatistics extends PackGroupInvoiceDetailEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  LoadUserStatistics({required this.userId, required this.selectedMethod});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod];
}

class NotLoggedIn extends PackGroupInvoiceDetailEvent {}
