import 'package:adaniwilmar/models/sales_report_response.dart';
import 'package:equatable/equatable.dart';
import '../../../models/special_rate_view_response.dart';

abstract class SecondarySalesState extends Equatable {
  const SecondarySalesState();
  @override
  List<Object> get props => [];
}

class InitialSecondarySalesState extends SecondarySalesState {}

class ShowProgressBar extends SecondarySalesState {}

class HideProgressBar extends SecondarySalesState {}

class OnSuccess extends SecondarySalesState {
  final SpecialRateView response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends SecondarySalesState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends SecondarySalesState {
  final SpecialRateView response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends SecondarySalesState {
  final List<SecondarySalesFortheDayViewDto> secondarySales;
  const OnLoadSuccess({required this.secondarySales});

  @override
  // TODO: implement props
  List<Object> get props => [secondarySales];
}
