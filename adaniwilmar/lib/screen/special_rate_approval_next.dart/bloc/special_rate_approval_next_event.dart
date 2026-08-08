import 'package:equatable/equatable.dart';

abstract class SpecialRateApprovalViewEvent extends Equatable {
  const SpecialRateApprovalViewEvent();

  @override
  List<Object> get props => [];
}

class LoadSpecialRateApprovalViewScreen extends SpecialRateApprovalViewEvent {
  int userId = 0;
  int dealerId = 0;
  int specialRateId = 0;

  LoadSpecialRateApprovalViewScreen(
      {required this.userId,
      required this.dealerId,
      required this.specialRateId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, dealerId, specialRateId];
}

class LoadOverallData extends SpecialRateApprovalViewEvent {
  int userId = 0;
  int dealerId = 0;
  LoadOverallData({required this.userId, required this.dealerId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, dealerId];
}

class LoadUserStatistics extends SpecialRateApprovalViewEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  LoadUserStatistics({required this.userId, required this.selectedMethod});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod];
}

class NotLoggedIn extends SpecialRateApprovalViewEvent {}
