import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/sauda_extension_request.dart';
import 'package:equatable/equatable.dart';

abstract class SaudaExtensionDetailEvent extends Equatable {
  const SaudaExtensionDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadSaudaExtensionDetailScreen extends SaudaExtensionDetailEvent {
  int userId = 0;
  String fromDate = "";
  String toDate = "";
  int dealerId=0;
  int bdoId=0;
  int oilTypeId=0;
  LoadSaudaExtensionDetailScreen(
      {required this.userId, required this.fromDate, required this.toDate,this.oilTypeId=0,this.bdoId=0,this.dealerId=0});

  @override
  // TODO: implement props
  List<Object> get props => [userId, fromDate, toDate,dealerId,bdoId,oilTypeId];
}

class LoadOverallData extends SaudaExtensionDetailEvent {
  int userId = 0;
  int dealerId = 0;
  LoadOverallData({required this.userId, required this.dealerId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, dealerId];
}

class LoadNewSaudaExtensionScreen extends SaudaExtensionDetailEvent {
  int userId = 0;
  int salesOrganizationId = 0;
  int distributionChannelId = 0;
  int divisonId = 0;
  int bdoId=0;
  LoadNewSaudaExtensionScreen(
      {required this.userId,
        required this.salesOrganizationId,
        required this.distributionChannelId,
        required this.divisonId,
      this.bdoId=0});

  @override
  // TODO: implement props
  List<Object> get props =>
      [userId, salesOrganizationId, distributionChannelId, divisonId,bdoId];
}

class LoadBdo extends SaudaExtensionDetailEvent {
  int userId = 0;
  LoadBdo(
      {required this.userId,
        });

  @override
  // TODO: implement props
  List<Object> get props =>
      [userId];
}

class LoadOilType extends SaudaExtensionDetailEvent {
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

class SaveSaudaExtension extends SaudaExtensionDetailEvent {
  SaudaExtensionRequest request;
  SaveSaudaExtension({required this.request});

  @override
  // TODO: implement props
  List<Object> get props => [request];
}

class NotLoggedIn extends SaudaExtensionDetailEvent {}
