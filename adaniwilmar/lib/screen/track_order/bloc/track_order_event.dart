import 'package:equatable/equatable.dart';

import '../../../models/bdo_list_response.dart';
import '../../../models/track_order_model.dart';

abstract class TrackOrderEvent extends Equatable {
  const TrackOrderEvent();

  @override
  List<Object> get props => [];
}

class LoadZonalHeadTrack extends TrackOrderEvent {
  int userId = 0;
  bool showAll=false;
  LoadZonalHeadTrack({
    required this.userId,this.showAll=false
  });
  @override
  // TODO: implement props
  List<Object> get props => [userId,showAll];
}


class LoadDistributorHeadTrack extends TrackOrderEvent {
  int userId = 0;
  int salesOrgId;
  int distributionId;
  int divisionId;
  LoadDistributorHeadTrack(
      {required this.userId,
        this.salesOrgId = 0,
        this.distributionId = 0,
        this.divisionId = 0});

  @override
  // TODO: implement props
  List<Object> get props => [userId, salesOrgId, distributionId, divisionId];
}

class LoadTrackBDO extends TrackOrderEvent {
  int userId = 0;
  bool showAll=false;
  LoadTrackBDO({
    required this.userId,this.showAll=false
  });
  @override
  // TODO: implement props
  List<Object> get props => [userId,showAll];
}

class LoadTrackOrderScreen extends TrackOrderEvent {
  int userId = 0;
  int? nationalId = 0;
  int salesOrganizationId = 0;
  int distributionChannelId = 0;
  int divisonId = 0;
  int bdoId=0;
  LoadTrackOrderScreen(
      {required this.userId,
        this.nationalId,
        required this.salesOrganizationId,
        required this.distributionChannelId,
        required this.divisonId,
        this.bdoId=0});

  @override
  // TODO: implement props
  List<Object> get props =>
      [userId, salesOrganizationId, distributionChannelId, divisonId,bdoId];
}

class LoadStateHeadTrack extends TrackOrderEvent {
  int userId = 0;
  bool showAll=false;
  LoadStateHeadTrack({
    required this.userId,this.showAll=false
  });
  @override
  // TODO: implement props
  List<Object> get props => [userId,showAll];
}

class LoadMaterialTrack extends TrackOrderEvent {
  int userId = 0;
  bool isLiftingId;
  String doNumber = '';
  LoadMaterialTrack({
    required this.userId,required this.isLiftingId, required this.doNumber
  });
  @override
  // TODO: implement props
  List<Object> get props => [userId,isLiftingId,doNumber];
}

class LoadStateDOTrack extends TrackOrderEvent {
  List<String> distributorEmpCode = [];
  LoadStateDOTrack({
    required this.distributorEmpCode
  });
  @override
  // TODO: implement props
  List<Object> get props => [distributorEmpCode];
}
class FetchExternalAPITrackOrdersEvent extends TrackOrderEvent {
  String distributorCode;
  String doNumberIds;
  FetchExternalAPITrackOrdersEvent({
    required this.distributorCode,
    required this.doNumberIds
  });
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FetchSaleDataTrackOrdersEvent extends TrackOrderEvent {
  SaleDataRequest saleDataRequest;
  FetchSaleDataTrackOrdersEvent({
  required this.saleDataRequest
  });
  @override
  // TODO: implement props
  List<Object> get props => [];
}
