import 'package:adaniwilmar/models/dealer_invoice_response.dart';
import 'package:adaniwilmar/models/due_for_tomorrow_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class PackGroupDetailDetailState extends Equatable {
  const PackGroupDetailDetailState();
  @override
  List<Object> get props => [];
}

class InitialPackGroupDetailDetailState extends PackGroupDetailDetailState {}

class ShowProgressBar extends PackGroupDetailDetailState {}

class HideProgressBar extends PackGroupDetailDetailState {}

class OnSuccess extends PackGroupDetailDetailState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends PackGroupDetailDetailState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends PackGroupDetailDetailState {
  final DueForTomorrowList response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends PackGroupDetailDetailState {
  final DealerInvoices dealerInvoiceResponse;
  const OnLoadSuccess({required this.dealerInvoiceResponse});

  @override
  // TODO: implement props
  List<Object> get props => [dealerInvoiceResponse];
}
