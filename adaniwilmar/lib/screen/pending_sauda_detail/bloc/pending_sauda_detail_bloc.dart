import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/dealer_sauda_response.dart';
import 'package:adaniwilmar/models/pending_sauda_response.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/pending_sauda_detail/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../gmcore/model/Meta.dart';
import '../../../gmcore/network/GMLogger.dart';
import '../../../models/dealer_invoice_response.dart';
import '../../../models/dealer_pending_sauda_sales.dart';
import '../../../models/pending_sauda_distributor_details_response.dart';

class PendingSaudaDetailBloc
    extends Bloc<PendingSaudaDetailEvent, PendingSaudaDetailState> {
  PendingSaudaDetailBloc() : super(InitialPendingSaudaDetailState()) {
    on<LoadPendingSaudaDetailList>(
        (event, emit) => _getDistributorList(event, emit));
    // on<LoadOverallData>((event, emit) => _getOverallData(event,emit));
    on<LoadPendingSaudaDetailSalesScreen>(
        (event, emit) => _getPendingSaudaDetailSalesData(event, emit));
    on<LoadDealerDetail>((event, emit) => _getDealerData(event, emit));
    on<LoadDealerSaudaList>((event, emit) => _getDealerSaudaData(event, emit));
    // on<LoadDealerSalesList>((event, emit) => _getDealerSalesData(event, emit));
    on<LoadSalesScreen>((event, emit) => _getSalesListData(event, emit));

    on<LoadSalesOrganization>(
        (event, emit) => _getSalesOrganization(event, emit));
    on<LoadDistributionChannel>(
        (event, emit) => _getDistributionChannelData(event, emit));
    on<LoadVerticalList>((event, emit) => _getVerticalData(event, emit));
    on<DelayEvent>((event, emit) => _delay(event, emit));
  }

  PendingSaudaDetailState get initialState => InitialPendingSaudaDetailState();

  Future<void> _getPendingSaudaDetailSalesData(
      LoadPendingSaudaDetailSalesScreen event,
      Emitter<PendingSaudaDetailState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList = await ServiceRepository()
          .getPendingSaudaChartDetail(event.userId, isFromPendingSauda: true);
      GMLogger.v("pending sauda" + metaDealerList.statusMsg);
      List<PendingSaudaList> pendingSauda = [];
      if (metaDealerList.statusCode == 200) {
        jsonDecode(metaDealerList.statusMsg)['response']
            .forEach((f) => pendingSauda.add(PendingSaudaList.fromJson(f)));
      }
      if (metaDealerList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSuccess(pendingSauda: pendingSauda));
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

  Future<void> _getSalesListData(
      LoadSalesScreen event, Emitter<PendingSaudaDetailState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaRequestList = await ServiceRepository().getPackGroupDealerSales(
          event.userId,
          event.fromDate,
          event.toDate,
          event.dealerId,
          event.packGroupId,true);
      GMLogger.v("Req" + metaRequestList.statusMsg);
      GMLogger.v("Req" + metaRequestList.statusCode.toString());
      DealerPendingSales invoices = DealerPendingSales();
      if (metaRequestList.statusCode == 200) {
        invoices = DealerPendingSales.fromJson(
            jsonDecode(metaRequestList.statusMsg)['response']);
      }

      if (metaRequestList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSalesSuccess(dealerInvoiceResponse: invoices));
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

  Future<void> _getDealerData(
      LoadDealerDetail event, Emitter<PendingSaudaDetailState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList = await ServiceRepository().getDealerDetail(
          Constants.AUTH_USERID, event.id,
          salesOrgId: event.salesOrgId,
          distributionId: event.distributionId,
          divisionId: event.divisionId);

      GMLogger.v("Detail" + metaDealerList.statusCode.toString());
      GMLogger.v("Detail" + metaDealerList.statusMsg);
      DealerDetail detail = DealerDetail();
      if (metaDealerList.statusCode == 200) {
        detail = DealerDetail.fromJson(
            jsonDecode(metaDealerList.statusMsg)['response']);
      }
      if (metaDealerList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadDealerDetail(dealerDetail: detail));
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

  Future<void> _getDealerSaudaData(
      LoadDealerSaudaList event, Emitter<PendingSaudaDetailState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList = await ServiceRepository().getDealerSaudaList(
          Constants.AUTH_USERID, event.id,
          salesOrgId: event.salesOrgId,
          distributionId: event.distributionId,
          divisionId: event.divisionId,
          fromDate: event.fromDate,
          toDate: event.toDate);
      GMLogger.v("dealer sauda list" + metaDealerList.statusCode.toString());
      GMLogger.v("dealer sauda list" + metaDealerList.statusMsg);
      List<PendingSaudaList> pendingSauda = [];
      if (metaDealerList.statusCode == 200) {
        jsonDecode(metaDealerList.statusMsg)['response']
            .forEach((f) => pendingSauda.add(PendingSaudaList.fromJson(f)));
      }
      if (metaDealerList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadDealerSaudaList(saudaList: pendingSauda));
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

  Future<void> _getDealerSalesData(
      LoadDealerSalesList event, Emitter<PendingSaudaDetailState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaDealerList = await ServiceRepository().getDealerSalesList(
          Constants.AUTH_USERID, event.id,
          salesOrgId: event.salesOrgId,
          distributionId: event.distributionId,
          divisionId: event.divisionId,
          fromDate: event.fromDate,
          toDate: event.toDate);
      GMLogger.v(metaDealerList.statusMsg);
      List<DealerSaudaList> pendingSauda = [];
      if (metaDealerList.statusCode == 200) {
        jsonDecode(metaDealerList.statusMsg)['response']
            .forEach((f) => pendingSauda.add(DealerSaudaList.fromJson(f)));
      }
      if (metaDealerList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadDealerSalesList(salesList: pendingSauda));
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

  Future<void> _getDistributorList(LoadPendingSaudaDetailList event,
      Emitter<PendingSaudaDetailState> emit) async {
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
        emit(OnLoadPendingSaudaDetail(distributorList: distList));
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

  Future<void> _getSalesOrganization(LoadSalesOrganization event,
      Emitter<PendingSaudaDetailState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg = await ServiceRepository()
          .getSalesOrganization(Constants.AUTH_SELECTED_STATEID);
      GMLogger.v("Sales" + salesOrg.statusMsg);
      GMLogger.v("Sales" + salesOrg.statusCode.toString());
      List<SalesOrganization> salesOrgList = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response']
            .forEach((f) => salesOrgList.add(SalesOrganization.fromJson(f)));
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

  Future<void> _getDistributionChannelData(LoadDistributionChannel event,
      Emitter<PendingSaudaDetailState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg =
          await ServiceRepository().getDistributionChannel(event.id);
      GMLogger.v("Dealer" + salesOrg.statusMsg);
      GMLogger.v("Dealer" + salesOrg.statusCode.toString());
      List<DistributionChannel> distrChannels = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response']
            .forEach((f) => distrChannels.add(DistributionChannel.fromJson(f)));
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

  Future<void> _getVerticalData(
      LoadVerticalList event, Emitter<PendingSaudaDetailState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta salesOrg =
          await ServiceRepository().getVertical(event.distributionId);
      GMLogger.v("Vertical" + salesOrg.statusMsg);

      GMLogger.v("Vertical" + salesOrg.statusCode.toString());
      List<Vertical> verticals = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response']
            .forEach((f) => verticals.add(Vertical.fromJson(f)));
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

  Future<void> _delay(
      DelayEvent event, Emitter<PendingSaudaDetailState> emit) async {
    try {
      emit(const OnDelayState());
    } catch (error) {}
  }
}
