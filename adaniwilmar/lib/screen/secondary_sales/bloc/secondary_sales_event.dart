import 'package:equatable/equatable.dart';

abstract class SecondarySalesEvent extends Equatable {
  const SecondarySalesEvent();

  @override
  List<Object> get props => [];
}

class LoadSecondarySalesScreen extends SecondarySalesEvent {
  int userId = 0;

  LoadSecondarySalesScreen({required this.userId});

  @override
  // TODO: implement props
  List<Object> get props => [userId];
}

class LoadOverallData extends SecondarySalesEvent {
  int userId = 0;
  int dealerId = 0;
  LoadOverallData({required this.userId, required this.dealerId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, dealerId];
}

class LoadUserStatistics extends SecondarySalesEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  LoadUserStatistics({required this.userId, required this.selectedMethod});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod];
}

class NotLoggedIn extends SecondarySalesEvent {}
