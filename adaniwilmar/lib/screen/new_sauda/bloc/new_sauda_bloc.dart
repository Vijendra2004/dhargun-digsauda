import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/EssentialSkuMapping.dart';
import 'package:adaniwilmar/models/bdo_list_response.dart';
import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/dealer_sauda_detail_response.dart';
import 'package:adaniwilmar/models/default_input_response.dart';
import 'package:adaniwilmar/models/oiltype_response.dart';
import 'package:adaniwilmar/models/plant_list_response.dart';
import 'package:adaniwilmar/models/sku_pricing_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/new_sauda/bloc/bloc.dart';
import 'package:adaniwilmar/screen/new_sauda/bloc/new_sauda_state.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../gmcore/network/GMLogger.dart';
import '../../../models/qps_req_model.dart';
import '../../../models/qps_res_model.dart';
import '../../../models/sauda_booking_status.dart';

class NewSaudaBloc extends Bloc<NewSaudaEvent, NewSaudaState> {
  NewSaudaBloc() : super(InitialNewSaudaState()) {
    on<LoadDefaults>((event, emit) => _getDefaults(event, emit));
    on<LoadSalesOrganization>((event, emit) => _getSalesOrganization(event, emit));
    on<LoadDealerSaudaDetail>((event, emit) => _getDistributorData(event, emit));
    on<LoadDistributionChannel>((event, emit) => _getDistributionChannelData(event, emit));
    on<LoadVerticalList>((event, emit) => _getVerticalData(event, emit));
    on<LoadIncoTerms>((event, emit) => _getIncoTermsData(event, emit));
    on<LoadPlant>((event, emit) => _getPlantData(event, emit));
    on<LoadOilType>((event, emit) => _getOilTypeData(event, emit));
    on<LoadBDO>((event, emit) => _getBdoList(event, emit));
    // on<LoadOverallData>((event, emit) => _getOverallData(event,emit));
    on<MandatorySkus>((event, emit) => _getCrossAndUpSellMandatory(event,emit));
    on<LoadNewSaudaScreen>((event, emit) => _getDistributorList(event, emit));
    on<LoadSKUDetails>((event, emit) => _getSKUData(event, emit));
    on<SaveSauda>((event, emit) => _saveSauda(event, emit));
    on<ChangeRate>((event, emit) => _changeRate(event, emit));
    on<OnLoadSaudaRestriction>((event, emit) => _getSaudhaRestriction(event, emit));
    on<OnLoadQPS>((event, emit) => _getQPS(event, emit));
    on<OnLoadQPSDiscountList>((event, emit) => _getListOfQPSDiscount(event, emit));
  }

  NewSaudaState get initialState => InitialNewSaudaState();

  Future<void> _getDistributorList(LoadNewSaudaScreen event, Emitter<NewSaudaState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList =
          await ServiceRepository().getDealerByUserIdList(Constants.AUTH_USERID, event.salesOrganizationId, event.distributionChannelId, event.divisonId, bdoIds: event.bdoId > 0 ? [event.bdoId] : []);
      List<DistributorList> distList = [];
      if (metaDealerList.statusCode == 200) {
        jsonDecode(metaDealerList.statusMsg)['response'].forEach((f) => distList.add(DistributorList.fromJson(f)));
        // }
        // if (metaDealerList.statusCode == 200) {
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

  Future<void> _getSaudhaRestriction(OnLoadSaudaRestriction event, Emitter<NewSaudaState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList = await ServiceRepository()
          .getSaudhaRestriction(Constants.AUTH_USERID, event.salesOrganizationId, event.distributionChannelId, event.divisonId, event.stateTraderId, event.dealerId, event.skuId);

      SaudaBookingStatus saudaBookingStatus = SaudaBookingStatus();
      if (metaDealerList.statusCode == 200) {
        saudaBookingStatus = SaudaBookingStatus.fromJson(jsonDecode(metaDealerList.statusMsg)['response']);
        emit(HideProgressBar());
        emit(OnGetSaudaBooking(saudaBookingStatus: saudaBookingStatus));
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

  Future<void> _getDefaults(LoadDefaults event, Emitter<NewSaudaState> emit) async {
    try {
      emit(ShowProgressBar());
      DefaultInputResponse userDefaults = DefaultInputResponse(salesOrganizationId: 0, distrinbutionChannelId: 0, divisionId: 0, stateId: 0, plantId: 0);
      if (Constants.AUTH_ROLEID != Constants.DEALER) {
        Meta defaults = await ServiceRepository().getDealerSaudaDefaultDetails(event.id);
        GMLogger.v("Sales" + defaults.statusMsg);
        GMLogger.v("Sales" + defaults.statusCode.toString());
        DefaultInputResponse userDefaults = DefaultInputResponse(salesOrganizationId: 0, distrinbutionChannelId: 0, divisionId: 0, stateId: 0, plantId: 0);
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

  Future<void> _getSalesOrganization(LoadSalesOrganization event, Emitter<NewSaudaState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg = await ServiceRepository().getSalesOrganization(Constants.AUTH_SELECTED_STATEID);
      GMLogger.v("Sales" + salesOrg.statusMsg);
      GMLogger.v("Sales" + salesOrg.statusCode.toString());
      List<SalesOrganization> salesOrgList = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response'].forEach((f) => salesOrgList.add(SalesOrganization.fromJson(f)));
      }

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

  Future<void> _getDistributorData(LoadDealerSaudaDetail event, Emitter<NewSaudaState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta dealerSaudaDetails = await ServiceRepository().getDealerSaudaDetails(event.id, event.salesOrganizationId, event.distributionChannelId, event.divisionId);
      DealerSaudaDetail saudaDetail = DealerSaudaDetail();
      if (dealerSaudaDetails.statusCode == 200) {
        GMLogger.v(dealerSaudaDetails.statusMsg);
        saudaDetail = DealerSaudaDetail.fromJson(jsonDecode(dealerSaudaDetails.statusMsg)['response']);
      }

      if (dealerSaudaDetails.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadDealerSaudaDetail(dealerSaudaDetail: saudaDetail, skuDetail: const [], loadLimit: event.loadLimit));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: dealerSaudaDetails.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getSKUData(LoadSKUDetails event, Emitter<NewSaudaState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaSkuList;
      if (Constants.AUTH_ROLEID == Constants.DEALER && event.popup) {
        metaSkuList = await ServiceRepository().getFinalPriceSkuNameListForDealerPopup(event.dealerId, Constants.AUTH_USERID, event.saudaBookingTypeId, event.plantId, event.oilTypeId, event.skuId);
      } else {
        metaSkuList = await ServiceRepository().getFinalPriceSkuNameListForMobile(event.dealerId, Constants.AUTH_USERID, event.saudaBookingTypeId, event.plantId, event.oilTypeId);
      }
      List<SKUPricing> skuList = [];
      if (metaSkuList.statusCode == 200) {
        jsonDecode(metaSkuList.statusMsg)['response'].forEach((f) => skuList.add(SKUPricing.fromJson(f)));
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

  Future<void> _getDistributionChannelData(LoadDistributionChannel event, Emitter<NewSaudaState> emit) async {
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

  Future<void> _getVerticalData(LoadVerticalList event, Emitter<NewSaudaState> emit) async {
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

  Future<void> _getOilTypeData(LoadOilType event, Emitter<NewSaudaState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg = await ServiceRepository()
          .getOilTypeList(Constants.AUTH_USERID, salesOrgId: event.salesOrganizationId, distriChannelId: event.distributionChannelId, divisionId: event.divisonId, isFromSauda: true);
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

  Future<void> _getCrossAndUpSellMandatory(MandatorySkus event, Emitter<NewSaudaState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg = await ServiceRepository()
          .getCrossAndUpSellMandatory(
          Constants.AUTH_USERID, salesOrgId: event.salesOrganizationId,
        distriChannelId: event.distributionChannelId, divisionId: event.divisonId,
     dealerId: event.dealerId ,skuIds: event.skusId, plantId: event.plantId,
          );
      GMLogger.v("cross and sell mandatory" + salesOrg.statusMsg);
      GMLogger.v("cross and sell mandatory" + salesOrg.statusCode.toString());
      List<Response> mandatorySku = [];
      if (salesOrg.statusCode == 200) {
       /* final decoded = jsonDecode(salesOrg.statusMsg);*/

        var decodedJson = jsonDecode(salesOrg.statusMsg);
        var map = decodedJson['response'] as Map<String, dynamic>;
        final response = Response.fromJson(map);

        GMLogger.v("decodedJson['response']");
        GMLogger.v("decodedJson['response']");
        GMLogger.v("decodedJson['response']");
        GMLogger.v("decodedJson['response']");
        GMLogger.v("decodedJson['response']");
        GMLogger.v("decodedJson['response']");
        GMLogger.v("decodedJson['response']");
        GMLogger.v("${decodedJson['response'].runtimeType}");

        List<Response> decoded = [response];

        /*if (list is List) {
          decoded = list.map((e) => Response.fromJson(e as Map<String, dynamic>)).toList();

        }*/



        mandatorySku = decoded;

      }

      if (salesOrg.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnMandatory(mandatorySku: mandatorySku));

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

  Future<void> _getIncoTermsData(LoadIncoTerms event, Emitter<NewSaudaState> emit) async {
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

  Future<void> _getPlantData(LoadPlant event, Emitter<NewSaudaState> emit) async {
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
  // Future<void> _getOverallData(LoadOverallData event,Emitter<NewSaudaState> emit)async {
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
  Future<void> _saveSauda(SaveSauda event, Emitter<NewSaudaState> emit) async {
    try {
      emit(ShowProgressBar());



      Meta savedSauda = await ServiceRepository().saveSauda(event.request);
      GMLogger.v(savedSauda.statusCode.toString());
      GMLogger.v(savedSauda.statusMsg);
      if (savedSauda.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnSaveSauda(id: jsonDecode(savedSauda.statusMsg)['response']));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: savedSauda.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _changeRate(ChangeRate event, Emitter<NewSaudaState> emit) async {
    emit(OnRateChange(change: event.popup));
  }

  Future<void> _getBdoList(LoadBDO event, Emitter<NewSaudaState> emit) async {
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

  Future<void> _getQPS(OnLoadQPS event, Emitter<NewSaudaState> emit) async {
    try {
      emit(ShowProgressBar());
      QPSReqModel reqModel = QPSReqModel();
      reqModel.skuDetails = event.qpsReqModel;
      reqModel.dealerId = event.dealerId;

      Meta m = Meta();
      m = await ServiceRepository().getQPS(reqModel, event.isFromAlert);

      if (m.statusCode == 200) {
        emit(HideProgressBar());
        // if(event.isAlertTriggered) {
        List<QPSResponseData> qpsResModel = <QPSResponseData>[];
        jsonDecode(m.statusMsg)['response'].forEach((f) => qpsResModel.add(QPSResponseData.fromJson(f)));
        emit(LoadQPS(qpsResModel: qpsResModel, isAlertTriggered: event.isAlertTriggered, qpsReqModel: event.qpsReqModel));
        // }
        // else
        //   {
        //     List<QPSResponseData> qpsResModel = <QPSResponseData>[];
        //     jsonDecode(m.statusMsg)['response']
        //         .forEach((f) => qpsResModel.add(QPSResponseData.fromJson(f)));
        //     emit(LoadQPS(qpsResModel:qpsResModel,isAlertTriggered: event.isAlertTriggered,qpsReqModel: event.qpsReqModel ));
        //   }
      } else {
        emit(HideProgressBar());
        if (m.statusMsg != "QPS Discount not available.") {
          emit(OnFailure(error: m.statusMsg));
        }
        emit(LoadRemoveQPS());
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getListOfQPSDiscount(OnLoadQPSDiscountList event, Emitter<NewSaudaState> emit) async {
    try {
      emit(ShowProgressBar());
      QPSReqModel reqModel = QPSReqModel();
      reqModel.skuDetails = event.qpsReqModel;
      reqModel.dealerId = event.dealerId;
      Meta m = Meta();
      m = await ServiceRepository().getQPSListOfDiscount(reqModel);
      List<QPSResponseData> qpsResModel = <QPSResponseData>[];
      if (m.statusCode == 200) {
        emit(HideProgressBar());
        jsonDecode(m.statusMsg)['response'].forEach((f) => qpsResModel.add(QPSResponseData.fromJson(f)));
        emit(LoadQPSDiscount(qpsResModel: qpsResModel));
      } else {
        if (m.statusMsg == "QPS Discount not available." && m.statusCode == 201) {
          for (int i = 0; i < event.qpsReqModel.length; i++) {
            qpsResModel.add(QPSResponseData(skuId: event.qpsReqModel[i].skuId, discount: 0));
          }
          emit(LoadQPSDiscount(qpsResModel: qpsResModel));
        } else {
          emit(OnFailure(error: m.statusMsg));
        }
        emit(HideProgressBar());
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }
}
