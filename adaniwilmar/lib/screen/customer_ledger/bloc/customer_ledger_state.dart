import 'package:adaniwilmar/models/call_to_customer_model.dart';
import 'package:adaniwilmar/models/customer_ledger_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/screen/customer_ledger/bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/customerLedgerNHResponse.dart';

abstract class CustomerLedgerState extends Equatable {
  const CustomerLedgerState();

  @override
  List<Object> get props => [];
}

class InitialCustomerLedgerState extends CustomerLedgerState {}

class ShowProgressBar extends CustomerLedgerState {}

class HideProgressBar extends CustomerLedgerState {}

// class OnSuccess extends CustomerLedgerState {
//   final WeeklyResponse response;
//   const OnSuccess({required this.response});
//
//   @override
//   // TODO: implement props
//   List<Object> get props => [response];
// }

class OnFailure extends CustomerLedgerState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnSaveSuccess extends CustomerLedgerState {
  final String mobileNumber;

  OnSaveSuccess({required this.mobileNumber});

  @override
  // TODO: implement props
  List<Object> get props => [mobileNumber];
}

// class OnOverallSuccess extends CustomerLedgerState {
//   final DueForTomorrowList response;
//   const OnOverallSuccess({required this.response});
//
//   @override
//   // TODO: implement props
//   List<Object> get props => [response];
// }

class OnLoadSuccess extends CustomerLedgerState {
  final LedgerInfo ledgerInfo;
  final List<DistributorList> distributorList;

  const OnLoadSuccess(
      {required this.ledgerInfo, required this.distributorList});

  @override
  // TODO: implement props
  List<Object> get props => [ledgerInfo, distributorList];
}

class OnLedgerDataSuccess extends CustomerLedgerState {
  final LedgerInfo ledgerInfo;

  const OnLedgerDataSuccess({required this.ledgerInfo});

  @override
  // TODO: implement props
  List<Object> get props => [ledgerInfo];
}

class OnLoadCallToCustomerSuccess extends CustomerLedgerState {
  final List<CallToCustomerList> distributorList;

  const OnLoadCallToCustomerSuccess({required this.distributorList});

  @override
  // TODO: implement props
  List<Object> get props => [distributorList];
}

class OnLoadCustomerLedgerSuccess extends CustomerLedgerState {
  final CustomerLedgerNHResponse customerLedgerNHResponse;

  const OnLoadCustomerLedgerSuccess({required this.customerLedgerNHResponse});

  @override
  List<Object> get props => [customerLedgerNHResponse];
}
