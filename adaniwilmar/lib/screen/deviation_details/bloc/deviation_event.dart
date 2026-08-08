import 'package:equatable/equatable.dart';

abstract class DeviationEvent extends Equatable {
  const DeviationEvent();

  @override
  List<Object> get props => [];
}

class LoadDeviationScreen extends DeviationEvent {
  int userId = 0;

  LoadDeviationScreen({
    required this.userId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [userId];
}

class LoadOverallData extends DeviationEvent {
  int userId = 0;
  int dealerId = 0;
  LoadOverallData({required this.userId, required this.dealerId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, dealerId];
}

class LoadUserStatistics extends DeviationEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  LoadUserStatistics({required this.userId, required this.selectedMethod});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod];
}

class NotLoggedIn extends DeviationEvent {}
