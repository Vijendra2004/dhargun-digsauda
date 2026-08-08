import 'package:adaniwilmar/models/SaudaDetailModel.dart';
import 'package:adaniwilmar/models/SaudaModificationListModel.dart';
import 'package:equatable/equatable.dart';

abstract class SaudaModDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SaudaModDetails extends SaudaModDetailState{}

class OnSaudaModDetailSuccess extends SaudaModDetailState {
  final ModResponseData lineItems;

  OnSaudaModDetailSuccess(this.lineItems);

  @override
  List<Object?> get props => [lineItems];
}

class ShowModDetailProgress extends SaudaModDetailState {}

class HideModDetalProgress extends SaudaModDetailState {}

class OnModDetailResFailure extends SaudaModDetailState {
  final String errorMessage;

  OnModDetailResFailure({required this.errorMessage});
}
