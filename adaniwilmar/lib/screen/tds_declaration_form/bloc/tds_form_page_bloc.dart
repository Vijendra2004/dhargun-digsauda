import 'dart:convert';

import 'package:adaniwilmar/config/constant.dart';
import 'package:adaniwilmar/flavor.dart';
import 'package:adaniwilmar/models/TdsFormModel.dart';
import 'package:adaniwilmar/screen/tds_declaration_form/bloc/bloc.dart';
import 'package:adaniwilmar/screen/tds_declaration_form/bloc/tds_form_page_event.dart';
import 'package:adaniwilmar/screen/tds_declaration_form/bloc/tds_form_page_state.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../gmcore/model/Meta.dart';
import '../../../gmcore/network/GMCore.dart';
import '../../../gmcore/network/GMLogger.dart';
import '../../../repo/service_repository.dart';
import '../../../utils/constant.dart';
import '../../../utils/url_utils.dart';

class TdsFormPageBloc extends Bloc<TdsFormPageEvent, TdsFormPageState> {
  TdsFormPageBloc() : super(TdsFormPageInitial()) {
    on<TdsFormApiEvent>((event, emit) => _getTdsFromApiData(event, emit));
  }

  TdsFormPageInitial get initialState => TdsFormPageInitial();

  Future<void> _getTdsFromApiData(
      TdsFormApiEvent event, Emitter<TdsFormPageState> emit) async {
    try {
      emit(LoadTdsFormProgressBar());
      Meta metaDealerList = await ServiceRepository().getTdsFormListAPi(Constants.AUTH_USERID);
      if (metaDealerList.statusCode == 200) {
        List<dynamic> responseModel = jsonDecode(metaDealerList.statusMsg)['response'];
        // Convert the dynamic list to a list of Form objects
        List<TdsFormResponse> formList = responseModel.map((item) {
          return TdsFormResponse.fromJson(item as Map<String, dynamic>);
        }).toList();

        emit(OnTdsFormPageSuccess(response: formList));
      }
      if (metaDealerList.statusCode == 200) {
        emit(DisableTdsFormProgressBar());
      } else {
        emit(DisableTdsFormProgressBar());
        emit(OnTdsFormFailure(error: metaDealerList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(DisableTdsFormProgressBar());
      emit(OnTdsFormFailure(error: error.toString()));
    }
  }
}
