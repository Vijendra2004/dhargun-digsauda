import 'package:adaniwilmar/models/customer_audio_file.dart';
import 'package:adaniwilmar/models/due_for_tomorrow_response.dart';
import 'package:adaniwilmar/models/sauda_detail_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class SaudaDetailState extends Equatable {
  const SaudaDetailState();
  @override
  List<Object> get props => [];
}

class InitialSaudaDetailState extends SaudaDetailState {}

class ShowProgressBar extends SaudaDetailState {}

class HideProgressBar extends SaudaDetailState {}

class OnSuccess extends SaudaDetailState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends SaudaDetailState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends SaudaDetailState {
  final DueForTomorrowList response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends SaudaDetailState {
  final SaudaDetailResponse saudaDetailResponse;
  const OnLoadSuccess({required this.saudaDetailResponse});

  @override
  // TODO: implement props
  List<Object> get props => [saudaDetailResponse];
}

class OnLoadCustomerAudio extends SaudaDetailState {
  final List<CustomerAudioFile> audioResponse;
  const OnLoadCustomerAudio({required this.audioResponse});

  @override
  // TODO: implement props
  List<Object> get props => [audioResponse];
}
class OnSaveSuccess extends SaudaDetailState {
  final String response;
  OnSaveSuccess({required this.response});
  @override
  // TODO: implement props
  List<Object> get props => [response];
}
