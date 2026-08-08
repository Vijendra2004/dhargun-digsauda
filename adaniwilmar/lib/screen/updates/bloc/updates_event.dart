import 'package:equatable/equatable.dart';

abstract class UpdatesEvent extends Equatable {
  const UpdatesEvent();

  @override
  List<Object> get props => [];
}

class LoadUpdatesScreen extends UpdatesEvent {
  int userId = 0;
  int dealerId = 0;

  LoadUpdatesScreen({required this.userId, required this.dealerId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, dealerId];
}

class LoadLedgerData extends UpdatesEvent {
  int userId = 0;
  String dealerId = "0";

  LoadLedgerData({required this.userId, required this.dealerId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, dealerId];
}

class NotLoggedIn extends UpdatesEvent {}
