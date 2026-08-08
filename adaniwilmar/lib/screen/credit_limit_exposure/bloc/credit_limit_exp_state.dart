import 'package:adaniwilmar/models/credit_limit_exposure_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class CreditLimitExposureState extends Equatable {
  const CreditLimitExposureState();
  @override
  List<Object> get props => [];
}

class InitialCreditLimitExposureState extends CreditLimitExposureState {}

class ShowProgressBar extends CreditLimitExposureState {}

class HideProgressBar extends CreditLimitExposureState {}

class OnSuccess extends CreditLimitExposureState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends CreditLimitExposureState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnLoadSuccess extends CreditLimitExposureState {
  final List<CreditLimitExposure> creditLimits;
  final List<CreditLimitExposure> creditExposure;
  const OnLoadSuccess(
      {required this.creditLimits, required this.creditExposure});

  @override
  // TODO: implement props
  List<Object> get props => [creditLimits, creditExposure];
}

class OnLoadCreditLimitExposure extends CreditLimitExposureState {
  final List<DistributorList> distributorList;
  const OnLoadCreditLimitExposure({required this.distributorList});

  @override
  // TODO: implement props
  List<Object> get props => [distributorList];
}
