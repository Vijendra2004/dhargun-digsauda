import 'package:equatable/equatable.dart';

abstract class QuantityAllocationEvent extends Equatable {
  const QuantityAllocationEvent();

  @override
  List<Object> get props => [];
}

class LoadQuantityAllocationRequest extends QuantityAllocationEvent {
  int userId = 0;

  LoadQuantityAllocationRequest({
    required this.userId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [userId];
}

class LoadOverallData extends QuantityAllocationEvent {
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

class LoadOilType extends QuantityAllocationEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SaveQuantityRequest extends QuantityAllocationEvent {
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

class NotLoggedIn extends QuantityAllocationEvent {}
