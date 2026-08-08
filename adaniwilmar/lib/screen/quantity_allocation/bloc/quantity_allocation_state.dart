import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/qty_allocation.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class QuantityAllocationState extends Equatable {
  const QuantityAllocationState();
  @override
  List<Object> get props => [];
}

class InitialQuantityAllocationState extends QuantityAllocationState {}

class ShowProgressBar extends QuantityAllocationState {}

class HideProgressBar extends QuantityAllocationState {}

class OnSuccess extends QuantityAllocationState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends QuantityAllocationState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends QuantityAllocationState {
  final List<DailySFQuantityAllocation> response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnOverallManagerSuccess extends QuantityAllocationState {
  final List<QuantityRequestList> response;
  const OnOverallManagerSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends QuantityAllocationState {
  final List<DistributorList> distributorList;
  const OnLoadSuccess({required this.distributorList});

  @override
  // TODO: implement props
  List<Object> get props => [distributorList];
}

class OnLoadOilType extends QuantityAllocationState {
  final List<OilType> oilTypes;
  const OnLoadOilType({required this.oilTypes});

  @override
  // TODO: implement props
  List<Object> get props => [oilTypes];
}

class OnQuantityAllocationRequestSuccess extends QuantityAllocationState {
  final List<SpecialtyFatQuantityRequestsList> quantityRequestList;
  final List<SpecialtyFatQuantityRequestsList> quantityManagerRequestList;
  const OnQuantityAllocationRequestSuccess({required this.quantityRequestList,required this.quantityManagerRequestList});

  @override
  // TODO: implement props
  List<Object> get props => [quantityRequestList,quantityManagerRequestList];
}
class OnSaveSuccess extends QuantityAllocationState {
  final bool saved;
  const OnSaveSuccess({required this.saved});

  @override
  // TODO: implement props
  List<Object> get props => [saved];
}
