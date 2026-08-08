import 'package:equatable/equatable.dart';

abstract class CustomerLedgerEvent extends Equatable {
  const CustomerLedgerEvent();

  @override
  List<Object> get props => [];
}

class LoadCustomerLedgerScreen extends CustomerLedgerEvent {
  int userId = 0;
  String dealerId = "0";
  List<int> bdoIds = [];
  int zhId = 0;

  LoadCustomerLedgerScreen({required this.userId,
    required this.dealerId,
    this.bdoIds = const [],
    this.zhId = 0});

  @override
  // TODO: implement props
  List<Object> get props => [userId, dealerId, bdoIds, zhId];
}

class LoadCallToCustomer extends CustomerLedgerEvent {
  int userId = 0;
  int dealerId = 0;
  List<int> bdoIds = [];
  int zhId = 0;

  LoadCallToCustomer({required this.userId,
    required this.dealerId,
    this.bdoIds = const [],
    this.zhId = 0});

  @override
  // TODO: implement props
  List<Object> get props => [userId, dealerId, bdoIds, zhId];
}

class LoadLedgerData extends CustomerLedgerEvent {
  int userId = 0;
  String dealerId = "0";

  LoadLedgerData({required this.userId, required this.dealerId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, dealerId];
}

class SaveCallToCustomer extends CustomerLedgerEvent {
  int BDOId = 0;
  String dealerMobileNumber = "";
  int dealerId = 0;

  SaveCallToCustomer({required this.BDOId,
    required this.dealerMobileNumber,
    required this.dealerId});

  @override
  // TODO: implement props
  List<Object> get props => [BDOId, dealerMobileNumber, dealerId];
}

class LoadCustomerLedgerNH extends CustomerLedgerEvent {
  int userId = 0;

  LoadCustomerLedgerNH({ required this.userId});

  @override
  List<Object> get props => [userId];

}

class NotLoggedIn extends CustomerLedgerEvent {}
