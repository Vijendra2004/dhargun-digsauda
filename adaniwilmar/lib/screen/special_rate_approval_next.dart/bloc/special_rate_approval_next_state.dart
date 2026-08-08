import 'package:equatable/equatable.dart';
import '../../../models/special_rate_view_response.dart';

abstract class SpecialRateApprovalViewState extends Equatable {
  const SpecialRateApprovalViewState();
  @override
  List<Object> get props => [];
}

class InitialSpecialRateApprovalViewState extends SpecialRateApprovalViewState {
}

class ShowProgressBar extends SpecialRateApprovalViewState {}

class HideProgressBar extends SpecialRateApprovalViewState {}

class OnSuccess extends SpecialRateApprovalViewState {
  final SpecialRateView response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends SpecialRateApprovalViewState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends SpecialRateApprovalViewState {
  final SpecialRateView response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends SpecialRateApprovalViewState {
  final SpecialRateView sprateInfo;
  const OnLoadSuccess({required this.sprateInfo});

  @override
  // TODO: implement props
  List<Object> get props => [sprateInfo];
}
