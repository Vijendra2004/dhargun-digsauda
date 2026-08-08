
import 'package:adaniwilmar/models/SaudaModificationListModel.dart';
import 'package:equatable/equatable.dart';

 abstract class SaudaModificationListState extends Equatable{
  @override
  List<Object?> get props => [];
}

 class SaudaModList extends SaudaModificationListState {}

class ShowModListProgress extends SaudaModificationListState {}

class HideModListProgress extends SaudaModificationListState {}
class OnModListResFailure extends SaudaModificationListState {
  final String errorMessage;

  OnModListResFailure({required this.errorMessage});
}
class OnSaudaModListSuccess extends SaudaModificationListState {
 final List<DealerGroup>? pendingList;
 final List<DealerGroup>? approvedBdoDealerList;
  OnSaudaModListSuccess({required this.pendingList, required this.approvedBdoDealerList});
 @override
 // TODO: implement props
 List<Object> get props => [pendingList!,approvedBdoDealerList!];

}