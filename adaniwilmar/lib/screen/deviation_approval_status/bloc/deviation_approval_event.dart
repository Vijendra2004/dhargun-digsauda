import 'package:equatable/equatable.dart';

abstract class DeviationApprovalEvent extends Equatable {
  const DeviationApprovalEvent();

  @override
  List<Object> get props => [];
}

class LoadDeviationApprovalScreen extends DeviationApprovalEvent {
  int userId = 0;

  LoadDeviationApprovalScreen({
    required this.userId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [userId];
}

class LoadOverallData extends DeviationApprovalEvent {
  int userId = 0;
  int dealerId = 0;
  LoadOverallData({required this.userId, required this.dealerId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, dealerId];
}

class LoadUserStatistics extends DeviationApprovalEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  LoadUserStatistics({required this.userId, required this.selectedMethod});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod];
}

class NotLoggedIn extends DeviationApprovalEvent {}
