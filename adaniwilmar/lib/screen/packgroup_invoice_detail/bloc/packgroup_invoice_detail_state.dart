import 'package:adaniwilmar/models/due_for_tomorrow_response.dart';
import 'package:adaniwilmar/models/invoice_detail_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class PackGroupInvoiceDetailState extends Equatable {
  const PackGroupInvoiceDetailState();
  @override
  List<Object> get props => [];
}

class InitialPackGroupInvoiceDetailState extends PackGroupInvoiceDetailState {}

class ShowProgressBar extends PackGroupInvoiceDetailState {}

class HideProgressBar extends PackGroupInvoiceDetailState {}

class OnSuccess extends PackGroupInvoiceDetailState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends PackGroupInvoiceDetailState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends PackGroupInvoiceDetailState {
  final DueForTomorrowList response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends PackGroupInvoiceDetailState {
  final InvoiceDetail invoiceResponse;
  const OnLoadSuccess({required this.invoiceResponse});

  @override
  // TODO: implement props
  List<Object> get props => [invoiceResponse];
}
