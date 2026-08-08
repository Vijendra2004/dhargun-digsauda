import 'package:adaniwilmar/models/pack_group_list.dart';
import 'package:adaniwilmar/models/packgroupwise_sales_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class PackGroupState extends Equatable {
  const PackGroupState();
  @override
  List<Object> get props => [];
}

class InitialPackGroupState extends PackGroupState {}

class ShowProgressBar extends PackGroupState {}

class HideProgressBar extends PackGroupState {}

class OnSuccess extends PackGroupState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends PackGroupState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnLoadSuccess extends PackGroupState {
  final List<PackGroupwiseSales> packGroupwiseSales;
  const OnLoadSuccess({required this.packGroupwiseSales});

  @override
  // TODO: implement props
  List<Object> get props => [packGroupwiseSales];
}

class OnLoadPackGroup extends PackGroupState {
  final List<PackGroupList> packGroups;
  const OnLoadPackGroup({required this.packGroups});

  @override
  // TODO: implement props
  List<Object> get props => [packGroups];
}
