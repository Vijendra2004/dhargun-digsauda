import 'package:equatable/equatable.dart';

abstract class ChequeStatusEvent extends Equatable {
  const ChequeStatusEvent();

  @override
  List<Object> get props => [];
}

class LoadChequeStatusScreen extends ChequeStatusEvent {
  int userId = 0;
  int salesOrganizationId = 0;
  int distributionChannelId = 0;
  int divisonId = 0;
  List<int> bdoIds = [];
  LoadChequeStatusScreen(
      {required this.userId,
      required this.salesOrganizationId,
      required this.distributionChannelId,
      required this.divisonId,
      this.bdoIds = const []});

  @override
  // TODO: implement props
  List<Object> get props =>
      [userId, salesOrganizationId, distributionChannelId, divisonId, bdoIds];
}

class LoadChequeStatusData extends ChequeStatusEvent {
  int userId = 0;
  List<int> bdoIds = [];
  List<int> dealerIds = [];
  LoadChequeStatusData(
      {required this.userId, required this.bdoIds, required this.dealerIds});

  @override
  // TODO: implement props
  List<Object> get props => [userId, bdoIds, dealerIds];
}

class LoadSalesOrganization extends ChequeStatusEvent {
  int id = 0;
  int saudaBookingTypeId = 0;
  LoadSalesOrganization({required this.id, required this.saudaBookingTypeId});

  @override
  // TODO: implement props
  List<Object> get props => [id, saudaBookingTypeId];
}

class LoadDistributionChannel extends ChequeStatusEvent {
  int id = 0;
  LoadDistributionChannel({
    required this.id,
  });

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class LoadVerticalList extends ChequeStatusEvent {
  int distributionId = 0;
  LoadVerticalList({
    required this.distributionId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [distributionId];
}

class LoadBDO extends ChequeStatusEvent {
  int userId = 0;
  LoadBDO({
    required this.userId,
  });
  @override
  // TODO: implement props
  List<Object> get props => [userId];
}
