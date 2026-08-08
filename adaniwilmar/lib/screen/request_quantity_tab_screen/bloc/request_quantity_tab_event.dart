import 'package:equatable/equatable.dart';

abstract class RequestQuantityTabEvent extends Equatable {
  const RequestQuantityTabEvent();

  @override
  List<Object> get props => [];
}

class LoadQuantityAllocationRequest extends RequestQuantityTabEvent {
  int userId = 0;

  LoadQuantityAllocationRequest({
    required this.userId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [userId];
}

class LoadOverallData extends RequestQuantityTabEvent {
  int userId = 0;
  int oilTypeId = 0;
  LoadOverallData({
    required this.userId,
    required this.oilTypeId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [userId, oilTypeId];
}

class LoadOilType extends RequestQuantityTabEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SaveQuantityRequest extends RequestQuantityTabEvent {
  int userId = 0;
  int oilTypeId = 0;
  int specialtyLimitId=0;
  int skuId=0;
  double quantity=0;
  SaveQuantityRequest({
    required this.userId,
    required this.oilTypeId,
    required this.specialtyLimitId,
    required this.skuId,
    required this.quantity
  });

  @override
  // TODO: implement props
  List<Object> get props => [userId, oilTypeId,specialtyLimitId,skuId,quantity];
}

class NotLoggedIn extends RequestQuantityTabEvent {}
