import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/screen/track_order/bloc/track_order_event.dart';
import 'package:adaniwilmar/screen/track_order/bloc/track_order_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../gmcore/model/Meta.dart';
import '../../../gmcore/network/GMLogger.dart';
import '../../../models/JwtTokenGenrator.dart';
import '../../../models/bdo_list_response.dart';
import '../../../models/dealer_response.dart';
import '../../../models/do_number_response.dart';
import '../../../models/track_order_model.dart';
import '../../../repo/service_repository.dart';
import '../../../utils/constant.dart';

class TrackOrderBloc extends Bloc<TrackOrderEvent, TrackOrderState> {
  TrackOrderBloc() : super(InitialTrackOrderState()) {
    // on<LoadZonalHeadTrade>((event, emit) => _getZonalHeadList(event, emit));
    // on<LoadTrackOrderScreen>((event, emit) => _getDistributorList(event, emit));
    // on<LoadTrackUserStatistics>((event, emit) => _getStatistics(event, emit));
    // on<LoadTrackOrderScreen>((event, emit) => _getNationalIdList(event, emit));
    // on<LoadBDOList>((event, emit) => getBdoList(event, emit));
    on<FetchExternalAPITrackOrdersEvent>(
        (event, emit) => loginToFetchExternalAPI(event, emit));
    on<LoadZonalHeadTrack>((event, emit) => getZonalHeadList(event, emit));
    on<LoadStateHeadTrack>((event, emit) => getStateHeadList(event, emit));
    on<LoadDistributorHeadTrack>(
        (event, emit) => getDistributorHeadList(event, emit));
    on<LoadStateDOTrack>((event, emit) => getDONumberList(event, emit));
    on<LoadMaterialTrack>((event, emit) => getDOMaterialList(event, emit));
  }

  Future<void> getZonalHeadList(
      LoadZonalHeadTrack event, Emitter<TrackOrderState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList =
          await ServiceRepository().getZonalHeadList(event.userId);
      List<BdoList> zonalHeadList = [];
      if (event.showAll) {
        BdoList defaultDist = BdoList();
        defaultDist.id = 0;
        defaultDist.name = "All Zonal Traders";
        zonalHeadList.add(defaultDist);
      }
      if (metaDealerList.statusCode == 200) {
        jsonDecode(metaDealerList.statusMsg)['response']
            .forEach((f) => zonalHeadList.add(BdoList.fromJson(f)));
      }
      if (metaDealerList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnTrackZonalHead(zonalHeadList: zonalHeadList));
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

  Future<void> getStateHeadList(
      LoadStateHeadTrack event, Emitter<TrackOrderState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList = await ServiceRepository().getBDOList(event.userId);
      List<BdoList> bdoList = [];
      // if (event.showAll) {
      BdoList defaultDist = BdoList();
      defaultDist.id = 0;
      defaultDist.name = "All State Traders";
      bdoList.add(defaultDist);
      // }
      if (metaDealerList.statusCode == 200) {
        jsonDecode(metaDealerList.statusMsg)['response']
            .forEach((f) => bdoList.add(BdoList.fromJson(f)));
      }
      if (metaDealerList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnTrackStateHead(stateHeadList: bdoList));
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

  Future<void> getDistributorHeadList(
      LoadDistributorHeadTrack event, Emitter<TrackOrderState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList = await ServiceRepository()
          .getDistributorHeadByUserIdList(event.userId, 0, 0, 0);
      GMLogger.v("Distributor Head list" + metaDealerList.statusMsg);
      GMLogger.v(
          "Distributor Head list" + metaDealerList.statusCode.toString());
      List<DistributorList> distList = [];
      DistributorList defaultDist = DistributorList();
      defaultDist.id = 0;
      defaultDist.employeeCode = "0";
      defaultDist.employeeName = "All Distributor";
      distList.add(defaultDist);
      if (metaDealerList.statusCode == 200) {
        jsonDecode(metaDealerList.statusMsg)['response']
            .forEach((f) => distList.add(DistributorList.fromJson(f)));
      }
      if (metaDealerList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnTrackDistributorHead(distributorList: distList));
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

  Future<void> getDONumberList(
      LoadStateDOTrack event, Emitter<TrackOrderState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList =
          await ServiceRepository().getDoNumberList(event.distributorEmpCode);
      List<DoNumberResponse> doList = [];
      if (metaDealerList.statusCode == 200) {
        jsonDecode(metaDealerList.statusMsg)['response']
            .forEach((f) => doList.add(DoNumberResponse.fromJson(f)));
      }
      if (metaDealerList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnTrackDoNumber(doNumberList: doList));
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

  Future<void> getDOMaterialList(
      LoadMaterialTrack event, Emitter<TrackOrderState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList = await ServiceRepository()
          .getDoMaterialList(event.userId, event.doNumber, event.isLiftingId);
      List<DoMaterial> materialList = [];
      if (metaDealerList.statusCode == 200) {
        jsonDecode(metaDealerList.statusMsg)['response']
            .forEach((f) => materialList.add(DoMaterial.fromJson(f)));
      }
      if (metaDealerList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnTrackMaterial(materialList: materialList));
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
}

//Apply Filter - fetch the list
//   step :1 login using external credentials

Future<void> loginToFetchExternalAPI(FetchExternalAPITrackOrdersEvent event,
    Emitter<TrackOrderState> emit) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  try {
    emit(ShowProgressBar());
    String? token = pref.getString(Constants.TG_BEARER_TOKEN);
    String? tokenTime = pref.getString(Constants.TG_BEARER_TOKEN_TIME);

    bool shouldGenerateToken =
        token == null ||
            token.isEmpty ||
            tokenTime == null ||
            tokenTime.isEmpty;

    if (!shouldGenerateToken) {
      final savedTime = DateTime.parse(tokenTime);

      shouldGenerateToken =
          DateTime.now().difference(savedTime) >=
              const Duration(hours: 5);
    }

    if (shouldGenerateToken) {
      final result = JwtTokenGenrator.generate(
        clientId: pref.getString(Constants.TG_CLIENT_ID) ?? "",
        clientSecret: pref.getString(Constants.TG_CLIENT_SECRET) ?? "",
      );
      final dio = Dio();
      Response response = await dio.post(
        pref.getString(Constants.TEG_AUTH_URL)!,
        data: {
          'client_id': pref.getString(Constants.TG_CLIENT_ID) ?? "",
          'timestamp': result['timestamp'],
          'nonce': result['nonce'],
          'signature': result['signature'],
        },
      );

      if (response.statusCode == 200) {
        final json = response.data;
        String token = json['data']['token'];
        pref.setString(Constants.TG_BEARER_TOKEN, token);
        pref.setString(
            Constants.TG_BEARER_TOKEN_TIME, DateTime.now().toIso8601String());
        await fetchExternalAPITrackOrders(token, event, emit);
      } else {
        emit(HideProgressBar());
        emit(
            const OnFailureSaleDataListTrackOrders(error: "Failed Response"));
      }
    } else {
      emit(HideProgressBar());
      await fetchExternalAPITrackOrders(token ?? "", event, emit);
    }
  } catch (error) {
    GMLogger.v(error.toString());
    emit(HideProgressBar());
    emit(OnFailureSaleDataListTrackOrders(error: error.toString()));
  }
}

// step :2 - Fetch the list using the external api login tocken
Future<void> fetchExternalAPITrackOrders(
    String response,
    FetchExternalAPITrackOrdersEvent event,
    Emitter<TrackOrderState> emit) async {
  try {
    emit(ShowProgressBar());
    Meta metaData = await ServiceRepository().fetchExternalAPITrackOrdersRepo(
        response, event.distributorCode, event.doNumberIds);

    if (metaData.statusCode == 200) {
      emit(HideProgressBar());
      GMLogger.v(metaData.toString());
      TrackOrderModel trackOrderModel = TrackOrderModel();
      trackOrderModel = TrackOrderModel.fromJson(metaData.response);
      GMLogger.v(trackOrderModel);
      // emit(FetchExternalAPITrackOrdersSuccessState(trackOrderModel: trackOrderModel));
      await fetchSaleDataListTrackOrders(event, emit, trackOrderModel);
      // } else {
    } else {
      emit(HideProgressBar());
      emit(OnFailureSaleDataListTrackOrders(error: metaData.statusMsg));
    }
  } catch (error) {
    GMLogger.v(error.toString());
    emit(HideProgressBar());
    emit(OnFailureSaleDataListTrackOrders(error: error.toString()));
  }
}

// step :3 - Fetch the sale data list
Future<void> fetchSaleDataListTrackOrders(
    FetchExternalAPITrackOrdersEvent event,
    Emitter<TrackOrderState> emit,
    TrackOrderModel trackOrderModel) async {
  try {
    List<String> doNo = event.doNumberIds.split(",");
    SaleDataRequest saleDataRequest = SaleDataRequest();
    saleDataRequest.liftingId = 0;
    saleDataRequest.doNumber = null;
    saleDataRequest.isLiftingId = false;
    saleDataRequest.loginUserId = Constants.AUTH_ROLEID;
    for (var i = 0; i < doNo.length; i++) {
      for (var j = 0; j < (trackOrderModel.doDetails?.length ?? 0); j++) {
        if (trackOrderModel.doDetails![j].doNumber != null &&
            trackOrderModel.doDetails![j].statusBody != null) {
          if (doNo[i] == trackOrderModel.doDetails![j].doNumber) {
            saleDataRequest.doNumbers ??= [];
            saleDataRequest.doNumbers!.add(DoNumbersRequest(
                doNumber: trackOrderModel.doDetails![j].doNumber!,
                liftingId: 0,
                // status: "PENDING", commented
                status:
                    trackOrderModel.doDetails![j].statusBody!.currentStatus));
          }
          /* saleDataRequest.doNumbers ??= [];
          saleDataRequest.doNumbers!.add(
              DoNumbersRequest(
                doNumber: trackOrderModel.doDetails![j].doNumber!,
                liftingId: 0,
                status: "PENDING",
              )
          );*/
        }
      }
    }
    Meta metaData = await ServiceRepository()
        .fetchSaleDataListAPITrackOrdersRepo(saleDataRequest);
    List<SalesDataResponse> saleDataList = [];
    if (metaData.statusCode == 200) {
      jsonDecode(metaData.statusMsg)['response']
          .forEach((f) => saleDataList.add(SalesDataResponse.fromJson(f)));

      for (var i = 0; i < trackOrderModel.doDetails!.length; i++) {
        for (var j = 0; j < saleDataList.length; j++) {
          if (trackOrderModel.doDetails![i].doNumber ==
              saleDataList[j].doNumber) {
            trackOrderModel.doDetails![i].salesDataList = saleDataList[j];
          }
        }
      }
      emit(HideProgressBar());
      emit(FetchExternalAPITrackOrdersSuccessState(
          trackOrderModel: trackOrderModel));
    } else {
      emit(HideProgressBar());
      emit(OnFailureSaleDataListTrackOrders(error: metaData.statusMsg));
    }
  } catch (error) {
    GMLogger.v(error.toString());
    emit(HideProgressBar());
    emit(OnFailureSaleDataListTrackOrders(error: error.toString()));
  }
}
