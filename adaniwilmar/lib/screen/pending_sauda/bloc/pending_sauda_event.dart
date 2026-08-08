import 'package:equatable/equatable.dart';

abstract class PendingSaudaEvent extends Equatable {
  const PendingSaudaEvent();

  @override
  List<Object> get props => [];
}

class LoadPendingSaudaSalesScreen extends PendingSaudaEvent {
  int userId = 0;
  List<int> bdoIds = [];
  List<int> dealerIds = [];
  int creditId = 1;
  bool loadData=true;
  LoadPendingSaudaSalesScreen(
      {required this.userId,
      required this.bdoIds,
      required this.dealerIds,
      required this.creditId,
      this.loadData=true});

  @override
  // TODO: implement props
  List<Object> get props => [userId, bdoIds, dealerIds, creditId,loadData];
}

class LoadPendingSaudaChart extends PendingSaudaEvent {
  int userId = 0;
  int roleId = 0;
  List<int> bdoIds = [];
  List<int> dealerIds = [];
  int creditId = 1;
  LoadPendingSaudaChart(
      {required this.userId,
        required this.roleId,
      required this.bdoIds,
      required this.dealerIds,
      required this.creditId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, roleId,bdoIds, dealerIds, creditId];
}

class LoadPendingSaudaList extends PendingSaudaEvent {
  int userId = 0;
  LoadPendingSaudaList({required this.userId});

  @override
  // TODO: implement props
  List<Object> get props => [userId];
}

class GetSaudaCreationStatus extends PendingSaudaEvent {
  int userId = 0;
  GetSaudaCreationStatus({required this.userId});

  @override
  // TODO: implement props
  List<Object> get props => [userId];
}

class NotLoggedIn extends PendingSaudaEvent {}
