
import 'package:equatable/equatable.dart';

import '../../../models/gamification_model.dart';

abstract class GamificationDashboardState extends Equatable {
  const GamificationDashboardState();
  @override
  List<Object> get props => [];
}

class GamificationDashboardInitial extends GamificationDashboardState {}

class ShowProgressBar extends GamificationDashboardState {}

class HideProgressBar extends GamificationDashboardState {}

class OnFailure extends GamificationDashboardState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnLoadGamificationDashboardDataSuccess extends GamificationDashboardState {
  final GamificationFieldsData response;
  const OnLoadGamificationDashboardDataSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}


