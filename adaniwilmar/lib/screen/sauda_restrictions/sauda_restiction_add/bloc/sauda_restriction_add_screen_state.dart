import 'package:adaniwilmar/models/RolesResponse.dart';
import 'package:adaniwilmar/models/SaudaRestrictionListModel.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../models/StateTraderModel.dart';

@immutable
abstract class SaudaRestrictionAddScreenState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SaudaAddResScreenInitial extends SaudaRestrictionAddScreenState {}

class ShowAddResProgressBar extends SaudaRestrictionAddScreenState {}

class HideAddResProgressBar extends SaudaRestrictionAddScreenState {}

class OnResFailure extends SaudaRestrictionAddScreenState {
  final String errorMessage;

  OnResFailure({required this.errorMessage});
}

class OnAddResSuccess extends SaudaRestrictionAddScreenState {
  final List<RoleItem>? rolesList;

  OnAddResSuccess({required this.rolesList});
}

class OnStateTraderResponse extends SaudaRestrictionAddScreenState {
  final List<TradersNameItems>? items;

  OnStateTraderResponse({required this.items});
}

class OnZoneTraderResponse extends SaudaRestrictionAddScreenState {
  final List<TradersNameItems>? zoneItems;

  OnZoneTraderResponse({required this.zoneItems});
}

class OnDistributorsResponse extends SaudaRestrictionAddScreenState {
  final List<TradersNameItems>? distributorsItems;

  OnDistributorsResponse({required this.distributorsItems});
}

class OnOilResponse extends SaudaRestrictionAddScreenState {
  final List<TradersNameItems>? oilItems;

  OnOilResponse({required this.oilItems});
}

class OnRestSaveSuccess extends SaudaRestrictionAddScreenState {
  final String message;

  OnRestSaveSuccess({required this.message});
}

class OnUpdateResponse extends SaudaRestrictionAddScreenState {
  final String message;

  OnUpdateResponse({required this.message});
}
