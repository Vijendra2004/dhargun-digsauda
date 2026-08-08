import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/stp_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/mtp/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:adaniwilmar/utils/constant.dart';

import '../../../gmcore/network/GMLogger.dart';

class MtpBloc extends Bloc<MtpEvent, MtpState> {
  MtpBloc() : super(InitialMtpState()) {
    on<LoadMtpScreen>((event, emit) => _getMtpData(event, emit));
    on<LoadMtpViewScreen>((event, emit) => _getMtpViewData(event, emit));
  }
  MtpState get initialState => InitialMtpState();

  Future<void> _getMtpData(LoadMtpScreen event, Emitter<MtpState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaMtpList = await ServiceRepository()
          .getCurrentMTPUpcomming(Constants.AUTH_USERID, false);
      GMLogger.v("Dealer" + metaMtpList.statusMsg);
      GMLogger.v("Dealer" + metaMtpList.statusCode.toString());
      List<CurrentOrUpcomingmonthViewDto> mtpList = [];
      List<MTPManagerList> mtpManagerList=[];
      if(Constants.ZHMANAGER==Constants.AUTH_ROLEID) {
        if (metaMtpList.statusCode == 200) {
          jsonDecode(metaMtpList.statusMsg)['response'].forEach(
                  (f) =>
                  mtpManagerList.add(MTPManagerList.fromJson(f)));
        }
      }else{
        if (metaMtpList.statusCode == 200) {
          jsonDecode(metaMtpList.statusMsg)['response'].forEach(
                  (f) =>
                  mtpList.add(CurrentOrUpcomingmonthViewDto.fromJson(f)));
        }
      }
      Meta metaMtpUpList = await ServiceRepository()
          .getCurrentMTPUpcomming(Constants.AUTH_USERID, true);
      GMLogger.v("Dealer" + metaMtpList.statusMsg);
      GMLogger.v("Dealer" + metaMtpUpList.statusCode.toString());
      List<CurrentOrUpcomingmonthViewDto> mtpUpcomingList = [];
      List<MTPManagerList> mtpManagerUpcomingList=[];
      if(Constants.ZHMANAGER==Constants.AUTH_ROLEID) {
        if (metaMtpUpList.statusCode == 200) {
          jsonDecode(metaMtpUpList.statusMsg)['response'].forEach(
                  (f) =>
                      mtpManagerUpcomingList.add(MTPManagerList.fromJson(f)));
        }
      }else {
        if (metaMtpUpList.statusCode == 200) {
          jsonDecode(metaMtpUpList.statusMsg)['response'].forEach((f) =>
              mtpUpcomingList.add(CurrentOrUpcomingmonthViewDto.fromJson(f)));
        }
      }
      if (metaMtpList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSuccess(
            mtpCurrentList: mtpList, mtpUpcomingList: mtpUpcomingList,mtpManagerCurrentList: mtpManagerList,mtpManagerUpcomingList: mtpManagerUpcomingList));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaMtpList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }
  Future<void> _getMtpViewData(LoadMtpViewScreen event, Emitter<MtpState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaMtpList =
      await ServiceRepository().getViewMTPDetail(Constants.AUTH_USERID, event.id);
      GMLogger.v("mtp" + metaMtpList.statusMsg);
      GMLogger.v("mtp" + metaMtpList.statusCode.toString());
      MTPManagerDetail mtpDetail=MTPManagerDetail();
      if (metaMtpList.statusCode == 200) {
        mtpDetail=MTPManagerDetail.fromJson(jsonDecode(metaMtpList.statusMsg)['response']);
      }

      if (metaMtpList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadMTPDetailSuccess(mtpDetail: mtpDetail));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaMtpList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }
}
