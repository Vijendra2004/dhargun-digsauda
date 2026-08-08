import 'package:equatable/equatable.dart';

abstract class SaudaDetailViewEvent extends Equatable {
  const SaudaDetailViewEvent();

  @override
  List<Object> get props => [];
}

class LoadSaudaDetailViewScreen extends SaudaDetailViewEvent {
  int userId = 0;
  int saudaId = 0;

  LoadSaudaDetailViewScreen({required this.userId, required this.saudaId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, saudaId];
}

class LoadOverallData extends SaudaDetailViewEvent {
  int userId = 0;
  int dealerId = 0;
  LoadOverallData({required this.userId, required this.dealerId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, dealerId];
}

class LoadUserStatistics extends SaudaDetailViewEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  LoadUserStatistics({required this.userId, required this.selectedMethod});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod];
}

class NotLoggedIn extends SaudaDetailViewEvent {}
