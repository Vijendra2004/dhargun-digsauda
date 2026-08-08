import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/contract_response.dart';
import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/dealer_sauda_detail_response.dart';
import 'package:adaniwilmar/models/default_input_response.dart';
import 'package:adaniwilmar/models/filler_sku_response.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/plant_list_response.dart';
import 'package:adaniwilmar/models/skulist_response.dart';
import 'package:adaniwilmar/models/vehicle_size_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/new_sales_order_form/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../gmcore/network/GMLogger.dart';

class NewSalesOrderBloc extends Bloc<NewSalesOrderEvent, NewSalesOrderState> {
  NewSalesOrderBloc() : super(InitialNewSalesOrderState()) {
    on<LoadDefaults>((event, emit) => _getDefaults(event, emit));
    on<LoadSalesOrganization>((event, emit) => _getSalesOrganization(event, emit));
    on<LoadDealerSalesOrderDetail>((event, emit) => _getDistributorData(event, emit));
    on<LoadDistributionChannel>((event, emit) => _getDistributionChannelData(event, emit));
    on<LoadVerticalList>((event, emit) => _getVerticalData(event, emit));
    on<LoadIncoTerms>((event, emit) => _getIncoTermsData(event, emit));
    on<LoadPlant>((event, emit) => _getPlantData(event, emit));
    on<LoadOilType>((event, emit) => _getOilTypeData(event, emit));
    on<LoadBDO>((event, emit) => _getBdoList(event, emit));
    // on<LoadOverallData>((event, emit) => _getOverallData(event,emit));
    on<LoadNewSalesOrderScreen>((event, emit) => _getDistributorList(event, emit));
    on<LoadSKUDetails>((event, emit) => _getSKUData(event, emit));
    on<SaveSalesOrder>((event, emit) => _saveSalesOrder(event, emit));
    on<ChangeRate>((event, emit) => _changeRate(event, emit));
    on<LoadShipToParty>((event, emit) => _getShiptoParty(event, emit));
    on<LoadContractDetail>((event, emit) => _getContractDetail(event, emit));
    on<LoadFillerSKUDetails>((event, emit) => _getFillerSKUData(event, emit));
  }

  @override
  NewSalesOrderState get initialState => InitialNewSalesOrderState();

  Future<void> _getDistributorList(LoadNewSalesOrderScreen event, Emitter<NewSalesOrderState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList =
          await ServiceRepository().getDealerByUserIdList(Constants.AUTH_USERID, event.salesOrganizationId, event.distributionChannelId, event.divisonId, bdoIds: event.bdoId > 0 ? [event.bdoId] : []);
      GMLogger.v("Dealer123" + metaDealerList.statusMsg);
      List<DistributorList> distList = [];
      if (metaDealerList.statusCode == 200) {
        jsonDecode(metaDealerList.statusMsg)['response'].forEach((f) => distList.add(DistributorList.fromJson(f)));
      }
      if (metaDealerList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSuccess(distributorList: distList));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaDealerList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getDefaults(LoadDefaults event, Emitter<NewSalesOrderState> emit) async {
    try {
      emit(ShowProgressBar());
      DefaultInputResponse userDefaults = DefaultInputResponse(salesOrganizationId: 0, distrinbutionChannelId: 0, divisionId: 0, stateId: 0, plantId: 0);
      if (Constants.AUTH_ROLEID != Constants.DEALER) {
        Meta defaults = await ServiceRepository().getSalesOrderDataDetails(event.id);
        GMLogger.v("Sales" + defaults.statusMsg);
        GMLogger.v("Sales" + defaults.statusCode.toString());
        if (defaults.statusCode == 200) {
          userDefaults = DefaultInputResponse.fromJson(jsonDecode(defaults.statusMsg)['response']);
        }

        if (defaults.statusCode == 200) {
          emit(HideProgressBar());
          emit(OnLoadDefaults(defaults: userDefaults));
        } else {
          emit(HideProgressBar());
          emit(OnFailure(error: defaults.statusMsg));
        }
      } else {
        emit(HideProgressBar());
        emit(OnLoadDefaults(defaults: userDefaults));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getSalesOrganization(LoadSalesOrganization event, Emitter<NewSalesOrderState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg = await ServiceRepository().getSalesOrganization(Constants.AUTH_SELECTED_STATEID);
      GMLogger.v("Sales" + salesOrg.statusMsg);
      GMLogger.v("Sales" + salesOrg.statusCode.toString());
      List<SalesOrganization> salesOrgList = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response'].forEach((f) => salesOrgList.add(SalesOrganization.fromJson(f)));
      }

      Meta salesOrg1 = await ServiceRepository().getGetShipToPartyListByCustomerId(Constants.AUTH_USERID);
      GMLogger.v("Party" + salesOrg1.statusMsg);
      GMLogger.v("Party" + salesOrg1.statusCode.toString());

      if (salesOrg.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSalesOrganization(salesOrganization: salesOrgList));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: salesOrg.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getShiptoParty(LoadShipToParty event, Emitter<NewSalesOrderState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg1 = await ServiceRepository().getGetShipToPartyListByCustomerId(event.distributorId);
      GMLogger.v("Party" + salesOrg1.statusMsg);
      GMLogger.v("Party" + salesOrg1.statusCode.toString());
      List<DistributorList> shiptoParty = [];
      if (salesOrg1.statusCode == 200) {
        jsonDecode(salesOrg1.statusMsg)['response'].forEach((f) => shiptoParty.add(DistributorList.fromJson(f)));
      }

      Meta salesOrg2 = await ServiceRepository().getLoadabilityList(event.distributorId);
      GMLogger.v("Load" + salesOrg2.statusMsg);
      GMLogger.v("Load" + salesOrg2.statusCode.toString());
      List<VehicleSize> vehicleSizes = [];
      if (salesOrg2.statusCode == 200) {
        jsonDecode(salesOrg2.statusMsg)['response'].forEach((f) => vehicleSizes.add(VehicleSize.fromJson(f)));
      }

      if (salesOrg1.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadShipToParty(shipToParty: shiptoParty, vehicleSize: vehicleSizes, contracts: []));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: salesOrg1.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getDistributorData(LoadDealerSalesOrderDetail event, Emitter<NewSalesOrderState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta dealerSalesOrderDetails = await ServiceRepository().getDealerSaudaDetails(event.id, event.salesOrganizationId!, event.distributionChannelId!, event.divisionId!);
      DealerSaudaDetail saudaDetail = DealerSaudaDetail();
      if (dealerSalesOrderDetails.statusCode == 200) {
        GMLogger.v(dealerSalesOrderDetails.statusMsg);
        saudaDetail = DealerSaudaDetail.fromJson(jsonDecode(dealerSalesOrderDetails.statusMsg)['response']);
      }

      if (dealerSalesOrderDetails.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadDealerSalesOrderDetail(dealerSalesOrderDetail: saudaDetail, skuDetail: []));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: dealerSalesOrderDetails.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getSKUData(LoadSKUDetails event, Emitter<NewSalesOrderState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaSkuList = await ServiceRepository().getSkuListForSalesOrder(event.dealerId, Constants.AUTH_USERID, event.saudaNumber, event.plantId, event.oilTypeId, event.vehicleSize);
      List<SKUList> skuList = [];
      GMLogger.v(metaSkuList.statusMsg);
      if (metaSkuList.statusCode == 200) {
        jsonDecode(metaSkuList.statusMsg)['response'].forEach((f) => skuList.add(SKUList.fromJson(f)));
      }

      if (metaSkuList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSKUDetails(skuList: skuList, isPopup: event.popup));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaSkuList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getFillerSKUData(LoadFillerSKUDetails event, Emitter<NewSalesOrderState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaSkuList = await ServiceRepository().getFillerSKUList(Constants.AUTH_USERID, event.dealerId, event.volumePercentage, event.weightPercentage, event.vehicleSize, event.plantId);
      List<FillerSKU> skuList = [];
      if (metaSkuList.statusCode == 200) {
        jsonDecode(metaSkuList.statusMsg)['response'].forEach((f) => skuList.add(FillerSKU.fromJson(f)));
      }

      if (metaSkuList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadFillerSKUDetails(skuList: skuList));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaSkuList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getDistributionChannelData(LoadDistributionChannel event, Emitter<NewSalesOrderState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg = await ServiceRepository().getDistributionChannel(event.id);
      GMLogger.v("Dealer" + salesOrg.statusMsg);
      GMLogger.v("Dealer" + salesOrg.statusCode.toString());
      List<DistributionChannel> distrChannels = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response'].forEach((f) => distrChannels.add(DistributionChannel.fromJson(f)));
      }

      if (salesOrg.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadDistributionChannel(distributionChannel: distrChannels));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: salesOrg.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getVerticalData(LoadVerticalList event, Emitter<NewSalesOrderState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg = await ServiceRepository().getVertical(event.distributionId);
      GMLogger.v("Dealer" + salesOrg.statusMsg);
      GMLogger.v("Dealer" + salesOrg.statusCode.toString());
      List<Vertical> verticals = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response'].forEach((f) => verticals.add(Vertical.fromJson(f)));
      }

      if (salesOrg.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadVerticalList(verticalList: verticals));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: salesOrg.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getOilTypeData(LoadOilType event, Emitter<NewSalesOrderState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg = await ServiceRepository().getOilTypeList(Constants.AUTH_USERID, salesOrgId: event.salesOrganizationId, distriChannelId: event.distributionChannelId, divisionId: event.divisonId);
      GMLogger.v("oil" + salesOrg.statusMsg);
      GMLogger.v("oil" + salesOrg.statusCode.toString());
      List<OilType> oilTypes = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response'].forEach((f) => oilTypes.add(OilType.fromJson(f)));
      }

      if (salesOrg.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadOilType(oilTypes: oilTypes));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: salesOrg.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getIncoTermsData(LoadIncoTerms event, Emitter<NewSalesOrderState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg = await ServiceRepository().getIncoTermsList();
      GMLogger.v("Dealer" + salesOrg.statusMsg);
      GMLogger.v("Dealer" + salesOrg.statusCode.toString());
      List<IncoTerms> incoTerms = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response'].forEach((f) => incoTerms.add(IncoTerms.fromJson(f)));
      }

      if (salesOrg.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadIncoTerms(incoTerms: incoTerms));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: salesOrg.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getPlantData(LoadPlant event, Emitter<NewSalesOrderState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg = await ServiceRepository().getPlantList();
      GMLogger.v("Dealer" + salesOrg.statusMsg);
      GMLogger.v("Dealer" + salesOrg.statusCode.toString());
      List<PlanDepotList> plants = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response'].forEach((f) => plants.add(PlanDepotList.fromJson(f)));
      }

      if (salesOrg.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadPlant(plantList: plants));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: salesOrg.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  // @override
  // Future<void> _getOverallData(LoadOverallData event,Emitter<NewSalesOrderState> emit)async {
  //   try {
  //     emit(ShowProgressBar());
  //     Meta meta = await ServiceRepository().getDailyRateNew(Constants.AUTH_USERID,"0",event.oilTypeId.toString(),event.incoTermId.toString(),"1","0");
  //     GMLogger.v(meta.statusMsg);
  //     GMLogger.v(meta.statusCode.toString());
  //     if (meta.statusCode == 200) {
  //       emit(HideProgressBar());
  //       List<DailyRate> dailyRate = [];
  //       if (meta.statusCode == 200) {
  //         jsonDecode(meta.statusMsg)['response']
  //             .forEach((f) => dailyRate.add(new DailyRate.fromJson(f)));
  //       }
  //       GMLogger.v(" res:"+dailyRate.toString());
  //       emit(OnOverallSuccess(response: dailyRate));
  //     } else {
  //       emit(HideProgressBar());
  //       emit(OnFailure(error: meta.statusMsg));
  //     }
  //   } catch (error) {
  //     GMLogger.v(error.toString());
  //     emit(HideProgressBar());
  //     emit(OnFailure(error: error.toString()));
  //   }
  // }
  Future<void> _saveSalesOrder(SaveSalesOrder event, Emitter<NewSalesOrderState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta savedSalesOrder = await ServiceRepository().saveSalesOrder(event.request);
      GMLogger.v(savedSalesOrder.statusCode.toString());
      GMLogger.v(savedSalesOrder.statusMsg);
      if (savedSalesOrder.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnSaveSalesOrder(message: jsonDecode(savedSalesOrder.statusMsg)['response']));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: savedSalesOrder.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _changeRate(ChangeRate event, Emitter<NewSalesOrderState> emit) async {
    emit(OnRateChange(change: event.popup));
  }

  Future<void> _getBdoList(LoadBDO event, Emitter<NewSalesOrderState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList = await ServiceRepository().getBDOList(Constants.AUTH_USERID);
      List<BdoList> bdoList = [];
      if (event.showAll) {
        BdoList bdo = BdoList();
        bdo.id = 0;
        bdo.name = "All State Traders";
        bdoList.add(bdo);
      }
      if (metaDealerList.statusCode == 200) {
        jsonDecode(metaDealerList.statusMsg)['response'].forEach((f) => bdoList.add(BdoList.fromJson(f)));
      }
      if (metaDealerList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadBDO(bdoList: bdoList));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaDealerList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getContractDetail(LoadContractDetail event, Emitter<NewSalesOrderState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta contract = await ServiceRepository().getContractList(event.distributorId, event.salesOrgId, event.skuId);
      GMLogger.v("contract" + contract.statusMsg);
      GMLogger.v("contract" + contract.statusCode.toString());
      List<Contract> contracts = [];
      if (contract.statusCode == 200) {
        jsonDecode(contract.statusMsg)['response'].forEach((f) => contracts.add(Contract.fromJson(f)));
      }

      if (contract.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadContract(contracts: contracts));
      } else {
        emit(HideProgressBar());
        emit(const OnLoadContract(contracts: []));
        emit(OnFailure(error: contract.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }
}
