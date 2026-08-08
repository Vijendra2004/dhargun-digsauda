import 'package:adaniwilmar/models/due_for_tomorrow_response.dart';
import 'package:adaniwilmar/models/sauda_extension_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class SaudaExtensionDetailState extends Equatable {
  const SaudaExtensionDetailState();
  @override
  List<Object> get props => [];
}

class InitialSaudaExtensionDetailState extends SaudaExtensionDetailState {}

class ShowProgressBar extends SaudaExtensionDetailState {}

class HideProgressBar extends SaudaExtensionDetailState {}

class OnSuccess extends SaudaExtensionDetailState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends SaudaExtensionDetailState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends SaudaExtensionDetailState {
  final DueForTomorrowList response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends SaudaExtensionDetailState {
  final List<SaudaExtension> saudaExtensions;
  const OnLoadSuccess({required this.saudaExtensions});

  @override
  // TODO: implement props
  List<Object> get props => [saudaExtensions];
}

class OnSaveSuccess extends SaudaExtensionDetailState {
  final bool saved;
  const OnSaveSuccess({required this.saved});

  @override
  // TODO: implement props
  List<Object> get props => [saved];
}
