import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../models/AccountStatementResponse.dart';

@immutable
class AccountStatementState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AccountStatementInitial extends AccountStatementState {}

class AccountStatementLoadProgress extends AccountStatementState {}

class AccountStatementHideProgress extends AccountStatementState {}

class AccountStatementCountUpdate extends AccountStatementState {}

class AccountStatementSubmitResponse extends AccountStatementState {}


class LoadAccountStatementData extends AccountStatementState {
  AccountStatementDataModel response;
  LoadAccountStatementData({required this.response});

  @override
  List<Object?> get props => [response];
}

class LoanAccountStatementDataCount extends AccountStatementState {
  AccountStatementsResponse response;
  LoanAccountStatementDataCount({required this.response});

  @override
  List<Object?> get props => [response];
}


