import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/stp_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/pcp/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:adaniwilmar/utils/constant.dart';

import '../../../gmcore/network/GMLogger.dart';

class PcpBloc extends Bloc<PcpEvent, PcpState> {
  PcpBloc() : super(InitialPcpState()) {
    on<LoadPcpScreen>((event, emit) => _getPcpData(event, emit));
    on<LoadPcpViewScreen>((event, emit) => _getPcpViewData(event, emit));
  }
  PcpState get initialState => InitialPcpState();

  Future<void> _getPcpData(LoadPcpScreen event, Emitter<PcpState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaPcpList =
          await ServiceRepository().getViewPCP(Constants.AUTH_USERID, event.id);
      GMLogger.v("Pcp" + metaPcpList.statusMsg);
      GMLogger.v("Pcp" + metaPcpList.statusCode.toString());
      List<TotalPCPByUsersViewDto> pcpList = [];
      List<PCPManagerList> pcpManagerList=[];
      if(Constants.ZHMANAGER==Constants.AUTH_ROLEID){
        if (metaPcpList.statusCode == 200) {
          jsonDecode(metaPcpList.statusMsg)['response']
              .forEach((f) => pcpManagerList.add(PCPManagerList.fromJson(f)));
        }
      }else {

        if (metaPcpList.statusCode == 200) {
          jsonDecode(metaPcpList.statusMsg)['response']
              .forEach((f) => pcpList.add(TotalPCPByUsersViewDto.fromJson(f)));
        }
      }
      if (metaPcpList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSuccess(totalPcpList: pcpList,pcpList: pcpManagerList));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaPcpList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getPcpViewData(LoadPcpViewScreen event, Emitter<PcpState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaPcpList =
      await ServiceRepository().getViewPCPDetail(Constants.AUTH_USERID, event.id);
      GMLogger.v("Pcp" + metaPcpList.statusMsg);
      GMLogger.v("Pcp" + metaPcpList.statusCode.toString());
      PCPManagerDetail pcpDetail=PCPManagerDetail();
      if (metaPcpList.statusCode == 200) {
        pcpDetail=PCPManagerDetail.fromJson(jsonDecode(metaPcpList.statusMsg)['response']);
      }

      if (metaPcpList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadPCPDetailSuccess(pcpDetail: pcpDetail));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaPcpList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }
}
