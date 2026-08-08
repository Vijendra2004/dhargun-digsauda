import 'package:equatable/equatable.dart';

import '../../../models/SaudaModificationCreationModel.dart';

abstract class SaudaModificationAddScreenEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadModDealersList extends SaudaModificationAddScreenEvent {
  LoadModDealersList();

  @override
  List<Object> get props => [];
}

class LoadContractNumbers extends SaudaModificationAddScreenEvent {
  final int code;

  LoadContractNumbers(this.code);

  @override
  List<Object> get props => [code];
}

class LoadOilAndMaterialAPI extends SaudaModificationAddScreenEvent {
  final String id;

  LoadOilAndMaterialAPI(this.id);

  @override
  List<Object> get props => [id];
}

class LoadToSkuFromOIL extends SaudaModificationAddScreenEvent {
  final int? id;
  final int? skuId;

  LoadToSkuFromOIL(this.id,this.skuId);

  @override
  List<Object> get props => [id!,skuId!];
}
class CreateSaudaModificationEvent extends SaudaModificationAddScreenEvent {
  final SaudaModificationCreationModel  saudaModCreationmodel;

  CreateSaudaModificationEvent(this.saudaModCreationmodel);

  @override
  List<Object> get props => [saudaModCreationmodel];
}

class LoadListofOilItems extends SaudaModificationAddScreenEvent {
  final String id;

  LoadListofOilItems(this.id);

  @override
  List<Object> get props => [id];
}

class GetToSkuList extends SaudaModificationAddScreenEvent {
  final int oilTypeID,oilGrpTypeId,saudaNumber, dealerId;

  GetToSkuList(this.oilTypeID,this.oilGrpTypeId,this.saudaNumber,this.dealerId);

  @override
  List<Object> get props => [oilTypeID,oilGrpTypeId,saudaNumber,dealerId];
}






