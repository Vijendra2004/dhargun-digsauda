import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/models/SaudaRestrictionListModel.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import '../../../../gmcore/model/Meta.dart';
import '../../../../gmcore/network/GMLogger.dart';
import '../../../../repo/service_repository.dart';
import 'sauda_restriction_list_screen_event.dart';
import 'sauda_restriction_list_screen_state.dart';

class SaudaRestrictionListScreenBloc extends Bloc<SaudaRestrictionListScreenEvent,
    SaudaRestrictionListScreenState> {
  SaudaRestrictionListScreenBloc() : super(SaudaRestrictionListScreenInitial()) {
    on<LoadRestrictionList>((event, emit) => _getSaudaRestrictionlist(event, emit));
  }

  Future<void> _getSaudaRestrictionlist(SaudaRestrictionListScreenEvent event,
      Emitter<SaudaRestrictionListScreenState> emit) async {
    try {
      emit(ShowRestrictionProgressBar());
      Meta metaSaudaList = await ServiceRepository().getSaudaRestrictionList();
      List<SaudaItem>? saudaItems = [];
      if (metaSaudaList.statusCode == 200) {
        saudaItems = (jsonDecode(metaSaudaList.statusMsg)['response'] as List)
            .map((e) => SaudaItem.fromJson(e))
            .toList();
      }
      if (metaSaudaList.statusCode == 200) {
          emit(HideRestrictionProgressBar());
          emit(OnResSuccess(restrictionList: saudaItems));
        } else {
          emit(HideRestrictionProgressBar());
          emit(OnResFailure(errorMessage: metaSaudaList.statusMsg));
        }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideRestrictionProgressBar());
      //emit(OnFailure(error: error.toString()));
    }
  }

}
