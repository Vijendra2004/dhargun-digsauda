import 'package:equatable/equatable.dart';

abstract class SaudaNumberEvent extends Equatable {
  const SaudaNumberEvent();

  @override
  List<Object> get props => [];
}

class LoadSaudaNumberScreen extends SaudaNumberEvent {
  int userId = 0;
  int dealerId = 0;

  LoadSaudaNumberScreen({required this.userId, required this.dealerId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, dealerId];
}

class LoadOverallData extends SaudaNumberEvent {
  int userId = 0;
  int dealerId = 0;
  LoadOverallData({required this.userId, required this.dealerId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, dealerId];
}

class LoadUserStatistics extends SaudaNumberEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  LoadUserStatistics({required this.userId, required this.selectedMethod});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod];
}

class NotLoggedIn extends SaudaNumberEvent {}
