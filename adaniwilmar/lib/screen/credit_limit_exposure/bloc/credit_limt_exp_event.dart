import 'package:equatable/equatable.dart';

abstract class CreditLimitExposureEvent extends Equatable {
  const CreditLimitExposureEvent();

  @override
  List<Object> get props => [];
}

class LoadCreditLimitExposureSalesScreen extends CreditLimitExposureEvent {
  int userId = 0;
  List<int> bdoIds = [];
  List<int> dealerIds = [];
  int creditId = 1;
  LoadCreditLimitExposureSalesScreen(
      {required this.userId,
      required this.bdoIds,
      required this.dealerIds,
      required this.creditId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, bdoIds, dealerIds, creditId];
}

class LoadCreditLimitExposureList extends CreditLimitExposureEvent {
  int userId = 0;
  LoadCreditLimitExposureList({required this.userId});

  @override
  // TODO: implement props
  List<Object> get props => [userId];
}

class NotLoggedIn extends CreditLimitExposureEvent {}
