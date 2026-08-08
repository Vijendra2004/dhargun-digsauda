import 'package:equatable/equatable.dart';

import '../../../models/AccountStatementRequest.dart';
import '../../../models/AccountStatementResponse.dart';

class AccountStatementEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AccountDataEvent extends AccountStatementEvent {
  AccountDataEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AccountStatementCountEvent extends AccountStatementEvent {
  AccountStatementCountEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CustomerStatementEvent extends AccountStatementEvent {
  CustomerStatement customerStatement;

  CustomerStatementEvent({
    required this.customerStatement,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [customerStatement];
}

class AccountStatementStatusUpdate extends AccountStatementEvent {
  int requestId = 0;

  AccountStatementStatusUpdate({
    required this.requestId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [requestId];
}

class AccountStatementSubmit extends AccountStatementEvent {
  AccountStatementRequest? accountStatementRequest;

  AccountStatementSubmit({
    required this.accountStatementRequest,
  });

  @override
  // TODO: implement props
  List<Object> get props => [accountStatementRequest!];
}
