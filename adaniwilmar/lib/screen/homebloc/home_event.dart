import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadHomeScreen extends HomeEvent {
  int userId = 0;
  int zhId = 0;
  int roleId = 0;
  LoadHomeScreen({required this.userId, this.zhId = 0, this.roleId = 0});

  @override
  // TODO: implement props
  List<Object> get props => [userId, zhId, roleId];
}

class LoadLastAliveTime extends HomeEvent {

  LoadLastAliveTime();

  @override
  // TODO: implement props
  List<Object> get props => [];
}


class NotifyScreen extends HomeEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadOverallData extends HomeEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  int zhId = 0;
  int roleId = 0;
  LoadOverallData(
      {required this.userId,
      required this.selectedMethod,
      this.zhId = 0,
      this.roleId = 0});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod, zhId, roleId];
}

class LoadUserStatistics extends HomeEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  int zhId = 0;
  int roleId = 0;
  LoadUserStatistics(
      {required this.userId,
      required this.selectedMethod,
      this.zhId = 0,
      this.roleId = 0});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod, zhId, roleId];
}

class ShowProgressBarEvent extends HomeEvent {}

class HideProgressBarEvent extends HomeEvent {}

class NotLoggedIn extends HomeEvent {}
