import 'package:adaniwilmar/models/booked_sauda_response.dart';
import 'package:adaniwilmar/models/due_for_tomorrow_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class SaudaBookedStatusState extends Equatable {
  const SaudaBookedStatusState();
  @override
  List<Object> get props => [];
}

class InitialSaudaBookedStatusState extends SaudaBookedStatusState {}

class ShowProgressBar extends SaudaBookedStatusState {}

class HideProgressBar extends SaudaBookedStatusState {}

class OnSuccess extends SaudaBookedStatusState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends SaudaBookedStatusState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends SaudaBookedStatusState {
  final DueForTomorrowList response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends SaudaBookedStatusState {
  final List<SaudaBookedStatusDealerDetail> bookedSaudhas;
  const OnLoadSuccess({required this.bookedSaudhas});

  @override
  // TODO: implement props
  List<Object> get props => [bookedSaudhas];
}

class OnDealerLoadSuccess extends SaudaBookedStatusState {
  final List<BookedSaudaResponse> bookedSaudhas;
  const OnDealerLoadSuccess({required this.bookedSaudhas});

  @override
  // TODO: implement props
  List<Object> get props => [bookedSaudhas];
}
