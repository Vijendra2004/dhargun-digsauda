import 'package:adaniwilmar/models/customer_audio_file.dart';
import 'package:equatable/equatable.dart';

abstract class SaudaDetailEvent extends Equatable {
  const SaudaDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadSaudaDetailScreen extends SaudaDetailEvent {
  int userId = 0;
  int saudaId = 0;

  LoadSaudaDetailScreen({required this.userId, required this.saudaId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, saudaId];
}

class LoadCustomerAudioList extends SaudaDetailEvent {
  int dealerId = 0;
  int brokerId = 0;

  LoadCustomerAudioList({required this.dealerId, required this.brokerId});

  @override
  // TODO: implement props
  List<Object> get props => [dealerId, brokerId];
}

class SaveAudioList extends SaudaDetailEvent {
  SaveAudioRequest request;

  SaveAudioList({required this.request});

  @override
  // TODO: implement props
  List<Object> get props => [request];
}

class LoadOverallData extends SaudaDetailEvent {
  int userId = 0;
  int dealerId = 0;
  LoadOverallData({required this.userId, required this.dealerId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, dealerId];
}

class LoadUserStatistics extends SaudaDetailEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  LoadUserStatistics({required this.userId, required this.selectedMethod});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod];
}

class NotLoggedIn extends SaudaDetailEvent {}
