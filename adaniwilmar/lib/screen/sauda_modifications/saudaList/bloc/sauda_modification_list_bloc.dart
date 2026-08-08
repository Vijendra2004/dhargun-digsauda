import 'dart:convert';

import 'package:adaniwilmar/screen/sauda_modifications/saudaList/bloc/sauda_modification_list_event.dart';
import 'package:adaniwilmar/screen/sauda_modifications/saudaList/bloc/sauda_modification_list_state.dart';
import 'package:bloc/bloc.dart';

import '../../../../gmcore/model/Meta.dart';
import '../../../../models/SaudaModificationListModel.dart';
import '../../../../repo/service_repository.dart';
import '../../../../utils/constant.dart';

class SaudaModificationListBloc
    extends Bloc<SaudaModificationListEvent, SaudaModificationListState> {
  SaudaModificationListBloc() : super(SaudaModList()) {
    on<LoadSaudaModificationList>(
        (event, emit) => _getSaudaModListApi(event, emit));
  }

  Future<void> _getSaudaModListApi(SaudaModificationListEvent event,
      Emitter<SaudaModificationListState> emit) async {
    try {
      Meta metaSaudaModList;
      emit(ShowModListProgress());
        metaSaudaModList =
            await ServiceRepository().getModificationList(event.props);
      List<DealerGroup>? pendingList = [];
      List<DealerGroup>? approvedList = [];
      SaudaModListData saudaModListData = SaudaModListData();
      if (metaSaudaModList.statusCode == 200) {
        saudaModListData = SaudaModListData.fromJson(jsonDecode(metaSaudaModList.statusMsg)['response']);
        pendingList = saudaModListData.pendingList;
        approvedList = saudaModListData.approvedList;
        emit(HideModListProgress());
        emit(OnSaudaModListSuccess(pendingList: pendingList, approvedBdoDealerList: approvedList));
      } else {
        emit(HideModListProgress());
      }
    } catch (error) {
      emit(HideModListProgress());
    }
  }
}
