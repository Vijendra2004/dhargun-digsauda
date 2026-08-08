import 'package:equatable/equatable.dart';

abstract class SpecialRateApprovalEvent extends Equatable {
  const SpecialRateApprovalEvent();

  @override
  List<Object> get props => [];
}

class LoadSpecialRateApprovalScreen extends SpecialRateApprovalEvent {
  int userId = 0;
  int dealerId = 0;

  LoadSpecialRateApprovalScreen({required this.userId, required this.dealerId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, dealerId];
}

class LoadOverallData extends SpecialRateApprovalEvent {
  int userId = 0;
  int dealerId = 0;
  LoadOverallData({required this.userId, required this.dealerId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, dealerId];
}

class LoadUserStatistics extends SpecialRateApprovalEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  LoadUserStatistics({required this.userId, required this.selectedMethod});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod];
}

class NotLoggedIn extends SpecialRateApprovalEvent {}
