import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/qty_allocation.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

import '../../../models/bdo_list_response.dart';
import '../../../models/daily_rate_response.dart';
import '../../../models/qa_list_model.dart';

abstract class QAListState extends Equatable {
  const QAListState();
  @override
  List<Object> get props => [];
}

class InitialQuantityAllocationCreateUpdateState extends QAListState {}

class ShowProgressBar extends QAListState {}

class HideProgressBar extends QAListState {}

class OnSuccess extends QAListState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends QAListState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends QAListState {
  final List<DailySFQuantityAllocation> response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnOverallManagerSuccess extends QAListState {
  final List<QuantityRequestList> response;
  const OnOverallManagerSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends QAListState {
  final List<DistributorList> distributorList;
  const OnLoadSuccess({required this.distributorList});

  @override
  // TODO: implement props
  List<Object> get props => [distributorList];
}

class OnLoadOilTypes extends QAListState {
  final List<OilType> oilTypes;
  const OnLoadOilTypes({required this.oilTypes});

  @override
  // TODO: implement props
  List<Object> get props => [oilTypes];
}

class OnQuantityAllocationRequestSuccess extends QAListState {
  final List<SpecialtyFatQuantityRequestsList> quantityRequestList;
  final List<SpecialtyFatQuantityRequestsList> quantityManagerRequestList;
  const OnQuantityAllocationRequestSuccess({required this.quantityRequestList,required this.quantityManagerRequestList});

  @override
  // TODO: implement props
  List<Object> get props => [quantityRequestList,quantityManagerRequestList];
}
class OnSaveSuccess extends QAListState {
  final bool saved;
  const OnSaveSuccess({required this.saved});

  @override
  // TODO: implement props
  List<Object> get props => [saved];
}

class OnLoadSalesOrganization extends QAListState {
  final List<SalesOrganization> salesOrganization;
  const OnLoadSalesOrganization({required this.salesOrganization});

  @override
  // TODO: implement props
  List<Object> get props => [salesOrganization];
}

class OnLoadMaterial extends QAListState {
  final List<BdoList> metrialList;
  const OnLoadMaterial({required this.metrialList});

  @override
  // TODO: implement props
  List<Object> get props => [metrialList];
}



class OnLoadDistributionChannel extends QAListState {
  final List<DistributionChannel> distributionChannel;
  const OnLoadDistributionChannel({required this.distributionChannel});

  @override
  // TODO: implement props
  List<Object> get props => [distributionChannel];
}

class OnLoadVerticalList extends QAListState {
  final List<Vertical> verticalList;
  const OnLoadVerticalList({required this.verticalList});

  @override
  // TODO: implement props
  List<Object> get props => [verticalList];
}

class onLoadQuantityRequestList extends QAListState {
  final List<QAListResponseValue> listModel;
  const onLoadQuantityRequestList({required this.listModel});

  @override
  // TODO: implement props
  List<Object> get props => [listModel];
}


class OnLoadSubCategoryItems extends QAListState {

  const OnLoadSubCategoryItems();

  @override
  // TODO: implement props
  List<Object> get props => [];
}


class OnLoadZonalEmployees extends QAListState {
  final List<ZonalEmployeeList> zoanlEmpList;

  const OnLoadZonalEmployees({required this.zoanlEmpList});

  @override
  // TODO: implement props
  List<Object> get props => [zoanlEmpList];
}




