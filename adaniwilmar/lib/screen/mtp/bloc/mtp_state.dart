import 'package:adaniwilmar/models/due_for_tomorrow_response.dart';
import 'package:adaniwilmar/models/stp_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class MtpState extends Equatable {
  const MtpState();
  @override
  List<Object> get props => [];
}

class InitialMtpState extends MtpState {}

class ShowProgressBar extends MtpState {}

class HideProgressBar extends MtpState {}

class OnSuccess extends MtpState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends MtpState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnOverallSuccess extends MtpState {
  final DueForTomorrowList response;
  const OnOverallSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnLoadSuccess extends MtpState {
  List<CurrentOrUpcomingmonthViewDto> mtpCurrentList = [];
  List<CurrentOrUpcomingmonthViewDto> mtpUpcomingList = [];
  List<MTPManagerList> mtpManagerCurrentList = [];
  List<MTPManagerList> mtpManagerUpcomingList = [];

  OnLoadSuccess({required this.mtpCurrentList,
    required this.mtpUpcomingList,required this.mtpManagerCurrentList,required this.mtpManagerUpcomingList});

  @override
  // TODO: implement props
  List<Object> get props => [mtpCurrentList, mtpUpcomingList,mtpManagerCurrentList,mtpManagerUpcomingList];
}

class OnLoadMTPDetailSuccess extends MtpState {
  final MTPManagerDetail mtpDetail;
  const OnLoadMTPDetailSuccess({required this.mtpDetail});

  @override
  // TODO: implement props
  List<Object> get props => [mtpDetail];
}
