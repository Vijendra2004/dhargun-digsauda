import 'package:equatable/equatable.dart';
import '../../../models/special_rate_view_response.dart';

abstract class SpecialRateApprovalState extends Equatable {
  const SpecialRateApprovalState();
  @override
  List<Object> get props => [];
}

class InitialSpecialRateApprovalState extends SpecialRateApprovalState {}

class ShowProgressBar extends SpecialRateApprovalState {}

class HideProgressBar extends SpecialRateApprovalState {}

class OnSuccess extends SpecialRateApprovalState {
  final SpecialRateView response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends SpecialRateApprovalState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends SpecialRateApprovalState {
  final SpecialRateView response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends SpecialRateApprovalState {
  final List<SpecialRateResponse> sprateInfo;
  const OnLoadSuccess({required this.sprateInfo});

  @override
  // TODO: implement props
  List<Object> get props => [sprateInfo];
}

class OnLoadDealerSuccess extends SpecialRateApprovalState {
  final List<SpecialRateList> sprateInfo;
  const OnLoadDealerSuccess({required this.sprateInfo});

  @override
  // TODO: implement props
  List<Object> get props => [sprateInfo];
}
