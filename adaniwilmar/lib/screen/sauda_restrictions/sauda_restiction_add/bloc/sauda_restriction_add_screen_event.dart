import 'package:adaniwilmar/models/SaveSaudaRestReqmodel.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class SaudaRestrictionAddScreenEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadRolesList extends SaudaRestrictionAddScreenEvent {
  LoadRolesList();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadStateTraderList extends SaudaRestrictionAddScreenEvent {
  LoadStateTraderList();

  @override
  List<Object> get props => [];
}

class LoadZoneTraderList extends SaudaRestrictionAddScreenEvent {
  LoadZoneTraderList();

  @override
  List<Object> get props => [];
}

class LoadDistributorList extends SaudaRestrictionAddScreenEvent {
  LoadDistributorList();

  @override
  List<Object> get props => [];
}

class LoadRestrictionOilType extends SaudaRestrictionAddScreenEvent {
  LoadRestrictionOilType();

  @override
  List<Object> get props => [];
}

class OnSaveSaudaRestriction extends SaudaRestrictionAddScreenEvent {
  final SaveSaudaRestReqmodel saveReqModel;

  OnSaveSaudaRestriction(this.saveReqModel);

  @override
  List<Object> get props => [saveReqModel];
}

class OnUpdateSaudaRestriction extends SaudaRestrictionAddScreenEvent {
  final SaveSaudaRestReqmodel saveReqModel;

  OnUpdateSaudaRestriction(this.saveReqModel);

  @override
  List<Object> get props => [saveReqModel];
}


