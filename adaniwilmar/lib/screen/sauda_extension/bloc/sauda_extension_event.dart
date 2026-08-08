import 'package:equatable/equatable.dart';

abstract class SaudaExtensionEvent extends Equatable {
  const SaudaExtensionEvent();

  @override
  List<Object> get props => [];
}

class LoadSaudaExtensionScreen extends SaudaExtensionEvent {
  int userId = 0;
  String fromDate = "";
  String toDate = "";

  LoadSaudaExtensionScreen(
      {required this.userId, required this.fromDate, required this.toDate});

  @override
  // TODO: implement props
  List<Object> get props => [userId, fromDate, toDate];
}

class LoadOverallData extends SaudaExtensionEvent {
  int userId = 0;
  int dealerId = 0;
  LoadOverallData({required this.userId, required this.dealerId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, dealerId];
}

class LoadUserStatistics extends SaudaExtensionEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  LoadUserStatistics({required this.userId, required this.selectedMethod});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod];
}

class NotLoggedIn extends SaudaExtensionEvent {}
