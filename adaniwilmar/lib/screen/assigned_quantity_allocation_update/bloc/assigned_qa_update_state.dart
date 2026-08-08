import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/qty_allocation.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

import '../../../models/bdo_list_response.dart';
import '../../../models/daily_rate_response.dart';
import '../../../models/qa_list_model.dart';

abstract class AssignedQAUpdateState extends Equatable {
  const AssignedQAUpdateState();
  @override
  List<Object> get props => [];
}

class InitialQuantityAllocationCreateUpdateState extends AssignedQAUpdateState {}

class ShowProgressBar extends AssignedQAUpdateState {}

class HideProgressBar extends AssignedQAUpdateState {}

class OnSuccess extends AssignedQAUpdateState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends AssignedQAUpdateState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends AssignedQAUpdateState {
  final List<DailySFQuantityAllocation> response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnOverallManagerSuccess extends AssignedQAUpdateState {
  final List<QuantityRequestList> response;
  const OnOverallManagerSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends AssignedQAUpdateState {
  final List<DistributorList> distributorList;
  const OnLoadSuccess({required this.distributorList});

  @override
  // TODO: implement props
  List<Object> get props => [distributorList];
}

class OnLoadOilTypes extends AssignedQAUpdateState {
  final List<OilType> oilTypes;
  const OnLoadOilTypes({required this.oilTypes});

  @override
  // TODO: implement props
  List<Object> get props => [oilTypes];
}

class OnQuantityAllocationRequestSuccess extends AssignedQAUpdateState {
  final List<SpecialtyFatQuantityRequestsList> quantityRequestList;
  final List<SpecialtyFatQuantityRequestsList> quantityManagerRequestList;
  const OnQuantityAllocationRequestSuccess({required this.quantityRequestList,required this.quantityManagerRequestList});

  @override
  // TODO: implement props
  List<Object> get props => [quantityRequestList,quantityManagerRequestList];
}
class OnSaveSuccess extends AssignedQAUpdateState {
  final bool saved;
  const OnSaveSuccess({required this.saved});

  @override
  // TODO: implement props
  List<Object> get props => [saved];
}

class OnLoadSalesOrganization extends AssignedQAUpdateState {
  final List<SalesOrganization> salesOrganization;
  const OnLoadSalesOrganization({required this.salesOrganization});

  @override
  // TODO: implement props
  List<Object> get props => [salesOrganization];
}

class OnLoadMaterial extends AssignedQAUpdateState {
  final List<BdoList> metrialList;
  const OnLoadMaterial({required this.metrialList});

  @override
  // TODO: implement props
  List<Object> get props => [metrialList];
}



class OnLoadDistributionChannel extends AssignedQAUpdateState {
  final List<DistributionChannel> distributionChannel;
  const OnLoadDistributionChannel({required this.distributionChannel});

  @override
  // TODO: implement props
  List<Object> get props => [distributionChannel];
}

class OnLoadVerticalList extends AssignedQAUpdateState {
  final List<Vertical> verticalList;
  const OnLoadVerticalList({required this.verticalList});

  @override
  // TODO: implement props
  List<Object> get props => [verticalList];
}

class OnLoadSubCategoryItems extends AssignedQAUpdateState {

  const OnLoadSubCategoryItems();

  @override
  // TODO: implement props
  List<Object> get props => [];
}


class OnLoadZonalEmployees extends AssignedQAUpdateState {
  final List<ZonalEmployeeList> zoanlEmpList;

  const OnLoadZonalEmployees({required this.zoanlEmpList});

  @override
  // TODO: implement props
  List<Object> get props => [zoanlEmpList];
}


class OnLoadQAItemFetch extends AssignedQAUpdateState {
  QAListResponseValue listModel = QAListResponseValue();


  OnLoadQAItemFetch({required this.listModel});

  @override
  // TODO: implement props
  List<Object> get props =>
      [listModel ];

}



