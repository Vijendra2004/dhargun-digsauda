import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/pack_group_list.dart';
import 'package:adaniwilmar/models/packgroupwise_sales_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/pack_group/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:adaniwilmar/utils/constant.dart';

import '../../../gmcore/network/GMLogger.dart';

class PackGroupBloc extends Bloc<PackGroupEvent, PackGroupState> {
  PackGroupBloc() : super(InitialPackGroupState()) {
    on<LoadPackGroupList>((event, emit) => _getPackGroupData(event, emit));
    // on<LoadOverallData>((event, emit) => _getOverallData(event,emit));
    on<LoadPackGroupSalesScreen>(
        (event, emit) => _getPackGroupSalesData(event, emit));
  }
  PackGroupState get initialState => InitialPackGroupState();

  Future<void> _getPackGroupSalesData(
      LoadPackGroupSalesScreen event, Emitter<PackGroupState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList = await ServiceRepository().getPackGroupSales(
          Constants.AUTH_USERID,
          event.fromDate,
          event.toDate,
          event.packGroupId,bdoId: Constants.AUTH_ROLEID==Constants.NHMANAGER?0:event.bdoId,
          zhId: Constants.AUTH_ROLEID==Constants.NHMANAGER?event.bdoId:0);
      List<PackGroupwiseSales> salesList = [];
      if (metaDealerList.statusCode == 200) {
        if(Constants.AUTH_ROLEID!=Constants.DEALER) {
          jsonDecode(metaDealerList.statusMsg)['response']
              .forEach((f) => salesList.add(PackGroupwiseSales.fromJson(f)));
        }else{
          salesList.add(PackGroupwiseSales.fromJson(jsonDecode(metaDealerList.statusMsg)['response']));
        }
      }
      if (metaDealerList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSuccess(packGroupwiseSales: salesList));
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

  Future<void> _getPackGroupData(
      LoadPackGroupList event, Emitter<PackGroupState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg =
          await ServiceRepository().getPackGroupList(Constants.AUTH_USERID);
      GMLogger.v("oil" + salesOrg.statusMsg);
      GMLogger.v("oil" + salesOrg.statusCode.toString());
      List<PackGroupList> packGroups = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response']
            .forEach((f) => packGroups.add(PackGroupList.fromJson(f)));
      }

      if (salesOrg.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadPackGroup(packGroups: packGroups));
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
}
