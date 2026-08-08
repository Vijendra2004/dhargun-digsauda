import 'package:equatable/equatable.dart';

abstract class PackGroupEvent extends Equatable {
  const PackGroupEvent();

  @override
  List<Object> get props => [];
}

class LoadPackGroupSalesScreen extends PackGroupEvent {
  int userId = 0;
  String fromDate = "";
  String toDate = "";
  int packGroupId = 0;
  int bdoId=0;
  LoadPackGroupSalesScreen(
      {required this.userId,
      required this.fromDate,
      required this.toDate,
      required this.packGroupId,
      this.bdoId=0});

  @override
  // TODO: implement props
  List<Object> get props => [userId, fromDate, toDate, packGroupId,bdoId];
}

class LoadPackGroupList extends PackGroupEvent {
  int userId = 0;
  LoadPackGroupList({required this.userId});

  @override
  // TODO: implement props
  List<Object> get props => [userId];
}

class NotLoggedIn extends PackGroupEvent {}
