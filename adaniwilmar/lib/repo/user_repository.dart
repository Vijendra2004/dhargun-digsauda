import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:adaniwilmar/utils/constant.dart';

class UserRepository {
  Future<String> authenticate({
    required String username,
    required String password,
    required int countryId,
    required int applicationId,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return 'token';
  }

  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    // await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<void> persistToken(String token) async {
    /// write to keystore/keychain
    await Future.delayed(const Duration(seconds: 1));
    return;
  }

  Future<bool> hasToken() async {
    /// read from keystore/keychain
    await Future.delayed(const Duration(seconds: 2));
    return false;
  }

  Future<String> getUserDetail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userToken = pref.getString('AUTH_TOKEN') ?? "";
    Constants.AUTH_TOKEN =
        userToken;
    if(userToken!="") {
      Constants.AUTH_USERID=pref.getInt("AUTH_USERID")??0;
      Constants.AUTH_ROLEID=pref.getInt("AUTH_ROLEID")??0;
      Constants.AUTH_DEALER_CODE=pref.getString("AUTH_DEALER_CODE")??"";
      Constants.AUTH_USER_NAME=pref.getString("AUTH_USER_NAME")??"";
      Constants.AUTH_LAST_ACCESS_DATE=pref.getString("AUTH_LAST_ACCESS_DATE")??"";
    }else{
      Constants.AUTH_USERID=0;
      Constants.AUTH_ROLEID=0;
      Constants.AUTH_DEALER_CODE="";
      Constants.AUTH_USER_NAME="";
      Constants.AUTH_LAST_ACCESS_DATE="";
    }
    return userToken;
  }
}
