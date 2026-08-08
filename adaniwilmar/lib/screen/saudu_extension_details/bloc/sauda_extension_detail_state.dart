import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/due_for_tomorrow_response.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/sauda_extension_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class SaudaExtensionDetailState extends Equatable {
  const SaudaExtensionDetailState();
  @override
  List<Object> get props => [];
}

class InitialSaudaExtensionDetailState extends SaudaExtensionDetailState {}

class ShowProgressBar extends SaudaExtensionDetailState {}

class HideProgressBar extends SaudaExtensionDetailState {}

class OnSuccess extends SaudaExtensionDetailState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends SaudaExtensionDetailState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends SaudaExtensionDetailState {
  final DueForTomorrowList response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends SaudaExtensionDetailState {
  final List<SaudaExtension> saudaExtensions;
  const OnLoadSuccess({required this.saudaExtensions});

  @override
  // TODO: implement props
  List<Object> get props => [saudaExtensions];
}
class OnLoadBDO extends SaudaExtensionDetailState {
  final List<BdoList> bdoList;
  const OnLoadBDO({required this.bdoList});

  @override
  // TODO: implement props
  List<Object> get props => [bdoList];
}
class OnLoadNewSaudaSuccess extends SaudaExtensionDetailState {
  final List<DistributorList> distributorList;
  final List<BdoList> bdoList;
  const OnLoadNewSaudaSuccess({required this.distributorList,required this.bdoList});

  @override
  // TODO: implement props
  List<Object> get props => [distributorList,bdoList];
}

class OnLoadOilType extends SaudaExtensionDetailState {
  final List<OilType> oilTypes;
  const OnLoadOilType({required this.oilTypes});

  @override
  // TODO: implement props
  List<Object> get props => [oilTypes];
}

class OnSaveSuccess extends SaudaExtensionDetailState {
  final bool saved;
  const OnSaveSuccess({required this.saved});

  @override
  // TODO: implement props
  List<Object> get props => [saved];
}
