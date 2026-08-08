import 'package:adaniwilmar/models/sauda_approval_request.dart';
import 'package:adaniwilmar/models/special_rate_approval_input.dart';
import 'package:equatable/equatable.dart';

abstract class SpecialRateApprovalManagerEvent extends Equatable {
  const SpecialRateApprovalManagerEvent();

  @override
  List<Object> get props => [];
}

class LoadSpecialRateApprovalManagerScreen
    extends SpecialRateApprovalManagerEvent {
  int userId = 0;
  String fromDate = "";
  String toDate = "";
  int bdoId = 0;
  int salesOrganizationId=0;
  int distributionChannelId=0;
  int divisionId=0;
  int statusId=0;
  LoadSpecialRateApprovalManagerScreen(
      {required this.userId,
      required this.fromDate,
      required this.toDate,
      required this.bdoId,
      required this.salesOrganizationId,
      required this.distributionChannelId,
      required this.divisionId,
      required this.statusId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, fromDate, toDate, bdoId,salesOrganizationId,distributionChannelId,divisionId,statusId];
}

class LoadBdoList extends SpecialRateApprovalManagerEvent {
  int userId = 0;
  LoadBdoList({required this.userId});

  @override
  // TODO: implement props
  List<Object> get props => [userId];
}

class LoadSalesOrganization extends SpecialRateApprovalManagerEvent {
  int id = 0;
  int saudaBookingTypeId = 0;
  LoadSalesOrganization({required this.id, required this.saudaBookingTypeId});

  @override
  // TODO: implement props
  List<Object> get props => [id, saudaBookingTypeId];
}

class LoadDistributionChannel extends SpecialRateApprovalManagerEvent {
  int id = 0;
  LoadDistributionChannel({
    required this.id,
  });

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class LoadVerticalList extends SpecialRateApprovalManagerEvent {
  int distributionId = 0;
  LoadVerticalList({
    required this.distributionId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [distributionId];
}

class SaveApproval extends SpecialRateApprovalManagerEvent {
  SpecialRateManagerRequest request;
  SaveApproval({required this.request});

  @override
  // TODO: implement props
  List<Object> get props => [request];
}

class NotLoggedIn extends SpecialRateApprovalManagerEvent {}
