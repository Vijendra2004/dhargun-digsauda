import 'package:adaniwilmar/models/stp_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

abstract class PcpState extends Equatable {
  const PcpState();
  @override
  List<Object> get props => [];
}

class InitialPcpState extends PcpState {}

class ShowProgressBar extends PcpState {}

class HideProgressBar extends PcpState {}

class OnSuccess extends PcpState {
  final WeeklyResponse response;
  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends PcpState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnLoadSuccess extends PcpState {
  final List<TotalPCPByUsersViewDto> totalPcpList;
  final List<PCPManagerList> pcpList;
  const OnLoadSuccess({required this.totalPcpList,required this.pcpList});

  @override
  // TODO: implement props
  List<Object> get props => [totalPcpList,pcpList];
}

class OnLoadPCPDetailSuccess extends PcpState {
  final PCPManagerDetail pcpDetail;
  const OnLoadPCPDetailSuccess({required this.pcpDetail});

  @override
  // TODO: implement props
  List<Object> get props => [pcpDetail];
}
