import 'package:equatable/equatable.dart';

abstract class PendingContractEvent extends Equatable {
  const PendingContractEvent();

  @override
  List<Object> get props => [];
}

class LoadPendingContractScreen extends PendingContractEvent {
  int userId = 0;
  int salesOrganizationId = 0;
  int distributionChannelId = 0;
  int divisonId = 0;
  List<int> bdoIds = [];
  LoadPendingContractScreen(
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

class LoadPendingContractData extends PendingContractEvent {
  int userId = 0;
  int id = 0;
  List<int> skuIds = [];
  List<int> stateIds = [];
  LoadPendingContractData(
      {required this.userId,
      required this.id,
      required this.skuIds,
      required this.stateIds});

  @override
  // TODO: implement props
  List<Object> get props => [userId, id, skuIds, stateIds];
}

class LoadSalesOrganization extends PendingContractEvent {
  int id = 0;
  int saudaBookingTypeId = 0;
  LoadSalesOrganization({required this.id, required this.saudaBookingTypeId});

  @override
  // TODO: implement props
  List<Object> get props => [id, saudaBookingTypeId];
}

class LoadDistributionChannel extends PendingContractEvent {
  int id = 0;
  LoadDistributionChannel({
    required this.id,
  });

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class LoadVerticalList extends PendingContractEvent {
  int distributionId = 0;
  LoadVerticalList({
    required this.distributionId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [distributionId];
}

class LoadBDO extends PendingContractEvent {
  int userId = 0;
  LoadBDO({
    required this.userId,
  });
  @override
  // TODO: implement props
  List<Object> get props => [userId];
}

class LoadPendingContractFilter extends PendingContractEvent {
  int userId = 0;
  LoadPendingContractFilter({required this.userId});

  @override
  // TODO: implement props
  List<Object> get props => [userId];
}

class LoadActiveStates extends PendingContractEvent {
  int id = 0;
  LoadActiveStates({
    required this.id,
  });

  @override
  // TODO: implement props
  List<Object> get props => [id];
}
