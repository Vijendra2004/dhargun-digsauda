// TODO Implement this library.// TODO Implement this library.import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/lifting_detail_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/sale_order_detail_page.dart/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../gmcore/network/GMLogger.dart';

class SalesOrderDetailPageBloc
    extends Bloc<SalesOrderDetailPageEvent, SalesOrderDetailPageState> {
  SalesOrderDetailPageBloc() : super(InitialSalesOrderDetailPageState()) {
    on<LoadSalesOrderDetailPageScreen>(
        (event, emit) => _getSalesOrderDetailPageData(event, emit));
    on<SaveSalesOrderApproval>(
            (event, emit) => _saveSalesOrderApproval(event, emit));
  }
  SalesOrderDetailPageState get initialState =>
      InitialSalesOrderDetailPageState();

  Future<void> _getSalesOrderDetailPageData(
      LoadSalesOrderDetailPageScreen event,
      Emitter<SalesOrderDetailPageState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaRequestList = await ServiceRepository()
          .getLiftingRequestDetail(event.userId, event.id);
      GMLogger.v("Req" + metaRequestList.statusMsg);
      GMLogger.v("Req" + metaRequestList.statusCode.toString());
      LiftingDetailResponse response = LiftingDetailResponse();
      if (metaRequestList.statusCode == 200) {
        response = LiftingDetailResponse.fromJson(
            jsonDecode(metaRequestList.statusMsg)['response']);
      }
      if (metaRequestList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSuccess(liftingDetail: response));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaRequestList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _saveSalesOrderApproval(
      SaveSalesOrderApproval event, Emitter<SalesOrderDetailPageState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta savedSauda =
      await ServiceRepository().saveSalesOrderApproval(event.request);
      GMLogger.v(savedSauda.statusCode.toString());
      GMLogger.v(savedSauda.statusMsg);
      if (savedSauda.statusCode == 200) {
        emit(HideProgressBar());
        emit(const OnApprovalSuccess(saved: true));
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

}
