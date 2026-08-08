import 'package:equatable/equatable.dart';

abstract class SaudaModificationListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSaudaModificationList extends SaudaModificationListEvent {
  String fromDate = "";
  String toDate = "";

  LoadSaudaModificationList(this.fromDate, this.toDate);

  @override
  List<Object> get props => [fromDate, toDate];
}
