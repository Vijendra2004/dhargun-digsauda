import 'package:equatable/equatable.dart';

abstract class PackGroupDetailDetailEvent extends Equatable {
  const PackGroupDetailDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadPackGroupDetailDetailScreen extends PackGroupDetailDetailEvent {
  int userId = 0;
  int dealerId = 0;
  int statusId = 0;
  String fromDate = "";
  String toDate = "";
  int packGroupId = 0;
  LoadPackGroupDetailDetailScreen(
      {required this.userId,
      required this.dealerId,
      required this.statusId,
      required this.fromDate,
      required this.toDate,
      required this.packGroupId});

  @override
  // TODO: implement props
  List<Object> get props =>
      [userId, dealerId, statusId, fromDate, toDate, packGroupId];
}

class LoadOverallData extends PackGroupDetailDetailEvent {
  int userId = 0;
  int dealerId = 0;
  LoadOverallData({required this.userId, required this.dealerId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, dealerId];
}

class LoadUserStatistics extends PackGroupDetailDetailEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  LoadUserStatistics({required this.userId, required this.selectedMethod});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod];
}

class NotLoggedIn extends PackGroupDetailDetailEvent {}
