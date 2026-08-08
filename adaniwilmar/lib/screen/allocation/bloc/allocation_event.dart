import 'package:adaniwilmar/models/limit_enhancement_request.dart';
import 'package:adaniwilmar/models/qty_allocation.dart';
import 'package:equatable/equatable.dart';

abstract class AllocationEvent extends Equatable {
  const AllocationEvent();

  @override
  List<Object> get props => [];
}

class LoadAllocationScreen extends AllocationEvent {
  int userId = 0;
  int salesOrganizationId = 0;
  int distributionChannelId = 0;
  int divisonId = 0;
  LoadAllocationScreen(
      {required this.userId,
        required this.salesOrganizationId,
        required this.distributionChannelId,
        required this.divisonId});

  @override
  // TODO: implement props
  List<Object> get props =>
      [userId, salesOrganizationId, distributionChannelId, divisonId];
}

class LoadOverallData extends AllocationEvent {
  int userId = 0;
  int oilTypeId = 0;
  int plantId = 0;
  int verticalId = 0;
  int incoTermId = 0;
  LoadOverallData(
      {required this.userId,
        required this.oilTypeId,
        required this.plantId,
        required this.verticalId,
        required this.incoTermId});

  @override
  // TODO: implement props
  List<Object> get props =>
      [userId, oilTypeId, plantId, verticalId, incoTermId];
}

class LoadDealerSaudaDetail extends AllocationEvent {
  int id = 0;
  int saudaBookingTypeId = 0;
  int salesOrganizationId = 0;
  int distributionChannelId = 0;
  int divisionId = 0;
  LoadDealerSaudaDetail(
      {required this.id,
        required this.saudaBookingTypeId,
        required this.salesOrganizationId,
        required this.distributionChannelId,
        required this.divisionId});

  @override
  // TODO: implement props
  List<Object> get props => [
    id,
    saudaBookingTypeId,
    salesOrganizationId,
    distributionChannelId,
    divisionId
  ];
}

class LoadSalesOrganization extends AllocationEvent {
  int id = 0;
  int saudaBookingTypeId = 0;
  LoadSalesOrganization({required this.id, required this.saudaBookingTypeId});

  @override
  // TODO: implement props
  List<Object> get props => [id, saudaBookingTypeId];
}

class LoadDistributionChannel extends AllocationEvent {
  int id = 0;
  LoadDistributionChannel({
    required this.id,
  });

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class LoadVerticalList extends AllocationEvent {
  int distributionId = 0;
  LoadVerticalList({
    required this.distributionId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [distributionId];
}

class LoadOilType extends AllocationEvent {
  int salesOrganizationId = 0;
  int distributionChannelId = 0;
  int divisonId = 0;
  int userId = 0;
  LoadOilType(
      {required this.userId,
        required this.salesOrganizationId,
        required this.distributionChannelId,
        required this.divisonId});

  @override
  // TODO: implement props
  List<Object> get props =>
      [userId, salesOrganizationId, distributionChannelId, divisonId];
}

class LoadIncoTerms extends AllocationEvent {
  @override
// TODO: implement props
  List<Object> get props => [];
}

class LoadPlant extends AllocationEvent {
  int stateId = 0;
  LoadPlant({
    required this.stateId,
  });
  @override
  // TODO: implement props
  List<Object> get props => [stateId];
}

class LoadSKUDetails extends AllocationEvent {
  int userId = 0;
  int oilTypeId = 0;
  LoadSKUDetails(
      {required this.userId,
        required this.oilTypeId,
        });
  @override
  // TODO: implement props
  List<Object> get props =>
      [userId, oilTypeId];
}
class LoadZonalHead extends AllocationEvent {
  int userId = 0;
  LoadZonalHead({
    required this.userId,
  });
  @override
  // TODO: implement props
  List<Object> get props => [userId];
}


class LoadUserStatistics extends AllocationEvent {
  int userId = 0;
  String selectedMethod = "MTD";
  LoadUserStatistics({required this.userId, required this.selectedMethod});

  @override
  // TODO: implement props
  List<Object> get props => [userId, selectedMethod];
}

class SaveQuantityLimit extends AllocationEvent {
  final CreateQuantityLimitRequest request;
  const SaveQuantityLimit({
    required this.request,
  });

  @override
  // TODO: implement props
  List<Object> get props => [request];
}

class UpdateQuantityLimit extends AllocationEvent {
  final UpdateQuantityLimitRequest request;
  const UpdateQuantityLimit({
    required this.request,
  });

  @override
  // TODO: implement props
  List<Object> get props => [request];
}

class SaveAllocateQuantityLimit extends AllocationEvent {
  final AllocateQuantityLimitRequest request;
  const SaveAllocateQuantityLimit({
    required this.request,
  });

  @override
  // TODO: implement props
  List<Object> get props => [request];
}

class UpdateAssignedQuantityLimit extends AllocationEvent {
  final AssignedQuantityLimitRequest request;
  const UpdateAssignedQuantityLimit({
    required this.request,
  });

  @override
  // TODO: implement props
  List<Object> get props => [request];
}

class ChangeRate extends AllocationEvent {
  final bool popup;
  const ChangeRate({this.popup = false});

  @override
  // TODO: implement props
  List<Object> get props => [popup];
}

class NotLoggedIn extends AllocationEvent {}

class LoadAllocationHistoryScreen
    extends AllocationEvent {
  int userId = 0;
  int id = 0;
  LoadAllocationHistoryScreen({
    required this.userId,
    required this.id,
  });

  @override
  // TODO: implement props
  List<Object> get props => [userId, id];
}

class LoadUpdateQuantityLimitData extends AllocationEvent {
  int userId = 0;
  bool assignedLimit=false;
  LoadUpdateQuantityLimitData(
      {required this.userId,this.assignedLimit=false});

  @override
  // TODO: implement props
  List<Object> get props =>
      [userId,assignedLimit];
}

class LoadUserQuantityLimitData extends AllocationEvent {
  int userId = 0;
  LoadUserQuantityLimitData(
      {required this.userId});

  @override
  // TODO: implement props
  List<Object> get props =>
      [userId];
}
