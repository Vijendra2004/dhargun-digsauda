import 'package:equatable/equatable.dart';

class MoreScreenEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetFormApi extends MoreScreenEvent {
  GetFormApi();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetTanNumbrApi extends MoreScreenEvent {
  GetTanNumbrApi();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LogOutEvent extends MoreScreenEvent {
  final int userId;

  LogOutEvent({
    required this.userId
  });

  @override
  // TODO: implement props
  List<Object> get props => [userId];
}

class TanNumberUpdate extends MoreScreenEvent {
  final String tanText;

  TanNumberUpdate(this.tanText);

  @override
  // TODO: implement props
  List<Object?> get props => [tanText];
}
