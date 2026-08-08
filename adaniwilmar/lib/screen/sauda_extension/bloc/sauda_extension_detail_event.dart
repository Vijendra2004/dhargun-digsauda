import 'package:adaniwilmar/models/sauda_extension_request.dart';
import 'package:equatable/equatable.dart';

abstract class SaudaExtensionDetailEvent extends Equatable {
  const SaudaExtensionDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadSaudaExtensionDetailScreen extends SaudaExtensionDetailEvent {
  int userId = 0;
  String fromDate = "";
  String toDate = "";

  LoadSaudaExtensionDetailScreen(
      {required this.userId, required this.fromDate, required this.toDate});

  @override
  // TODO: implement props
  List<Object> get props => [userId, fromDate, toDate];
}

class LoadOverallData extends SaudaExtensionDetailEvent {
  int userId = 0;
  int dealerId = 0;
  LoadOverallData({required this.userId, required this.dealerId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, dealerId];
}

class LoadUserStatistics extends SaudaExtensionDetailEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  LoadUserStatistics({required this.userId, required this.selectedMethod});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod];
}

class SaveSaudaExtension extends SaudaExtensionDetailEvent {
  SaudaExtensionRequest request;
  SaveSaudaExtension({required this.request});

  @override
  // TODO: implement props
  List<Object> get props => [request];
}

class NotLoggedIn extends SaudaExtensionDetailEvent {}
