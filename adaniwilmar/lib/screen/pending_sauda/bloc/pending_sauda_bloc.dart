import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/pending_sauda_response.dart';
import 'package:adaniwilmar/models/pending_sauda_slab.dart';
import 'package:adaniwilmar/models/sauda_booking_status.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/pending_sauda/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../gmcore/network/GMLogger.dart';

class PendingSaudaBloc extends Bloc<PendingSaudaEvent, PendingSaudaState> {
  PendingSaudaBloc() : super(InitialPendingSaudaState()) {
    on<LoadPendingSaudaList>((event, emit) => _getDistributorList(event, emit));
    // on<LoadOverallData>((event, emit) => _getOverallData(event,emit));
    on<LoadPendingSaudaSalesScreen>(
        (event, emit) => _getPendingSaudaSalesData(event, emit));
    on<LoadPendingSaudaChart>(
        (event, emit) => _getPendingSaudaChartData(event, emit));
    on<GetSaudaCreationStatus>(
        (event, emit) => _getSaudaBookingStatus(event, emit));
  }

  PendingSaudaState get initialState => InitialPendingSaudaState();

  Future<void> _getPendingSaudaSalesData(LoadPendingSaudaSalesScreen event,
      Emitter<PendingSaudaState> emit) async {
    try {
      int bdoId = 0;
      if (event.bdoIds != null && event.bdoIds.length > 0) {
        bdoId = event.bdoIds[0];
      }
      List<PendingSauda> pendingSauda = [];
      if (event.loadData) {
        emit(ShowProgressBar());
        Meta metaDealerList = await ServiceRepository()
            .getPendingSaudaChartDetail(event.userId, bdoId: bdoId);
        GMLogger.v("User id" + event.userId.toString() + " bdo " + bdoId.toString());
        GMLogger.v(" pending sauda " + metaDealerList.statusMsg);
        if (metaDealerList.statusCode == 200) {
          jsonDecode(metaDealerList.statusMsg)['response']
              .forEach((f) => pendingSauda.add(PendingSauda.fromJson(f)));
        }
        Meta metaSlab =
            await ServiceRepository().getPendingSaudaChartSlab(event.userId);
        List<PendingSaudaSlab> pendingSaudaSlabs = [];
        if (metaSlab.statusCode == 200) {
          jsonDecode(metaSlab.statusMsg)['response'].forEach(
              (f) => pendingSaudaSlabs.add(PendingSaudaSlab.fromJson(f)));
        }
        if (metaSlab.statusCode == 200) {
          emit(HideProgressBar());
          emit(OnLoadSuccess(
              pendingSauda: pendingSauda,
              pendingSaudaSlabs: pendingSaudaSlabs));
        } else {
          emit(HideProgressBar());
          emit(OnFailure(error: metaSlab.statusMsg));
        }
      } else {
        emit(OnLoadSuccess(pendingSauda: [], pendingSaudaSlabs: []));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getSaudaBookingStatus(
      GetSaudaCreationStatus event, Emitter<PendingSaudaState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList = await ServiceRepository()
          .getSaudaBookingStatus(Constants.AUTH_USERID);
      GMLogger.v("Dealer123" + metaDealerList.statusMsg);
      SaudaBookingStatus saudaBookingStatus = SaudaBookingStatus();
      if (metaDealerList.statusCode == 200) {
        saudaBookingStatus = SaudaBookingStatus.fromJson(
            jsonDecode(metaDealerList.statusMsg)['response']);
      }
      if (metaDealerList.statusCode == 200) {
        emit(HideProgressBar());
        emit(GetSaudaBooking(saudaBookingStatus: saudaBookingStatus));
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

  Future<void> _getPendingSaudaChartData(
      LoadPendingSaudaChart event, Emitter<PendingSaudaState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList1 =
          await ServiceRepository().getPendingSauda(event.userId, event.roleId);
      Meta metaSlab =
          await ServiceRepository().getPendingSaudaChartSlab(event.userId);
      GMLogger.v("pending sauda chart" + metaDealerList1.statusMsg);
      List<PendingSauda> pendingSauda = [];
      List<PendingSaudaSlab> pendingSaudaSlabs = [];
      if (metaSlab.statusCode == 200) {
        jsonDecode(metaSlab.statusMsg)['response'].forEach(
            (f) => pendingSaudaSlabs.add(PendingSaudaSlab.fromJson(f)));
      }
      if (metaDealerList1.statusCode == 200) {
        jsonDecode(metaDealerList1.statusMsg)['response']
            .forEach((f) => pendingSauda.add(PendingSauda.fromJson(f)));
      }
      if (metaSlab.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadChartSuccess(
            pendingSauda: pendingSauda, pendingSaudaSlabs: pendingSaudaSlabs));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaSlab.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getDistributorList(
      LoadPendingSaudaList event, Emitter<PendingSaudaState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList = await ServiceRepository()
          .getDealerByUserIdList(Constants.AUTH_USERID, 0, 0, 0);
      GMLogger.v("Dealer123" + metaDealerList.statusMsg);
      List<DistributorList> distList = [];
      if (metaDealerList.statusCode == 200) {
        jsonDecode(metaDealerList.statusMsg)['response']
            .forEach((f) => distList.add(DistributorList.fromJson(f)));
      }
      if (metaDealerList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadPendingSauda(distributorList: distList));
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
