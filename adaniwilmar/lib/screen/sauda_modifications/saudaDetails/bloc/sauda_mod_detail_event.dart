import 'package:equatable/equatable.dart';

abstract class SaudaModDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSaudaModDetails extends SaudaModDetailEvent {
  int id = 0;

  LoadSaudaModDetails(this.id);

  @override
  List<Object> get props => [id];
}
