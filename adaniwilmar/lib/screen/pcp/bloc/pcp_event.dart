import 'package:equatable/equatable.dart';

abstract class PcpEvent extends Equatable {
  const PcpEvent();

  @override
  List<Object> get props => [];
}

class LoadPcpScreen extends PcpEvent {
  int userId = 0;
  int id = 0;

  LoadPcpScreen({required this.userId, required this.id});

  @override
  // TODO: implement props
  List<Object> get props => [userId, id];
}

class LoadOverallData extends PcpEvent {
  int userId = 0;
  int dealerId = 0;
  LoadOverallData({required this.userId, required this.dealerId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, dealerId];
}

class LoadUserStatistics extends PcpEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  LoadUserStatistics({required this.userId, required this.selectedMethod});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod];
}

class LoadPcpViewScreen extends PcpEvent {
  int userId = 0;
  int id = 0;

  LoadPcpViewScreen({required this.userId, required this.id});

  @override
  // TODO: implement props
  List<Object> get props => [userId, id];
}

class NotLoggedIn extends PcpEvent {}
