import 'package:adaniwilmar/models/SaudaDetailModel.dart';
import 'package:adaniwilmar/models/SaudaModApprovalModel.dart';
import 'package:adaniwilmar/models/SaudaModificationListModel.dart';
import 'package:equatable/equatable.dart';

import '../../../../models/daily_rate_response.dart';

abstract class SaudaModApprovalState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SaudaModApproval extends SaudaModApprovalState {}

class OnSaudaModApprovalSuccess extends SaudaModApprovalState {
  List<SaudaModApprovalItem> saudaModApprovalModel;

  OnSaudaModApprovalSuccess(this.saudaModApprovalModel);

  @override
  List<Object?> get props => [saudaModApprovalModel];
}

class ShowModApprovalProgress extends SaudaModApprovalState {}

class HideModApprovalProgress extends SaudaModApprovalState {}

class OnModApprovalFailure extends SaudaModApprovalState {
  final String errorMessage;

  OnModApprovalFailure({required this.errorMessage});
}

class OnLoadModSalesOrganization extends SaudaModApprovalState {
  final List<SalesOrganization> salesOrganization;
  OnLoadModSalesOrganization({required this.salesOrganization});

  @override
  // TODO: implement props
  List<Object> get props => [salesOrganization];
}

class OnLoadModDistributionChannel extends SaudaModApprovalState {
  final List<DistributionChannel> distributionChannel;
  OnLoadModDistributionChannel({required this.distributionChannel});

  @override
  // TODO: implement props
  List<Object> get props => [distributionChannel];
}

class OnLoadModVerticalList extends SaudaModApprovalState {
  final List<Vertical> verticalList;
  OnLoadModVerticalList({required this.verticalList});

  @override
  // TODO: implement props
  List<Object> get props => [verticalList];
}

class OnSaudaSaveRejectSuccess extends SaudaModApprovalState{
  int? statusId=0;
  OnSaudaSaveRejectSuccess(int? statusId);
  @override
  // TODO: implement props
  List<Object> get props => [statusId!];
}
