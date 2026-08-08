import 'package:equatable/equatable.dart';

import '../../../../models/SaudaModApprovalRequest.dart';

abstract class SaudaModApprovalEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSaudaModApproval extends SaudaModApprovalEvent {
  int userId = 0;
  String fromDate = "";
  String toDate = "";
  int salesOrganizationId = 0;
  int statusId = 0;
  int pageNo = 0;
  int distributionChannelId = 0;
  int divisionId = 0;
LoadSaudaModApproval(
      {required this.userId,
        required this.fromDate,
        required this.toDate,
        required this.salesOrganizationId,
        required this.statusId,
        required this.pageNo,
        required this.distributionChannelId,
        required this.divisionId});

  @override
  // TODO: implement props
  List<Object> get props => [
    userId,
    fromDate,
    toDate,
    salesOrganizationId,
    statusId,
    pageNo,
    this,
    distributionChannelId,
    divisionId
  ];
}


class LoadModDistributionChannel extends SaudaModApprovalEvent {
  int id = 0;
  LoadModDistributionChannel({
    required this.id,
  });

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class LoadModVerticalList extends SaudaModApprovalEvent {
  int distributionId = 0;
  LoadModVerticalList({
    required this.distributionId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [distributionId];
}

class LoadModSalesOrganization extends SaudaModApprovalEvent {
  int id = 0;
  int saudaBookingTypeId = 0;
  LoadModSalesOrganization({required this.id, required this.saudaBookingTypeId});

  @override
  // TODO: implement props
  List<Object> get props => [id, saudaBookingTypeId];
}

class ApproveRejectSaudaModApproval extends SaudaModApprovalEvent {

  final SaudaModApprovalRequest saudaModApprovalRequest;

  ApproveRejectSaudaModApproval({
    required this.saudaModApprovalRequest,
  });

  @override
  List<Object?> get props => [saudaModApprovalRequest];
}