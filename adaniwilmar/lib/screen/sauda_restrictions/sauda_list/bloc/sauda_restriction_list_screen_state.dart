import 'package:adaniwilmar/models/SaudaRestrictionListModel.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SaudaRestrictionListScreenState extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SaudaRestrictionListScreenInitial extends SaudaRestrictionListScreenState {
}

class ShowRestrictionProgressBar extends SaudaRestrictionListScreenState {}

class HideRestrictionProgressBar extends SaudaRestrictionListScreenState {}

class OnResFailure extends SaudaRestrictionListScreenState {
  final String errorMessage;

  OnResFailure({required this.errorMessage});
}

class OnResSuccess extends SaudaRestrictionListScreenState {
  final List<SaudaItem>? restrictionList;

  OnResSuccess({required this.restrictionList});
}