import 'dart:async';
import 'dart:io';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/gmcore/network/GMCore.dart';
import 'package:adaniwilmar/gmcore/security/AESCrypt.dart';
import 'package:adaniwilmar/gmcore/storage/SPUtils.dart';
import 'package:adaniwilmar/gmcore/utils/GMUtils.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/strings.dart';
import 'package:adaniwilmar/utils/url_utils.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../gmcore/network/GMLogger.dart';
import '../models/deviation_add_request.dart';

class SplashRepository {
  URLUtils utils = URLUtils();
  static const platform = MethodChannel("app_data");

  getFCMToken({int userId = 0}) async {
    Meta meta = Meta();
    if (await GMUtils().isInternetConnected()) {
      await FirebaseMessaging.instance.getToken().then((token) async {
        meta.statusCode = 200;
        meta.statusMsg = token!;
        if (kDebugMode) {
          GMLogger.v("push toke " + token);
        }
        if (userId != 0 && token != "") {
          updatePushToken(userId, token, Platform.isIOS ? 2 : 1);
        }
        final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
        remoteConfig.setConfigSettings(RemoteConfigSettings(minimumFetchInterval: const Duration(seconds: 100), fetchTimeout: const Duration(seconds: 600)));
        // await remoteConfig.fetch(expiration: const Duration(seconds: 10));
        await remoteConfig.fetchAndActivate();

        PackageInfo packageInfo = await PackageInfo.fromPlatform();

        String buildNumber = packageInfo.buildNumber;

//        var versionCode = remoteConfig.getString(Constants.VersionCode);

        var androidVersionCode = remoteConfig.getString(Constants.AndroidVersionCode);

        var iosVersionCode = remoteConfig.getString(Constants.IOSVersionCode);

        if (SPUtil.getBool(Constants.CHECK_APP_UPDATE, defValue: false)) {
          if (Platform.isAndroid) {
            /*int playstoreVersion = 0;
            try {
              playstoreVersion = await platform.invokeMethod('appForceUpdate');
//              print('isUpdateAvailable----> $playstoreVersion');
            } on PlatformException catch (e) {
              if (kDebugMode) {
                print('e----> ${e.toString()}');
              }
            } on Exception catch (e1) {
              if (kDebugMode) {
                print('e1----> ${e1.toString()}');
              }
            }
            _sendAnalyticsEvent(
                buildNumber: packageInfo.buildNumber,
                androidVersionNumber: androidVersionCode,
                iOSVersionNumber: iosVersionCode,
                playstoreVersion: playstoreVersion.toString());

//          if (isAndroidUpdateAvailable) {
//            meta.statusCode = 10000;
//            meta.statusMsg = "Version Number invalidate";
//          }
//            if (int.parse(buildNumber) < 1000) {
//              //For development
//              if (int.parse(androidVersionCode) > int.parse(buildNumber)) {
//                meta.statusCode = 10000;
//                meta.statusMsg = "Version Number invalidate";
//              }
//            } else {
            if (playstoreVersion > int.parse(buildNumber)) {
              meta.statusCode = 10000;
              meta.statusMsg = "Version Number invalidate";
//              }
//            var x = int.parse(buildNumber) - int.parse(androidVersionCode);
//
//            var y = x % 1000;
//            if (y != 0) {
//              meta.statusCode = 10000;
//              meta.statusMsg = "Version Number invalidate";
//            }
            }*/
          } else if (Platform.isIOS) {
            if (iosVersionCode.isNotEmpty) {
              if (int.parse(iosVersionCode) > int.parse(buildNumber)) {
                meta.statusCode = 10000;
                meta.statusMsg = "Version Number invalidate";
              }
            }
          }
        }
      }).catchError((err) {
        meta.statusCode = 201;
        meta.statusMsg = err.toString();
      });
    } else {
      meta.statusCode = 201;
      meta.statusMsg = SPUtil.getInt(Constants.CURRENT_LANGUAGE) == Constants.LANGUAGE_TAMIL ? Strings.chknetArbStr : Strings.chknetEngStr;
    }
    return meta;
  }

  Future<void> _sendAnalyticsEvent({
    required String buildNumber,
    required String androidVersionNumber,
    required String iOSVersionNumber,
    required String playstoreVersion,
  }) async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'VersionChecking',
      parameters: <String, Object>{
        'LocalVersionNumber': buildNumber,
        'AndroidVersionNumber': androidVersionNumber,
        'iOSVersionNumber': iOSVersionNumber,
        'playstoreVersion': playstoreVersion,
      },
    );
  }

  // ignore: missing_return
  Future<Meta> getRemoteKeys() async {
    Meta meta = Meta();
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;

      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero, // prod
        ),
      );

      await remoteConfig.fetchAndActivate();

      var secretKey = "";
      var vectorKey ="";
      var appKey = "";

      remoteConfig.getAll().forEach((key, value) {
        if(key.isNotEmpty && key.toString().toLowerCase().contains(Constants.SecretKey)){
           secretKey = value.asString();
        }else if(key.isNotEmpty && key.toString().toLowerCase().contains(Constants.VectorKey)){
           vectorKey = value.asString();
        }else if(key.isNotEmpty && key.toString().toLowerCase().contains(Constants.AppKey)){
           appKey = value.asString();
        }
        GMLogger.d("$key => ${value.asString()}");
      });
      SPUtil.putString(Constants.SecretKey, secretKey.isNotEmpty?secretKey:"");
      SPUtil.putString(Constants.VectorKey, vectorKey.isNotEmpty?vectorKey:"");
      SPUtil.putString(Constants.AppKey, appKey.isNotEmpty?appKey:"");
      Constants.APP_KEY = appKey.toString();
      Constants.ENCRYPTION_KEY = secretKey.toString();
      Constants.VECTOR_KEY = vectorKey.toString();

      AESCrypt().configure(secretKey, vectorKey);
      GMAPIService().configAPI();

      if (await GMUtils().isInternetConnected()) {
        SPUtil.putInt(Constants.INTERNET_SPEED, Constants.NET_SPEED_HIGH);

        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String buildNumber = packageInfo.buildNumber;
        var androidVersionCode = remoteConfig.getString(Constants.AndroidVersionCode);
        if (kDebugMode) {
          GMLogger.v('Android Version Code:::::::> ${androidVersionCode.toString()}');
        }
        var iosVersionCode = remoteConfig.getString(Constants.IOSVersionCode);
        if (SPUtil.getBool(Constants.CHECK_APP_UPDATE, defValue: false)) {
          if (Platform.isAndroid) {
            int playstoreVersion = 0;
            try {
              playstoreVersion = await platform.invokeMethod('appForceUpdate');
              GMLogger.v('Playstore VersionCode----> $playstoreVersion');
            } on PlatformException catch (e) {
              if (kDebugMode) {
                GMLogger.v('e----> ${e.toString()}');
              }
            } on Exception catch (e1) {
              if (kDebugMode) {
                GMLogger.v('e1----> ${e1.toString()}');
              }
            }
            _sendAnalyticsEvent(buildNumber: packageInfo.buildNumber, androidVersionNumber: androidVersionCode, iOSVersionNumber: iosVersionCode, playstoreVersion: playstoreVersion.toString());

            if (playstoreVersion > int.parse(buildNumber)) {
              meta.statusCode = 10000;
              meta.statusMsg = "Version Number invalidate";

            }
          } else if (Platform.isIOS) {
            int appstoreVersion = 0;
            try {

              //GMAPIService gmapiService = GMAPIService();
             // IOSVersionModel metaIOS = await gmapiService.getVersionForIOS();
              String latestAppStoreVersion = "";
              // List<IOSResults> results = metaIOS.results ?? [];
              // if(results.isNotEmpty){
              //   latestAppStoreVersion = results[0].version ?? "";
              //   GMLogger.v("Version Code is ${results[0].version}");
              // }
              // GMLogger.v('AppStore VersionCode----> $latestAppStoreVersion');

              appstoreVersion = await platform.invokeMethod('appForceUpdate',{"AppStoreVersion":latestAppStoreVersion});
              GMLogger.v('AppStore VersionCode----> $appstoreVersion');
            } on PlatformException catch (e) {
              if (kDebugMode) {
                GMLogger.v('e----> ${e.toString()}');
              }
            } on Exception catch (e1) {
              if (kDebugMode) {
                GMLogger.v('e1----> ${e1.toString()}');
              }
            }
            GMLogger.v("buildNumber is $buildNumber");
            if (iosVersionCode.isNotEmpty) {
              if (int.parse(iosVersionCode) > int.parse(buildNumber)) {
                meta.statusCode = 10000;
                meta.statusMsg = "Version Number invalidate";
              }
            }
          }
        }
      }
    } catch (e) {
      GMLogger.v("Firebase Error--> " + e.toString());
    }
    return meta;
  }

  Future<void> fetchRemoteConfig() async {

  }

  Future<Meta> getCountryList() async {
    GMAPIService gmapiService = GMAPIService();
    return await gmapiService.processGetURL(URLUtils().getCountryListUrl(), "");
  }

  Future<Meta> getNationalityList() async {
    GMAPIService gmapiService = GMAPIService();

    return await gmapiService.processGetURL(URLUtils().getNationalityListUrl(), "");
  }

  Future<Meta> getGender() async {
    GMAPIService gmapiService = GMAPIService();

    return await gmapiService.processGetURL(URLUtils().getGenderUrl(), "");
  }

  Future<Meta> getSpeedTestImageUrl() async {
    GMAPIService gmapiService = GMAPIService();

    return await gmapiService.processGetURL(URLUtils().getNetSpeedUrl(), "");
  }

  Future<Meta> updatePushToken(int userId, String pushToken, int regsitrationTypeId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["PushToken"] = pushToken;
    input["RegistrationTypeId"] = regsitrationTypeId;
    GMLogger.v("$input");
    Meta m = await service.processPostURL(utils.updatePushTokenUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      GMLogger.v("${m.response}");
    }
    return m;
  }

  Future<void> userAnalyticsEventLog() async {
    try {
      await FirebaseAnalytics.instance.logEvent(
        name: 'user_tracking',
        parameters: <String, Object>{
          'user_role': Constants.AUTH_ROLEID,
          'user_id': Constants.AUTH_USERID,
          'user_name': Constants.AUTH_USER_NAME,
          'date_time': DateTime.now().toString(),
        },
      );
    } catch (e) {
      GMLogger.v("Catch" + e.toString());
    }
  }
}
