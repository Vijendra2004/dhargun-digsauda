import 'dart:convert';

import 'package:adaniwilmar/gmcore/network/GMLogger.dart';
import 'package:adaniwilmar/screen/sauda_modifications/saudaDetails/bloc/sauda_mod_detail_event.dart';
import 'package:adaniwilmar/screen/sauda_modifications/saudaDetails/bloc/sauda_mod_detail_state.dart';
import 'package:adaniwilmar/screen/sauda_modifications/saudaModApproval/bloc/sauda_mod_approval_state.dart';
import 'package:adaniwilmar/screen/sauda_modifications/saudaModApproval/bloc/sauda_mod_aprroval_event.dart';
import 'package:bloc/bloc.dart';

import '../../../../gmcore/model/Meta.dart';
import '../../../../models/SaudaDetailModel.dart';
import '../../../../models/SaudaModApprovalModel.dart';
import '../../../../models/SaudaModificationListModel.dart';
import '../../../../models/daily_rate_response.dart';
import '../../../../repo/service_repository.dart';
import '../../../../utils/constant.dart';

class SaudaModApprovalBloc
    extends Bloc<SaudaModApprovalEvent, SaudaModApprovalState> {
  SaudaModApprovalBloc() : super(SaudaModApproval()) {

    on<LoadSaudaModApproval>((event, emit) => _getModDetailApi(event, emit));
    on<LoadModSalesOrganization>((event, emit) => _getSalesOrganization(event, emit));
    on<LoadModDistributionChannel>((event, emit) => _getDistributionChannelData(event, emit));
    on<LoadModVerticalList>((event, emit) => _getVerticalData(event, emit));
    on<ApproveRejectSaudaModApproval>((event, emit) => _saveApproveReject(event, emit));

  }

  Future<void> _saveApproveReject(
      ApproveRejectSaudaModApproval event, Emitter<SaudaModApprovalState> emit) async {
    try {
      Meta metaSaudaModList;
      emit(ShowModApprovalProgress());
      metaSaudaModList = await ServiceRepository().saveRejectApproval(event.saudaModApprovalRequest);
      if (metaSaudaModList.statusCode == 200) {
        GMLogger.v("Statusid---${event.saudaModApprovalRequest.statusId}");
        emit(HideModApprovalProgress());
        emit(OnSaudaSaveRejectSuccess(event.saudaModApprovalRequest.statusId));
      } else {
        emit(HideModApprovalProgress());
      }
    } catch (error) {
      GMLogger.v("Error---${error.toString()}");
      emit(HideModApprovalProgress());
    }
  }

  Future<void> _getModDetailApi(
      LoadSaudaModApproval event, Emitter<SaudaModApprovalState> emit) async {
    try {
      Meta metaSaudaModList;
      emit(ShowModApprovalProgress());
      metaSaudaModList = await ServiceRepository().getSaudaApprovalList(event.userId,event.fromDate,event.toDate,
      event.distributionChannelId,event.divisionId,event.salesOrganizationId);
      List<SaudaModApprovalItem> saudaModApprovalModel = [];
      if (metaSaudaModList.statusCode == 200) {
        emit(HideModApprovalProgress());
        saudaModApprovalModel = (jsonDecode(metaSaudaModList.statusMsg)['response']['items'] as List)
            .map((e) => SaudaModApprovalItem.fromJson(e))
            .toList();
        emit(OnSaudaModApprovalSuccess(saudaModApprovalModel));
      } else {
        emit(HideModApprovalProgress());
      }
    } catch (error) {
      GMLogger.v("Error---${error.toString()}");
      emit(HideModApprovalProgress());
    }
  }

  Future<void> _getSalesOrganization(
      LoadModSalesOrganization event, Emitter<SaudaModApprovalState> emit) async {
    try {
      emit(ShowModApprovalProgress());
      Meta salesOrg = await ServiceRepository()
          .getSalesOrganization(Constants.AUTH_SELECTED_STATEID);
      List<SalesOrganization> salesOrgList = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response']
            .forEach((f) => salesOrgList.add(SalesOrganization.fromJson(f)));
      }

      if (salesOrg.statusCode == 200) {
        emit(HideModApprovalProgress());
        emit(OnLoadModSalesOrganization(salesOrganization: salesOrgList));
      } else {
        emit(HideModApprovalProgress());
        emit(OnModApprovalFailure(errorMessage: salesOrg.statusMsg));
      }
    } catch (error) {
      emit(HideModApprovalProgress());
      emit(OnModApprovalFailure(errorMessage: error.toString()));
    }
  }


  @override
  Future<void> _getDistributionChannelData(
      LoadModDistributionChannel event, Emitter<SaudaModApprovalState> emit) async {
    try {
      emit(ShowModApprovalProgress());
      Meta salesOrg = await ServiceRepository().getDistributionChannel(event.id);
      List<DistributionChannel> distrChannels = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response']
            .forEach((f) => distrChannels.add(DistributionChannel.fromJson(f)));
      }

      if (salesOrg.statusCode == 200) {
        emit(HideModApprovalProgress());
        emit(OnLoadModDistributionChannel(distributionChannel: distrChannels));
      } else {
        emit(HideModApprovalProgress());
        emit(OnModApprovalFailure(errorMessage: salesOrg.statusMsg));
      }
    } catch (error) {
      emit(HideModApprovalProgress());
      emit(OnModApprovalFailure(errorMessage: error.toString()));
    }
  }

  @override
  Future<void> _getVerticalData(
      LoadModVerticalList event, Emitter<SaudaModApprovalState> emit) async {
    try {
      emit(ShowModApprovalProgress());
      Meta salesOrg = await ServiceRepository().getVertical(
          event.distributionId);
      List<Vertical> verticals = [];
      if (salesOrg.statusCode == 200) {
        jsonDecode(salesOrg.statusMsg)['response']
            .forEach((f) => verticals.add(Vertical.fromJson(f)));
      }

      if (salesOrg.statusCode == 200) {
        emit(HideModApprovalProgress());
        emit(OnLoadModVerticalList(verticalList: verticals));
      } else {
        emit(HideModApprovalProgress());
        emit(OnModApprovalFailure(errorMessage: salesOrg.statusMsg));
      }
    } catch (error) {
      emit(HideModApprovalProgress());
      emit(OnModApprovalFailure(errorMessage: error.toString()));
    }
  }
}
