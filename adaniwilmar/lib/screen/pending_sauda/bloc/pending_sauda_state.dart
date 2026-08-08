import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/pending_sauda_response.dart';
import 'package:adaniwilmar/models/pending_sauda_slab.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

import '../../../models/sauda_booking_status.dart';

abstract class PendingSaudaState extends Equatable {
  const PendingSaudaState();

  @override
  List<Object> get props => [];
}

class InitialPendingSaudaState extends PendingSaudaState {}

class ShowProgressBar extends PendingSaudaState {}

class HideProgressBar extends PendingSaudaState {}

class OnSuccess extends PendingSaudaState {
  final WeeklyResponse response;

  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends PendingSaudaState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnLoadSuccess extends PendingSaudaState {
  final List<PendingSauda> pendingSauda;
  final List<PendingSaudaSlab> pendingSaudaSlabs;

  const OnLoadSuccess(
      {required this.pendingSauda, required this.pendingSaudaSlabs});

  @override
  // TODO: implement props
  List<Object> get props => [pendingSauda, pendingSaudaSlabs];
}

class OnLoadChartSuccess extends PendingSaudaState {
  final List<PendingSauda> pendingSauda;
  final List<PendingSaudaSlab> pendingSaudaSlabs;

  const OnLoadChartSuccess(
      {required this.pendingSauda, required this.pendingSaudaSlabs});

  @override
  // TODO: implement props
  List<Object> get props => [pendingSauda, pendingSaudaSlabs];
}

class OnLoadPendingSauda extends PendingSaudaState {
  final List<DistributorList> distributorList;

  const OnLoadPendingSauda({required this.distributorList});

  @override
  // TODO: implement props
  List<Object> get props => [distributorList];
}

class GetSaudaBooking extends PendingSaudaState {
  final SaudaBookingStatus saudaBookingStatus;

  const GetSaudaBooking({required this.saudaBookingStatus});

  @override
  // TODO: implement props
  List<Object> get props => [saudaBookingStatus];
}
