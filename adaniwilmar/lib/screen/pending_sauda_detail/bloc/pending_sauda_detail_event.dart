import 'package:equatable/equatable.dart';

abstract class PendingSaudaDetailEvent extends Equatable {
  const PendingSaudaDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadPendingSaudaDetailSalesScreen extends PendingSaudaDetailEvent {
  int userId = 0;
  List<int> bdoIds = [];
  List<int> dealerIds = [];
  int creditId = 1;

  LoadPendingSaudaDetailSalesScreen(
      {required this.userId,
      required this.bdoIds,
      required this.dealerIds,
      required this.creditId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, bdoIds, dealerIds, creditId];
}

class LoadSalesScreen extends PendingSaudaDetailEvent {
  int userId = 0;
  int dealerId = 0;
  int statusId = 0;
  String fromDate = "";
  String toDate = "";
  int packGroupId = 0;

  LoadSalesScreen(
      {required this.userId,
      required this.dealerId,
      required this.statusId,
      required this.fromDate,
      required this.toDate,
      required this.packGroupId});

  @override
  // TODO: implement props
  List<Object> get props =>
      [userId, dealerId, statusId, fromDate, toDate, packGroupId];
}

class LoadDealerDetail extends PendingSaudaDetailEvent {
  int id = 0;
  int salesOrgId = 0;
  int distributionId = 0;
  int divisionId = 0;

  LoadDealerDetail(
      {required this.id,
      required this.salesOrgId,
      required this.distributionId,
      required this.divisionId});

  @override
  // TODO: implement props
  List<Object> get props => [id, salesOrgId, distributionId, divisionId];
}

class LoadDealerSaudaList extends PendingSaudaDetailEvent {
  int id = 0;
  int salesOrgId = 0;
  int distributionId = 0;
  int divisionId = 0;
  String fromDate = "";
  String toDate = "";

  LoadDealerSaudaList(
      {required this.id,
      required this.salesOrgId,
      required this.distributionId,
      required this.divisionId,
      required this.fromDate,
      required this.toDate});

  @override
  // TODO: implement props
  List<Object> get props =>
      [id, salesOrgId, distributionId, divisionId, fromDate, toDate];
}

class LoadDealerSalesList extends PendingSaudaDetailEvent {
  int id = 0;
  int salesOrgId = 0;
  int distributionId = 0;
  int divisionId = 0;
  String fromDate = "";
  String toDate = "";

  LoadDealerSalesList(
      {required this.id,
      required this.salesOrgId,
      required this.distributionId,
      required this.divisionId,
      required this.fromDate,
      required this.toDate});

  @override
  // TODO: implement props
  List<Object> get props =>
      [id, salesOrgId, distributionId, divisionId, fromDate, toDate];
}

class LoadPendingSaudaDetailList extends PendingSaudaDetailEvent {
  int userId = 0;

  LoadPendingSaudaDetailList({required this.userId});

  @override
  // TODO: implement props
  List<Object> get props => [userId];
}

class LoadSalesOrganization extends PendingSaudaDetailEvent {
  int id = 0;
  int saudaBookingTypeId = 0;

  LoadSalesOrganization({required this.id, required this.saudaBookingTypeId});

  @override
  // TODO: implement props
  List<Object> get props => [id, saudaBookingTypeId];
}

class LoadDistributionChannel extends PendingSaudaDetailEvent {
  int id = 0;

  LoadDistributionChannel({
    required this.id,
  });

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class LoadVerticalList extends PendingSaudaDetailEvent {
  int distributionId = 0;

  LoadVerticalList({
    required this.distributionId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [distributionId];
}

class DelayEvent extends PendingSaudaDetailEvent {
  int id = 0;

  DelayEvent({
    required this.id,
  });

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class NotLoggedIn extends PendingSaudaDetailEvent {}
