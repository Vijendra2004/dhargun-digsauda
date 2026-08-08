import 'package:equatable/equatable.dart';

abstract class StateTraderFilterEvent extends Equatable {
  const StateTraderFilterEvent();

  @override
  List<Object> get props => [];
}

class LoadBDO extends StateTraderFilterEvent {
  int userId = 0;
  bool showAll=false;
  LoadBDO({
    required this.userId,this.showAll=false
  });
  @override
  // TODO: implement props
  List<Object> get props => [userId,showAll];
}

class LoadZonalHead extends StateTraderFilterEvent {
  int userId = 0;
  bool showAll=false;
  LoadZonalHead({
    required this.userId,this.showAll=false
  });
  @override
  // TODO: implement props
  List<Object> get props => [userId,showAll];
}

