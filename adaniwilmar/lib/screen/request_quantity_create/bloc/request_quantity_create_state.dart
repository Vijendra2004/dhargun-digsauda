import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/qty_allocation.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

import '../../../models/bdo_list_response.dart';
import '../../../models/daily_rate_response.dart';
import '../../../models/qa_list_model.dart';

abstract class RequestQuantityCreateState extends Equatable {
  const RequestQuantityCreateState();
  @override
  List<Object> get props => [];
}

class InitialQuantityAllocationCreateUpdateState extends RequestQuantityCreateState {}

class ShowProgressBar extends RequestQuantityCreateState {}

class HideProgressBar extends RequestQuantityCreateState {}

class OnSuccess extends RequestQuantityCreateState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends RequestQuantityCreateState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends RequestQuantityCreateState {
  final List<DailySFQuantityAllocation> response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnOverallManagerSuccess extends RequestQuantityCreateState {
  final List<QuantityRequestList> response;
  const OnOverallManagerSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends RequestQuantityCreateState {
  final List<DistributorList> distributorList;
  const OnLoadSuccess({required this.distributorList});

  @override
  // TODO: implement props
  List<Object> get props => [distributorList];
}

class OnLoadOilTypes extends RequestQuantityCreateState {
  final List<OilType> oilTypes;
  const OnLoadOilTypes({required this.oilTypes});

  @override
  // TODO: implement props
  List<Object> get props => [oilTypes];
}

class OnQuantityAllocationRequestSuccess extends RequestQuantityCreateState {
  final List<SpecialtyFatQuantityRequestsList> quantityRequestList;
  final List<SpecialtyFatQuantityRequestsList> quantityManagerRequestList;
  const OnQuantityAllocationRequestSuccess({required this.quantityRequestList,required this.quantityManagerRequestList});

  @override
  // TODO: implement props
  List<Object> get props => [quantityRequestList,quantityManagerRequestList];
}
class OnSaveSuccess extends RequestQuantityCreateState {
  final bool saved;
  const OnSaveSuccess({required this.saved});

  @override
  // TODO: implement props
  List<Object> get props => [saved];
}

class OnLoadSalesOrganization extends RequestQuantityCreateState {
  final List<SalesOrganization> salesOrganization;
  const OnLoadSalesOrganization({required this.salesOrganization});

  @override
  // TODO: implement props
  List<Object> get props => [salesOrganization];
}

class OnLoadMaterial extends RequestQuantityCreateState {
  final List<BdoList> metrialList;
  const OnLoadMaterial({required this.metrialList});

  @override
  // TODO: implement props
  List<Object> get props => [metrialList];
}



class OnLoadDistributionChannel extends RequestQuantityCreateState {
  final List<DistributionChannel> distributionChannel;
  const OnLoadDistributionChannel({required this.distributionChannel});

  @override
  // TODO: implement props
  List<Object> get props => [distributionChannel];
}

class OnLoadVerticalList extends RequestQuantityCreateState {
  final List<Vertical> verticalList;
  const OnLoadVerticalList({required this.verticalList});

  @override
  // TODO: implement props
  List<Object> get props => [verticalList];
}

class OnLoadSubCategoryItems extends RequestQuantityCreateState {

  const OnLoadSubCategoryItems();

  @override
  // TODO: implement props
  List<Object> get props => [];
}


class OnLoadZonalEmployees extends RequestQuantityCreateState {
  final List<ZonalEmployeeList> zoanlEmpList;

  const OnLoadZonalEmployees({required this.zoanlEmpList});

  @override
  // TODO: implement props
  List<Object> get props => [zoanlEmpList];
}


class OnLoadQAItemFetch extends RequestQuantityCreateState {
  QAListResponseValue listModel = QAListResponseValue();


  OnLoadQAItemFetch({required this.listModel});

  @override
  // TODO: implement props
  List<Object> get props =>
      [listModel ];

}



