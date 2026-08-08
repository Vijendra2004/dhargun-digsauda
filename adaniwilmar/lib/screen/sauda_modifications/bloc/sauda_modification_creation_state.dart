import 'package:adaniwilmar/models/DistributorListModel.dart';
import 'package:adaniwilmar/models/OilResponseModel.dart';
import 'package:adaniwilmar/models/ToSKUUpdateModel.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../models/ContractNoModel.dart';
import '../../../models/ModOilMaterialResponse.dart';
import '../../../models/toSkuResponseModel.dart';

@immutable
abstract class SaudaModificationAddScreenState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SaudaModScreenInitial extends SaudaModificationAddScreenState {}

class ShowModProgressBar extends SaudaModificationAddScreenState {}

class HideModProgressBar extends SaudaModificationAddScreenState {}

class OnModResFailure extends SaudaModificationAddScreenState {
  final String errorMessage;

  OnModResFailure({required this.errorMessage});
}

class OnDisModSuccess extends SaudaModificationAddScreenState {
  final List<DistributorListItem>? distItems;

  OnDisModSuccess({required this.distItems});
}

class onLoadContractNumbers extends SaudaModificationAddScreenState {
  final List<ContractNoItem>? contractItem;

  onLoadContractNumbers({required this.contractItem});
}

class OnLoadModOilList extends SaudaModificationAddScreenState {
  final List<ModOilMaterial>? oiltItems;

  OnLoadModOilList({required this.oiltItems});
}

class onLoadToSkuItems extends SaudaModificationAddScreenState {
  final List<ToSkuItemResp>? toSkuItems;

  onLoadToSkuItems({required this.toSkuItems});
}

class OnSaudaModCreationSuccess extends SaudaModificationAddScreenState {
  final String message;

  OnSaudaModCreationSuccess({required this.message});
}

class OnLoadOilListItems extends SaudaModificationAddScreenState {
  final List<OilType>? oilNoItems;

  OnLoadOilListItems({required this.oilNoItems});
}

class OnSaudaModificationToSku extends SaudaModificationAddScreenState {
  final List<ToSKUItem>? skuItem;

  OnSaudaModificationToSku({required this.skuItem});
}


