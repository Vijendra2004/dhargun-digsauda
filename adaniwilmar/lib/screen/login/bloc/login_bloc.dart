import 'dart:async';
import 'dart:convert';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/gmcore/model/login_meta.dart';
import 'package:adaniwilmar/gmcore/network/GMLogger.dart';
import 'package:adaniwilmar/gmcore/storage/SPUtils.dart';
import 'package:adaniwilmar/models/base_response.dart';
import 'package:adaniwilmar/models/login_response.dart';
import 'package:adaniwilmar/models/user_login.dart';
import 'package:adaniwilmar/repo/login_repository.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/repo/splash_repository.dart';
import 'package:adaniwilmar/screen/login/bloc/bloc.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(InitialLoginState()) {
    on<LoginButtonPressed>((event, emit) => _getLoggedIn(event, emit));
    on<LoginOutEvent>((event, emit) => _getLoggedOut(event, emit));
    on<ForgotPassordOTP>((event, emit) => _getForgotPasswordOTP(event, emit));
    on<ResendForgotPassordOTP>((event, emit) => _resendForgotPasswordOTP(event, emit));
    on<ForgotPasswordSubmit>((event, emit) => _submitForgotPassword(event, emit));
  }

  LoginState get initialState => InitialLoginState();

  Future<void> _getLoggedIn(LoginButtonPressed event, Emitter<LoginState> emit) async {
    try {
      emit(ShowProgressBar());
      UserLogin request = UserLogin(verticalId: 1, isRequestFromWeb: false, email: event.email, password: event.password, mobileNumber: event.mobileNumber);
      GMLogger.v("FFFFFFFFFFFFFFFFFFFF" + request.mobileNumber);
      GMLogger.v("FFFFFFFFFFFFFFFFFFFF" + jsonEncode(request));
      LoginMeta meta = await LoginRepository().authorizeLogin(request);
      GMLogger.v(meta.statusMsg);

      if (meta.statusCode == 200) {
        GMLogger.v(meta.statusMsg);
        BaseResponse baseResponse = BaseResponse.fromJson(jsonDecode(meta.statusMsg));
        SPUtil.putString(Constants.KEY_TOKEN_1, meta.level2token);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Constants.AUTH_TOKEN = meta.level2token;
        LoginResponse loginResponse = LoginResponse.fromJson(baseResponse.response);
        Constants.AUTH_USERID = loginResponse.userId;
        Constants.AUTH_ROLEID = int.parse(loginResponse.roleId);
        Constants.AUTH_DEALER_CODE = loginResponse.code;
        Constants.AUTH_USER_NAME = loginResponse.name;
        Constants.AUTH_LAST_ACCESS_DATE = DateFormat('MMM dd,yyyy | hh:mm a').format(DateTime.now());
        prefs.setString("AUTH_TOKEN", Constants.AUTH_TOKEN);
        prefs.setInt("AUTH_USERID", Constants.AUTH_USERID);
        prefs.setInt("AUTH_ROLEID", Constants.AUTH_ROLEID);
        prefs.setString("AUTH_DEALER_CODE", Constants.AUTH_DEALER_CODE);
        prefs.setString("AUTH_USER_NAME", Constants.AUTH_USER_NAME);
        prefs.setString("AUTH_LAST_ACCESS_DATE", Constants.AUTH_LAST_ACCESS_DATE);
        prefs.setString(Constants.TEG_AUTH_URL, loginResponse.teG_AuthAPIUrl);
        prefs.setString(Constants.TG_CLIENT_ID, loginResponse.teG_clientId);
        prefs.setString(Constants.TG_CLIENT_SECRET, loginResponse.teG_clientSecret);
        SplashRepository().getFCMToken(userId: Constants.AUTH_USERID);

        emit(HideProgressBar());
        emit(OnSuccess());
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: meta.statusMsg));
      }
    } catch (error) {
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getLoggedOut(LoginOutEvent event, Emitter<LoginState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta meta = await ServiceRepository().logoutUser(event.userId);
      GMLogger.v(meta.statusMsg);

      if (meta.statusCode == 200) {
        GMLogger.v(meta.statusMsg);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("AUTH_TOKEN", "");
        prefs.setInt("AUTH_USERID", 0);
        prefs.setInt("AUTH_ROLEID", 0);
        prefs.setString("AUTH_DEALER_CODE", "");
        prefs.setString("AUTH_USER_NAME", "");
        prefs.setString("AUTH_LAST_ACCESS_DATE", "");
        emit(HideProgressBar());
        emit(OnSuccess());
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: meta.statusMsg));
      }
    } catch (error) {
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getForgotPasswordOTP(ForgotPassordOTP event, Emitter<LoginState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta meta = await ServiceRepository().forgotPasswordOtp(event.mobileNumber);
      GMLogger.v(meta.statusMsg);

      if (meta.statusCode == 200) {
        GMLogger.v(meta.statusMsg);
        emit(HideProgressBar());
        emit(OnOTPSuccess(userId: jsonDecode(meta.statusMsg)['response']));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: meta.statusMsg));
      }
    } catch (error) {
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _resendForgotPasswordOTP(ResendForgotPassordOTP event, Emitter<LoginState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta meta = await ServiceRepository().forgotPasswordResendOtp(event.userId);
      GMLogger.v(meta.statusMsg);

      if (meta.statusCode == 200) {
        GMLogger.v(meta.statusMsg);
        emit(HideProgressBar());
        emit(OnOTPSuccess(userId: jsonDecode(meta.statusMsg)['response']));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: meta.statusMsg));
      }
    } catch (error) {
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _submitForgotPassword(ForgotPasswordSubmit event, Emitter<LoginState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta meta = await ServiceRepository().forgotPasswordSubmit(event.userId, event.password, event.otpNumber);
      GMLogger.v(meta.statusMsg);

      if (meta.statusCode == 200) {
        GMLogger.v(meta.statusMsg);
        emit(HideProgressBar());
        emit(OnSuccess());
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: meta.statusMsg));
      }
    } catch (error) {
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }
}
