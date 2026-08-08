import 'package:adaniwilmar/models/due_for_tomorrow_response.dart';
import 'package:adaniwilmar/models/sauda_extension_list.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class SaudaExtensionState extends Equatable {
  const SaudaExtensionState();
  @override
  List<Object> get props => [];
}

class InitialSaudaExtensionState extends SaudaExtensionState {}

class ShowProgressBar extends SaudaExtensionState {}

class HideProgressBar extends SaudaExtensionState {}

class OnSuccess extends SaudaExtensionState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends SaudaExtensionState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends SaudaExtensionState {
  final DueForTomorrowList response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends SaudaExtensionState {
  final BookedSaudha bookedSaudha;
  const OnLoadSuccess({required this.bookedSaudha});

  @override
  // TODO: implement props
  List<Object> get props => [bookedSaudha];
}

class OnDealerLoadSuccess extends SaudaExtensionState {
  final DealerBookedSaudha bookedSaudha;
  const OnDealerLoadSuccess({required this.bookedSaudha});

  @override
  // TODO: implement props
  List<Object> get props => [bookedSaudha];
}
