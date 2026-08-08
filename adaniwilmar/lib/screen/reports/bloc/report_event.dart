// ignore: unused_import
import 'package:adaniwilmar/models/new_sauda_request.dart';
import 'package:equatable/equatable.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object> get props => [];
}

class LoadReportScreen extends ReportEvent {
  int userId = 0;
  int salesOrganizationId = 0;
  int distributionChannelId = 0;
  int divisonId = 0;
  List<int> bdoIds = [];
  LoadReportScreen(
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

class LoadReportData extends ReportEvent {
  int userId = 0;
  int id = 0;
  int plantId = 0;
  List<int> nationalHeadIds = [];
  List<int> zhIds = [];
  List<int> bdoIds = [];
  List<int> dealerIds = [];
  List<int> stateIds = [];
  List<int> oilTypeIds = [];
  List<int> packGroupIds = [];
  String fromDate = "";
  String toDate = "";
  bool isSales = false;
  int oilPackGroupTypeId = 0;

  LoadReportData(
      {required this.userId,
      required this.id,
      required this.bdoIds,
      required this.dealerIds,
      required this.stateIds,
      required this.isSales,
      required this.oilTypeIds,
      required this.packGroupIds,
      required this.plantId,
      required this.fromDate,
      required this.toDate,
      required this.nationalHeadIds,
      required this.zhIds,
      required this.oilPackGroupTypeId
      });

  @override
  // TODO: implement props
  List<Object> get props => [
        userId,
        id,
        stateIds,
        isSales,
        plantId,
        bdoIds,
        dealerIds,
        oilTypeIds,
        packGroupIds,
        fromDate,
        toDate,
        nationalHeadIds,
        zhIds,
    oilPackGroupTypeId
      ];
}

class LoadSalesOrganization extends ReportEvent {
  int id = 0;
  int saudaBookingTypeId = 0;
  LoadSalesOrganization({required this.id, required this.saudaBookingTypeId});

  @override
  // TODO: implement props
  List<Object> get props => [id, saudaBookingTypeId];
}

class LoadDistributionChannel extends ReportEvent {
  int id = 0;
  LoadDistributionChannel({
    required this.id,
  });

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class LoadVerticalList extends ReportEvent {
  int distributionId = 0;
  LoadVerticalList({
    required this.distributionId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [distributionId];
}

class LoadBDO extends ReportEvent {
  int userId = 0;
  LoadBDO({
    required this.userId,
  });
  @override
  // TODO: implement props
  List<Object> get props => [userId];
}

class LoadReportFilter extends ReportEvent {
  int userId = 0;
  LoadReportFilter({required this.userId});

  @override
  // TODO: implement props
  List<Object> get props => [userId];
}

class LoadActiveStates extends ReportEvent {
  int id = 0;
  LoadActiveStates({
    required this.id,
  });

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class LoadOilType extends ReportEvent {
  int salesOrganizationId = 0;
  int distributionChannelId = 0;
  int divisonId = 0;
  int userId = 0;
  LoadOilType(
      {required this.userId,
      required this.salesOrganizationId,
      required this.distributionChannelId,
      required this.divisonId});

  @override
  // TODO: implement props
  List<Object> get props =>
      [userId, salesOrganizationId, distributionChannelId, divisonId];
}

class LoadPlant extends ReportEvent {
  int stateId = 0;
  LoadPlant({
    required this.stateId,
  });
  @override
  // TODO: implement props
  List<Object> get props => [stateId];
}
