import 'package:equatable/equatable.dart';

abstract class SecondarySalesDetailEvent extends Equatable {
  const SecondarySalesDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadSecondarySalesDetailScreen extends SecondarySalesDetailEvent {
  int userId = 0;
  int wholeSellerId = 0;
  String visitDate = "";

  LoadSecondarySalesDetailScreen(
      {required this.userId,
      required this.wholeSellerId,
      required this.visitDate});

  @override
  // TODO: implement props
  List<Object> get props => [userId, wholeSellerId, visitDate];
}

class LoadOverallData extends SecondarySalesDetailEvent {
  int userId = 0;
  int dealerId = 0;
  LoadOverallData({required this.userId, required this.dealerId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, dealerId];
}

class LoadUserStatistics extends SecondarySalesDetailEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  LoadUserStatistics({required this.userId, required this.selectedMethod});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod];
}

class NotLoggedIn extends SecondarySalesDetailEvent {}
