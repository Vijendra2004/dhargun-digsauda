import 'dart:convert';

import 'package:adaniwilmar/screen/sauda_modifications/saudaDetails/bloc/sauda_mod_detail_event.dart';
import 'package:adaniwilmar/screen/sauda_modifications/saudaDetails/bloc/sauda_mod_detail_state.dart';
import 'package:bloc/bloc.dart';

import '../../../../gmcore/model/Meta.dart';
import '../../../../models/SaudaDetailModel.dart';
import '../../../../models/SaudaModificationListModel.dart';
import '../../../../repo/service_repository.dart';
import '../../../../utils/constant.dart';

class SaudaModDetailListBloc
    extends Bloc<SaudaModDetailEvent, SaudaModDetailState> {
  SaudaModDetailListBloc() : super(SaudaModDetails()) {
    on<LoadSaudaModDetails>((event, emit) => _getModDetailApi(event, emit));
  }

  Future<void> _getModDetailApi(
      SaudaModDetailEvent event, Emitter<SaudaModDetailState> emit) async {
    try {
      ModResponseData responseData = ModResponseData();
      Meta metaSaudaModList;
      emit(ShowModDetailProgress());
      metaSaudaModList = await ServiceRepository().getSaudaModDetails(event.props);
      if (metaSaudaModList.statusCode == 200) {
        emit(HideModDetalProgress());
        responseData = ModResponseData.fromJson(jsonDecode(metaSaudaModList.statusMsg)['response']);
        emit(OnSaudaModDetailSuccess(responseData));
      } else {
        emit(HideModDetalProgress());
      }
    } catch (error) {
      emit(HideModDetalProgress());
    }
  }
}
