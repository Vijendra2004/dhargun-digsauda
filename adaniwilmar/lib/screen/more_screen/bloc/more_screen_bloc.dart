import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../gmcore/model/Meta.dart';
import '../../../gmcore/network/GMLogger.dart';
import '../../../models/TdsFormModel.dart';
import '../../../models/tan_get_model.dart';
import '../../../repo/service_repository.dart';
import '../../../utils/constant.dart';
import 'more_screen_event.dart';
import 'more_screen_state.dart';

class MoreScreenBloc extends Bloc<MoreScreenEvent, MoreScreenState> {
  MoreScreenBloc() : super(MoreScreenInitial()) {
    on<GetFormApi>((event, emit) => _getTdsFromApiData(event, emit));
    on<LogOutEvent>((event, emit) => _getLoggedOut(event, emit));
    on<GetTanNumbrApi>((event, emit) => _getTanNumberApi(event, emit));
    on<TanNumberUpdate>((event, emit) => _getTanNumberUpdateApi(event, emit));
  }

  Future<void> _getTdsFromApiData(GetFormApi event, Emitter<MoreScreenState> emit) async {
    try {
      emit(ShowProgress());
      Meta metaDealerList = await ServiceRepository().getTdsFormListAPi(Constants.AUTH_USERID);
      if (metaDealerList.statusCode == 200) {
        List<dynamic> responseModel = jsonDecode(metaDealerList.statusMsg)['response'];
        // Convert the dynamic list to a list of Form objects
        List<TdsFormResponse> formList = responseModel.map((item) {
          return TdsFormResponse.fromJson(item as Map<String, dynamic>);
        }).toList();
        emit(FormPageSuccess(response: formList));
      }
      if (metaDealerList.statusCode == 200) {
        emit(HideProgress());
      } else {
        emit(HideProgress());
      }
    } catch (error) {
      emit(HideProgress());
    }
  }

  Future<void> _getTanNumberApi(GetTanNumbrApi event, Emitter<MoreScreenState> emit) async {
    try {
      emit(ShowProgress());
      Meta metaDealerList = await ServiceRepository().getTanNumberApi(Constants.AUTH_USERID, Constants.AUTH_DEALER_CODE);

      if (metaDealerList.statusCode == 200) {
        emit(HideProgress());
        TanNumberResponseModel response = TanNumberResponseModel();
        response = TanNumberResponseModel.fromJson(jsonDecode(metaDealerList.statusMsg)['response']);
        emit(TanNumberSuccess(response: response.tanNumber!));
      } else {
        emit(HideProgress());
      }
    } catch (error) {
      emit(HideProgress());
    }
  }

  Future<void> _getTanNumberUpdateApi(TanNumberUpdate event, Emitter<MoreScreenState> emit) async {
    try {
      emit(ShowProgress());
      Meta metaDealerList = await ServiceRepository().getTanNumberUpdate(Constants.AUTH_USERID, event.tanText);

      if (metaDealerList.statusCode == 200) {
        emit(HideProgress());
        emit(TanNumberUpdateSuccess(response: "Sucess"));
        /*TanNumberResponseModel response = TanNumberResponseModel();
        response = TanNumberResponseModel.fromJson(jsonDecode(metaDealerList.statusMsg)['response']);
        emit(TanNumberSuccess(response: response!.tanNumber!));*/
      } else {
        emit(HideProgress());
      }
    } catch (error) {
      emit(HideProgress());
    }
  }

  Future<void> _getLoggedOut(LogOutEvent event, Emitter<MoreScreenState> emit) async {
    try {
      emit(ShowProgress());
      Meta meta = await ServiceRepository().logoutUser(event.userId);
      GMLogger.v(meta.statusMsg);

      if (meta.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("AUTH_TOKEN", "");
        prefs.setInt("AUTH_USERID", 0);
        prefs.setInt("AUTH_ROLEID", 0);
        prefs.setString("AUTH_DEALER_CODE", "");
        prefs.setString("AUTH_USER_NAME", "");
        prefs.setString("AUTH_LAST_ACCESS_DATE", "");
        emit(HideProgress());
        emit(OnSuccessLoggedOut());
      } else {
        emit(HideProgress());
      }
    } catch (error) {
      emit(HideProgress());
    }
  }
}
