import 'package:equatable/equatable.dart';

import '../../../models/support_list_response.dart';

abstract class SupportEvent extends Equatable {
  const SupportEvent();

  @override
  List<Object> get props => [];
}

class LoadSupportScreen extends SupportEvent {
  int userId = 0;
  int raisedBy = 0;
  int statusId=1;
  int queryFrom=0;
  String fromDate="";
  String toDate="";

  LoadSupportScreen({required this.userId, required this.raisedBy,required this.statusId,required this.queryFrom,required this.fromDate,required this.toDate});

  @override
  // TODO: implement props
  List<Object> get props => [this.userId, this.raisedBy,this.statusId,this.queryFrom,this.fromDate,this.toDate];
}

class LoadOverallData extends SupportEvent {
  int userId = 0;
  int dealerId = 0;
  LoadOverallData({required this.userId, required this.dealerId});

  @override
  // TODO: implement props
  List<Object> get props => [this.userId, this.dealerId];
}

class LoadNewSupportScreen extends SupportEvent {
  int userId = 0;
  LoadNewSupportScreen({required this.userId});

  @override
  // TODO: implement props
  List<Object> get props => [this.userId];
}
class SaveSupport extends SupportEvent{
  final SupportRequest request;
  SaveSupport({required this.request});

  @override
  // TODO: implement props
  List<Object> get props => [this.request];

}
class NotLoggedIn extends SupportEvent {}
