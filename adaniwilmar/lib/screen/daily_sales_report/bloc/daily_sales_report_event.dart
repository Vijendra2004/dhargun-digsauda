import 'package:adaniwilmar/models/dealer_visit_request.dart';
import 'package:adaniwilmar/models/price_discovery_request.dart';
import 'package:equatable/equatable.dart';

abstract class DailySalesReportEvent extends Equatable {
  const DailySalesReportEvent();

  @override
  List<Object> get props => [];
}

class LoadDailySalesReportScreen extends DailySalesReportEvent {
  int userId = 0;
  String serverTime="";
  LoadDailySalesReportScreen(
      {required this.userId,
        required this.serverTime
      });

  @override
  // TODO: implement props
  List<Object> get props =>
      [userId,serverTime];
}

class LoadDealerVisitScreen extends DailySalesReportEvent {
  int userId = 0;
  LoadDealerVisitScreen(
      {required this.userId,
      });

  @override
  // TODO: implement props
  List<Object> get props =>
      [userId];
}

class LoadOverallData extends DailySalesReportEvent {
  int userId = 0;
  int oilTypeId = 0;
  int plantId = 0;
  int verticalId = 0;
  int incoTermId = 0;
  LoadOverallData(
      {required this.userId,
      required this.oilTypeId,
      required this.plantId,
      required this.verticalId,
      required this.incoTermId});

  @override
  // TODO: implement props
  List<Object> get props =>
      [userId, oilTypeId, plantId, verticalId, incoTermId];
}

class LoadDealerSaudaDetail extends DailySalesReportEvent {
  int id = 0;
  int saudaBookingTypeId = 0;
  int salesOrganizationId = 0;
  int distributionChannelId = 0;
  int divisionId = 0;
  LoadDealerSaudaDetail(
      {required this.id,
      required this.saudaBookingTypeId,
      required this.salesOrganizationId,
      required this.distributionChannelId,
      required this.divisionId});

  @override
  // TODO: implement props
  List<Object> get props => [
        id,
        saudaBookingTypeId,
        salesOrganizationId,
        distributionChannelId,
        divisionId
      ];
}

class LoadSalesOrganization extends DailySalesReportEvent {
  int id = 0;
  int saudaBookingTypeId = 0;
  LoadSalesOrganization({required this.id, required this.saudaBookingTypeId});

  @override
  // TODO: implement props
  List<Object> get props => [id, saudaBookingTypeId];
}

class LoadDistributionChannel extends DailySalesReportEvent {
  int id = 0;
  LoadDistributionChannel({
    required this.id,
  });

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class LoadVerticalList extends DailySalesReportEvent {
  int distributionId = 0;
  LoadVerticalList({
    required this.distributionId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [distributionId];
}

class LoadOilType extends DailySalesReportEvent {
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

class LoadIncoTerms extends DailySalesReportEvent {
  @override
// TODO: implement props
  List<Object> get props => [];
}

class LoadPlant extends DailySalesReportEvent {
  int stateId = 0;
  LoadPlant({
    required this.stateId,
  });
  @override
  // TODO: implement props
  List<Object> get props => [stateId];
}

class LoadSKUDetails extends DailySalesReportEvent {
  int userId = 0;
  int oilTypeId = 0;
  int currentIndex = -1;
  LoadSKUDetails(
      {required this.userId,
      required this.oilTypeId,
      required this.currentIndex});
  @override
  // TODO: implement props
  List<Object> get props => [userId, oilTypeId];
}

class LoadUserStatistics extends DailySalesReportEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  LoadUserStatistics({required this.userId, required this.selectedMethod});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod];
}

class SaveDealerVisit extends DailySalesReportEvent {
  final DealerVisitRequest request;
  const SaveDealerVisit({
    required this.request,
  });

  @override
  // TODO: implement props
  List<Object> get props => [request];
}

class SaveWholesalerVisit extends DailySalesReportEvent {
  final WholesalerVisitRequest request;
  const SaveWholesalerVisit({
    required this.request,
  });

  @override
  // TODO: implement props
  List<Object> get props => [request];
}

class SavePerspectiveVisit extends DailySalesReportEvent {
  final PerspectiveVisitRequest request;
  const SavePerspectiveVisit({
    required this.request,
  });

  @override
  // TODO: implement props
  List<Object> get props => [request];
}

class SubmitDailySalesReport extends DailySalesReportEvent {
  int userId = 0;
  int mtpId = 0;
  String remarks = "";
  SubmitDailySalesReport(
      {required this.userId,
        required this.mtpId,
        required this.remarks});
  @override
  // TODO: implement props
  List<Object> get props => [userId, mtpId,remarks];
}

class ChangeRate extends DailySalesReportEvent {
  final bool popup;
  const ChangeRate({this.popup = false});

  @override
  // TODO: implement props
  List<Object> get props => [popup];
}

class NotLoggedIn extends DailySalesReportEvent {}
