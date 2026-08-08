
import 'package:equatable/equatable.dart';

class GamificationDashboardEvent extends Equatable {
  const GamificationDashboardEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadGamificationDashboardData extends GamificationDashboardEvent {
  String dealerCode = "";
  LoadGamificationDashboardData({ required this.dealerCode});

  @override
  // TODO: implement props
  List<Object> get props => [dealerCode];
}

class LoadGamificationDashboardDataDisplay extends GamificationDashboardEvent {
  String dealerCode = "";
  LoadGamificationDashboardDataDisplay({ required this.dealerCode});

  @override
  // TODO: implement props
  List<Object> get props => [dealerCode];
}
