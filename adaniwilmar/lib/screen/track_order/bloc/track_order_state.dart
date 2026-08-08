import 'package:equatable/equatable.dart';

import '../../../models/bdo_list_response.dart';
import '../../../models/dealer_response.dart';
import '../../../models/do_number_response.dart';
import '../../../models/statistics_response.dart';
import '../../../models/track_order_model.dart';
import '../../../models/track_order_model.dart';
import '../../../models/zone_response.dart';

abstract class TrackOrderState extends Equatable {
  const TrackOrderState();
  @override
  List<Object> get props => [];
}

class InitialTrackOrderState extends TrackOrderState {}

class ShowProgressBar extends TrackOrderState {}

class HideProgressBar extends TrackOrderState {}
class OnFailure extends TrackOrderState {
  final String error;

  const OnFailure({required this.error});


  @override
  // TODO: implement props
  List<Object> get props => [error];
}
class OnFailureSaleDataListTrackOrders extends TrackOrderState {
  final String error;

  const OnFailureSaleDataListTrackOrders({required this.error});


  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnSuccess extends TrackOrderState {
  final String error;

  const OnSuccess({required this.error});


  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnTrackZonalHead extends TrackOrderState {
  final List<BdoList> zonalHeadList;
  const OnTrackZonalHead({required this.zonalHeadList});

  @override
  // TODO: implement props
  List<Object> get props => [zonalHeadList];
}


class OnTrackDistributorHead extends TrackOrderState {
  final List<DistributorList> distributorList;
  const OnTrackDistributorHead(
      {required this.distributorList});

  @override
  // TODO: implement props
  List<Object> get props => [distributorList];
}



class OnTrackStateHead extends TrackOrderState {
  final List<BdoList> stateHeadList;
  const OnTrackStateHead({required this.stateHeadList});

  @override
  // TODO: implement props
  List<Object> get props => [stateHeadList];
}

class OnTrackDoNumber extends TrackOrderState {
  final List<DoNumberResponse> doNumberList;
  const OnTrackDoNumber({required this.doNumberList});

  @override
  // TODO: implement props
  List<Object> get props => [doNumberList];
}
class OnTrackMaterial extends TrackOrderState {
  final List<DoMaterial> materialList;
  const OnTrackMaterial({required this.materialList});

  @override
  // TODO: implement props
  List<Object> get props => [materialList];
}

class OnSaleData extends TrackOrderState {
  final List<SalesDataResponse> salesDataResponse;
  const OnSaleData({required this.salesDataResponse});

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FetchExternalAPITrackOrdersSuccessState extends TrackOrderState {
 final TrackOrderModel trackOrderModel;
  const FetchExternalAPITrackOrdersSuccessState({required this.trackOrderModel});

  @override
  // TODO: implement props
  List<Object> get props => [];
}




