import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/zonal_head_list.dart';
import 'package:equatable/equatable.dart';

abstract class StateTraderFilterState extends Equatable {
  const StateTraderFilterState();
  @override
  List<Object> get props => [];
}

class InitialStateTraderFilterState extends StateTraderFilterState {}

class ShowProgressBar extends StateTraderFilterState {}

class HideProgressBar extends StateTraderFilterState {}

class OnFailure extends StateTraderFilterState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}


class OnLoadBDO extends StateTraderFilterState {
  final List<BdoList> bdoList;
  const OnLoadBDO({required this.bdoList});

  @override
  // TODO: implement props
  List<Object> get props => [bdoList];
}

class OnLoadZonalHead extends StateTraderFilterState {
  final List<BdoList> zonalHeadList;
  const OnLoadZonalHead({required this.zonalHeadList});

  @override
  // TODO: implement props
  List<Object> get props => [zonalHeadList];
}
