import 'package:adaniwilmar/models/sauda_approval_request.dart';
import 'package:equatable/equatable.dart';

abstract class SaudaApprovalEvent extends Equatable {
  const SaudaApprovalEvent();

  @override
  List<Object> get props => [];
}

class LoadSaudaApprovalScreen extends SaudaApprovalEvent {
  int userId = 0;
  String fromDate = "";
  String toDate = "";
  int salesOrganizationId = 0;
  int statusId = 0;
  int pageNo = 0;
  int distributionChannelId = 0;
  int divisionId = 0;
  LoadSaudaApprovalScreen(
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

class LoadSalesOrganization extends SaudaApprovalEvent {
  int id = 0;
  int saudaBookingTypeId = 0;
  LoadSalesOrganization({required this.id, required this.saudaBookingTypeId});

  @override
  // TODO: implement props
  List<Object> get props => [id, saudaBookingTypeId];
}

class LoadDistributionChannel extends SaudaApprovalEvent {
  int id = 0;
  LoadDistributionChannel({
    required this.id,
  });

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class LoadVerticalList extends SaudaApprovalEvent {
  int distributionId = 0;
  LoadVerticalList({
    required this.distributionId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [distributionId];
}

class SaveApproval extends SaudaApprovalEvent {
  SaudaApprovalRequest request;
  SaveApproval({required this.request});

  @override
  // TODO: implement props
  List<Object> get props => [request];
}

class NotLoggedIn extends SaudaApprovalEvent {}
