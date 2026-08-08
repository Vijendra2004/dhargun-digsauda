library gm_core;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:adaniwilmar/gmcore/model/GMAPIResponse.dart';
import 'package:adaniwilmar/gmcore/model/GMError.dart';
import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/gmcore/model/login_meta.dart';
import 'package:adaniwilmar/gmcore/security/AESCrypt.dart';
import 'package:adaniwilmar/gmcore/utils/ErrorCode.dart';
import 'package:adaniwilmar/gmcore/utils/GMUtils.dart';
import 'package:adaniwilmar/models/SubmitRequestModel.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/silent_notification_handler.dart';
import 'package:adaniwilmar/utils/strings.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:adaniwilmar/gmcore/network/GMLogger.dart';
import 'package:flutter/services.dart';
import 'package:adaniwilmar/gmcore/network/GMLogger.dart';
import '../../models/deviation_add_request.dart';

class GMAPIService {
  static int connectionTimeOut = 40000;
  static int receiveTimeout = 40000;

  Dio dio = Dio();

  void configAPI() async {

    try{
      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.acceptHeader: "application/json",
          },
        ),
      );

      // Load pinned certificate
      final sslCert = await rootBundle.load('assets/certs/server.pem');

      final securityContext = SecurityContext(withTrustedRoots: false);
      securityContext.setTrustedCertificatesBytes(
        sslCert.buffer.asUint8List(),
      );

      dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient(context: securityContext);
          client.badCertificateCallback = (cert, host, port) => false;

          return client;
        },
      );
      dio.interceptors.add(
        InterceptorsWrapper(
          onError: (e, handler) {
            if (e.error is TlsException) {
              SystemNavigator.pop();
              return;
            }
            handler.next(e);
          },
        ),
      );
    }catch(e){
      GMLogger.d("Exception in SSL Pinning: "+e.toString());
      SystemNavigator.pop();
    }
  }

  bool validateRequest(String url) {
    if (url.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<Meta> getLevel1Token(String url, Map<String, dynamic> data) async {
    return await getLevelOneToken(url, data);
  }

  Future<LoginMeta> getLevel2Token(String url, Map<String, dynamic> data, String authToken) async {
    return getLeve2OneToken(url, data, authToken);
  }

// working code
  Future<Meta> processGetURL(String url, String authToken) async {
    GMLogger.d(" ####### -> URL : " + url);
    if (validateRequest(url)) {
      bool isNetworkAvailable = await GMUtils().isInternetConnected();
      if (isNetworkAvailable) {
        try {
          dio.options.headers["Authorization"] = "Bearer " + authToken;
          dio.options.headers['Content-Length'] = 0;
//        dio.interceptors.add(LogInterceptor(responseBody: false));
          /*(dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
              (HttpClient client) {
            client.badCertificateCallback =
                (X509Certificate cert, String host, int port) => true;
            return client;
          };*/
          Response response = await dio.get(url);

          return _getResponse(response);
        } catch (error) {
          return handleError(error);
        }
      } else {
        Meta meta = Meta(statusCode: ErrorCode.INTERNET_ERROR, statusMsg: Strings.chknetEngStr);
        return meta;
      }
    } else {
      Meta meta = Meta(statusCode: ErrorCode.URL_NOT_VALID, statusMsg: "Not a valid URL");
      return meta;
    }
  }

  Future<IOSVersionModel> getVersionForIOS() async {
    String url = "https://itunes.apple.com/lookup?bundleId=com.booking.adaniwilmar";
    GMLogger.d("URL" + url);
    if (validateRequest(url)) {
      bool isNetworkAvailable = await GMUtils().isInternetConnected();
      if (isNetworkAvailable) {
        try {
          Response response = await dio.get(url);
          IOSVersionModel saudaExposureLimit = IOSVersionModel();
          if (response.statusCode == 200) {
            GMLogger.d('API call successful: ${response.data}');
            saudaExposureLimit = IOSVersionModel.fromJson(jsonDecode(response.data));
          } else {
            GMLogger.d('API call failed: ${response.statusMessage}');
          }
          return saudaExposureLimit;
        } catch (error) {
          return IOSVersionModel();
        }
      } else {
        return IOSVersionModel();
      }
    } else {
      return IOSVersionModel();
    }
  }

  Future<Meta> processGetURLForTrackOrders(String url, String authToken) async {
    GMLogger.d(" ####### -> URL : " + url);
    if (validateRequest(url)) {
      bool isNetworkAvailable = await GMUtils().isInternetConnected();
      if (isNetworkAvailable) {
        try {
          dio.options.headers['Content-Length'] = 0;
          dio.options.headers['Content-Length'] = 0;
          dio.options.headers["Authorization"] = "Bearer $authToken";
          Response response = await dio.get(url);
          Meta m = Meta();
          m.statusCode = response.data["status"];
          m.statusMsg = response.data["message"];
          m.response = response.data["data"];

          return m;
        } catch (error) {
          return handleError(error);
        }
      } else {
        Meta meta = Meta(statusCode: ErrorCode.INTERNET_ERROR, statusMsg: Strings.chknetEngStr);
        return meta;
      }
    } else {
      Meta meta = Meta(statusCode: ErrorCode.URL_NOT_VALID, statusMsg: "Not a valid URL");
      return meta;
    }
  }

  Future<Meta> getLevelOneToken(String url, Map<String, dynamic> data) async {
    GMLogger.d(" ####### -> UURL" + url);

    bool isNetworkAvailable = await GMUtils().isInternetConnected();
    if (isNetworkAvailable) {
      if (validateRequest(url)) {
        String bodyData = AESCrypt().encrypt(jsonEncode(data));
        dio.options.headers['Content-Length'] = bodyData.length.toString();
        try {
          Response response = await dio.post(url, data: json.encode(bodyData));
          GMLogger.d("resp:" + response.statusMessage!);
          return getToken(response);
        } catch (e) {
          GMLogger.d(e.toString());
          return handleError(e);
        }
      } else {
        Meta meta = Meta(statusCode: ErrorCode.URL_NOT_VALID, statusMsg: "Not a valid URL");
        return meta;
      }
    } else {
      Meta meta = Meta(statusCode: ErrorCode.INTERNET_ERROR, statusMsg: Strings.chknetEngStr);
      return meta;
    }
  }

  Future<LoginMeta> getLeve2OneToken(String url, Map<String, dynamic> data, String authToken) async {
    bool isNetworkAvailable = await GMUtils().isInternetConnected();
    GMLogger.d(" ####### -> UURL" + url);

    if (isNetworkAvailable) {
      if (validateRequest(url)) {
        String bodyData = AESCrypt().encrypt(jsonEncode(data));
        dio.options.headers["Authorization"] = "Bearer " + authToken;
        dio.options.headers['Content-Length'] = bodyData.length.toString();
        try {
          Response response = await dio.post(url, data: json.encode(bodyData));
          return getLoginToken(response);
        } catch (e) {
          return handleLoginError(e);
        }
      } else {
        LoginMeta meta = LoginMeta(statusCode: ErrorCode.URL_NOT_VALID, statusMsg: "Not a valid URL");
        return meta;
      }
    } else {
      LoginMeta meta = LoginMeta(statusCode: ErrorCode.INTERNET_ERROR, statusMsg: Strings.chknetEngStr);
      return meta;
    }
  }

  Future<Meta> processPostURL(String url, Map<String, dynamic> data, String authToken) async {
    GMLogger.d(" ####### -> URL : " + url);
    GMLogger.d(" ######## Request ########  :  ${data.toString()}");

    bool isNetworkAvailable = await GMUtils().isInternetConnected();
    if (isNetworkAvailable) {
      if (validateRequest(url)) {
        String bodyData = AESCrypt().encrypt(jsonEncode(data));
        dio.options.headers["Authorization"] = "Bearer " + authToken;
        dio.options.headers['Content-Length'] = bodyData.length.toString();
        try {
          Response response = await dio.post(url, data: jsonEncode(bodyData));
          return _getResponse(response);
        } catch (e) {
          return handleError(e);
        }
      } else {
        Meta meta = Meta(statusCode: ErrorCode.URL_NOT_VALID, statusMsg: "Not a valid URL");
        return meta;
      }
    } else {
      Meta meta = Meta(statusCode: ErrorCode.INTERNET_ERROR, statusMsg: Strings.chknetEngStr);
      return meta;
    }
  }

  //POST request method for Json request
  Future<Meta> processPostURLData(String url, SubmitRequestModel data, String authToken) async {
    GMLogger.d(" UUUUUUUUUUUUUUUUURL" + url);
    GMLogger.d(" ######## Request ########  :  ${data.toJson()}");

    bool isNetworkAvailable = await GMUtils().isInternetConnected();
    if (isNetworkAvailable) {
      if (validateRequest(url)) {
        String bodyData = AESCrypt().encrypt(jsonEncode(data.toJson()));
        dio.options.headers["Authorization"] = "Bearer " + authToken;
        dio.options.headers['Content-Length'] = bodyData.length.toString();
        try {
          Response response = await dio.post(url, data: jsonEncode(bodyData));
          return _getResponse(response);
        } catch (e) {
          return handleError(e);
        }
      } else {
        Meta meta = Meta(statusCode: ErrorCode.URL_NOT_VALID, statusMsg: "Not a valid URL");
        return meta;
      }
    } else {
      Meta meta = Meta(statusCode: ErrorCode.INTERNET_ERROR, statusMsg: Strings.chknetEngStr);
      return meta;
    }
  }

  Future<Meta> processPostURLWithoutEncrypt(String url, Map<String, dynamic> data, String authToken) async {
    GMLogger.d(" ####### -> URL : " + url);
    GMLogger.d(" ######## Request ########  :  ${data.toString()}");

    bool isNetworkAvailable = await GMUtils().isInternetConnected();
    if (isNetworkAvailable) {
      if (validateRequest(url)) {
        var bodyData = data;
        dio.options.headers["Authorization"] = "Bearer " + authToken;
        dio.options.headers['Content-Length'] = bodyData.length.toString();
        try {
          Response response = await dio.post(url, data: jsonEncode(bodyData));
          Meta m = Meta();
          m.statusCode = response.data["status"];
          m.statusMsg = response.data["message"];
          m.response = response.data["data"];
          return m;
        } catch (e) {
          return handleError(e);
        }
      } else {
        Meta meta = Meta(statusCode: ErrorCode.URL_NOT_VALID, statusMsg: "Not a valid URL");
        return meta;
      }
    } else {
      Meta meta = Meta(statusCode: ErrorCode.INTERNET_ERROR, statusMsg: Strings.chknetEngStr);
      return meta;
    }
  }

  Future<Meta> processPostURLWithoutEncryptDirect(String url, Map<String, dynamic> data, String authToken) async {
    GMLogger.d(" ####### -> URL : " + url);
    GMLogger.d(" ######## Request ########  :  ${data.toString()}");

    bool isNetworkAvailable = await GMUtils().isInternetConnected();
    if (isNetworkAvailable) {
      if (validateRequest(url)) {

        String username = 'INTF_SAUDA';
        String password = 'Sauda#2024';
        String basicAuth = 'Basic ' + base64.encode(utf8.encode('$username:$password'));
        GMLogger.d(basicAuth);
        var bodyData = data;
        dio.options.headers["authorization"] = basicAuth;
        dio.options.headers['Content-Length'] = bodyData.length.toString();
        try {
          Response response = await dio.post(url, data: jsonEncode(bodyData));
          Meta m = Meta();
          m.statusCode = response.data["status"];
          m.statusMsg = response.data["message"];
          m.response = response.data["data"];
          return m;
        } catch (e) {
          return handleError(e);
        }
      } else {
        Meta meta = Meta(statusCode: ErrorCode.URL_NOT_VALID, statusMsg: "Not a valid URL");
        return meta;
      }
    } else {
      Meta meta = Meta(statusCode: ErrorCode.INTERNET_ERROR, statusMsg: Strings.chknetEngStr);
      return meta;
    }
  }


  Future<Meta> statePostURL(String url, String data, String authToken) async {
    GMLogger.d(" ####### ->  URL" + url);
    bool isNetworkAvailable = await GMUtils().isInternetConnected();
    if (isNetworkAvailable) {
      if (validateRequest(url)) {
        String bodyData = AESCrypt().encrypt(data);
        dio.options.headers["Authorization"] = "Bearer " + authToken;
        dio.options.headers['Content-Length'] = bodyData.length.toString();
        try {
          Response response = await dio.post(url, data: jsonEncode(bodyData));
          return _getResponse(response);
        } catch (e) {
          return handleError(e);
        }
      } else {
        Meta meta = Meta(statusCode: ErrorCode.URL_NOT_VALID, statusMsg: "Not a valid URL");
        return meta;
      }
    } else {
      Meta meta = Meta(statusCode: ErrorCode.INTERNET_ERROR, statusMsg: Strings.chknetEngStr);
      return meta;
    }
  }

  Future<Meta> doNumberPutURL(String url, List<String> data, String authToken) async {
    GMLogger.d(" ####### -> URL :  " + url);
    bool isNetworkAvailable = await GMUtils().isInternetConnected();
    if (isNetworkAvailable) {
      if (validateRequest(url)) {
        String bodyData = AESCrypt().encrypt(jsonEncode(data));
        dio.options.headers["Authorization"] = "Bearer " + authToken;
        dio.options.headers['Content-Length'] = bodyData.length.toString();
        try {
          Response response = await dio.post(url, data: jsonEncode(bodyData));
          return _getResponse(response);
        } catch (e) {
          return handleError(e);
        }
      } else {
        Meta meta = Meta(statusCode: ErrorCode.URL_NOT_VALID, statusMsg: "Not a valid URL");
        return meta;
      }
    } else {
      Meta meta = Meta(statusCode: ErrorCode.INTERNET_ERROR, statusMsg: Strings.chknetEngStr);
      return meta;
    }
  }

  Future<Meta> processPutURL(String url, Map<String, dynamic> data, String authToken) async {
    GMLogger.d(" ####### -> URL : " + url);
    GMLogger.d(" ######## Request ########  :  ${data.toString()}");

    bool isNetworkAvailable = await GMUtils().isInternetConnected();
    if (isNetworkAvailable) {
      if (validateRequest(url)) {
        String bodyData = AESCrypt().encrypt(jsonEncode(data));
        dio.options.headers["Authorization"] = "Bearer " + authToken;
        dio.options.headers['Content-Length'] = bodyData.length.toString();
        try {
          Response response = await dio.put(url, data: jsonEncode(bodyData));
          return _getResponse(response);
        } catch (e) {
          return handleError(e);
        }
      } else {
        Meta meta = Meta(statusCode: ErrorCode.URL_NOT_VALID, statusMsg: "Not a valid URL");
        return meta;
      }
    } else {
      Meta meta = Meta(statusCode: ErrorCode.INTERNET_ERROR, statusMsg: Strings.chknetEngStr);
      return meta;
    }
  }

  // ignore: missing_return
  Future<Meta> processDeleteURL(String url, String data, String authToken) async {
    GMLogger.d(" ####### -> URL : " + url);
    GMLogger.d(" ######## Request ########  :  ${data.toString()}");

    bool isNetworkAvailable = await GMUtils().isInternetConnected();
    if (isNetworkAvailable) {
      if (validateRequest(url)) {
        String bodyData = AESCrypt().encrypt(data.toString());
        dio.options.headers["Authorization"] = "Bearer " + authToken;
        dio.options.headers['Content-Length'] = bodyData.length.toString();
        try {
          Response response = await dio.delete(url, data: data);
          return _getResponse(response);
        } catch (e) {
          handleError(e);
        }
      } else {
        Meta meta = Meta(statusCode: ErrorCode.URL_NOT_VALID, statusMsg: "Not a valid URL");
        return meta;
      }
    } else {
      Meta meta = Meta(statusCode: ErrorCode.INTERNET_ERROR, statusMsg: Strings.chknetEngStr);
      return meta;
    }
    return Meta();
  }

  // ignore: missing_return
  Future<Meta> imageUpload(String url, String filePath, String authToken) async {
    GMLogger.d(" ####### -> URL : " + url);
    bool isNetworkAvailable = await GMUtils().isInternetConnected();
    if (isNetworkAvailable) {
      if (validateRequest(url)) {
        dio.options.headers["Authorization"] = "Bearer " + authToken;
        try {
          var formData = FormData();
          formData.files.add(MapEntry(
            "file",
            await MultipartFile.fromFile(filePath),
          ));
          Response response = await dio.post(url, data: formData);

          return _getResponse(response);
        } catch (e) {
          handleError(e);
        }
      } else {
        Meta meta = Meta(statusCode: ErrorCode.URL_NOT_VALID, statusMsg: "Not a valid URL");
        return meta;
      }
    } else {
      Meta meta = Meta(statusCode: ErrorCode.INTERNET_ERROR, statusMsg: Strings.chknetEngStr);
      return meta;
    }
    return Meta();
  }

  // ignore: missing_return
  Future<Meta> imageUploadWithParam(String url, Map<String, String> params, String filePath, String authToken) async {
    GMLogger.d(" ####### -> URL : " + url);
    bool isNetworkAvailable = await GMUtils().isInternetConnected();
    if (isNetworkAvailable) {
      if (validateRequest(url)) {
        dio.options.headers["Authorization"] = "Bearer " + authToken;
        try {
          String parameters = "?";
          params.forEach((k, v) => (parameters += k + "=" + v + "&"));
          var formData = FormData();
          formData.files.add(MapEntry(
            "file",
            await MultipartFile.fromFile(filePath),
          ));
          Response response = await dio.post(url + parameters, data: formData);

          return _getResponse(response);
        } catch (e) {
          handleError(e);
        }
      } else {
        Meta meta = Meta(statusCode: ErrorCode.URL_NOT_VALID, statusMsg: "Not a valid URL");
        return meta;
      }
    } else {
      Meta meta = Meta(statusCode: ErrorCode.INTERNET_ERROR, statusMsg: Strings.chknetEngStr);
      return meta;
    }
    return Meta();
  }

  Meta throwError(int errorCode, String errorMsg) {
    Meta meta = Meta(statusCode: errorCode, statusMsg: errorMsg);
    return meta;
  }

  LoginMeta throwLoginError(int errorCode, String errorMsg) {
    LoginMeta meta = LoginMeta(statusCode: errorCode, statusMsg: errorMsg);
    return meta;
  }

  Meta handleError(error) {
    if (error.type == DioErrorType.receiveTimeout || error.type == DioErrorType.connectionTimeout) {
      return throwError(ErrorCode.CONNECTION_TIMEOUT, "Connection Timeout!");
    } else if (error.type == DioErrorType.badResponse) {
      if (error.response.statusCode == 401 && error.response.data == 'TOKEN EXPIRED') {
        SilentNotificationHandler silentNotificationHandler = SilentNotificationHandler.instance;
        silentNotificationHandler.updateData({Constants.NOTIFICATION_KEY: Constants.NOTIFICATION_TOKEN_EXPIRED});
      }
      return throwError(error.response.statusCode, error.response.toString());
    } else {
      return throwError(ErrorCode.COMMUNICATION_ERROR, "Communication Error");
    }
  }

  // ignore: missing_return
  LoginMeta handleLoginError(error) {
    if (error.type == DioErrorType.receiveTimeout || error.type == DioErrorType.connectionTimeout) {
      return throwLoginError(ErrorCode.CONNECTION_TIMEOUT, "Connection Timeout!");
    } else if (error.type == DioErrorType.badResponse) {
      if (error.response.statusCode == 401 && error.response.data == 'TOKEN EXPIRED') {
        SilentNotificationHandler silentNotificationHandler = SilentNotificationHandler.instance;
        silentNotificationHandler.updateData({Constants.NOTIFICATION_KEY: Constants.NOTIFICATION_TOKEN_EXPIRED});
        return throwLoginError(ErrorCode.UNAUTHORZIED_USER, error.response.data);
      } else {
        switch (error.response.statusCode) {
          case 401:
            return throwLoginError(ErrorCode.UNAUTHORZIED_USER, "User not Authorized");
          case 403:
            return throwLoginError(403, "Forbidden");
          case 404:
            return throwLoginError(404, "Not Found");
          case 409:
            return throwLoginError(ErrorCode.THROTTLE_ERROR, "Throttle Error");
          case 500:
            return throwLoginError(500, "Internal Server Error");
        }
      }
    } else {
      return throwLoginError(ErrorCode.COMMUNICATION_ERROR, "Communication Error");
    }
    return throwLoginError(ErrorCode.COMMUNICATION_ERROR, "Communication Error");
  }

  void logPrinting(String response) {
    // route to central logger (will be disabled in release) — GMLogger masks sensitive headers/tokens
    GMLogger.v(response);
  }

  Meta _getResponse(Response response) {
    Meta data = Meta();
    if (response.statusCode == 200) {
      if (response.data.toString().isNotEmpty) {
        data = getData(response);
      }
    } else if (response.statusCode == 409) {
      data.statusMsg = response.data.toString();
      data.statusCode = response.statusCode!;
    } else {
      if (response.data != null && response.data.toString().isNotEmpty) {
        data = getData(response);
      } else {
        data.statusMsg = response.data.toString();
        data.statusCode = response.statusCode!;
      }
    }
    return data;
  }

  Meta getToken(Response response) {
    Meta data = Meta();
    if (response.statusCode == 200) {
      if (response.data.toString().isNotEmpty) {
        GMLogger.d("token data");
        data = getTokenData(response);
        GMLogger.d("token data" + data.toString());
      }
    } else if (response.statusCode == 409) {
      data.statusMsg = response.data.toString();
      data.statusCode = response.statusCode!;
    } else {
      if (response.data != null && response.data.toString().isNotEmpty) {
        var data = getTokenData(response);
        data.statusMsg = response.data.toString();
        data.statusCode = response.statusCode!;
      } else {
        data.statusMsg = response.data.toString();
        data.statusCode = response.statusCode!;
      }
    }
    return data;
  }

  LoginMeta getLoginToken(Response response) {
    LoginMeta data = LoginMeta();
    GMLogger.d(response.toString());
    GMLogger.d(response.statusCode.toString());
    if (response.statusCode == 200) {
      if (response.data.toString().isNotEmpty) {
        data = getLevel2TokenData(response);
      }
    } else if (response.statusCode == 409) {
      data.statusMsg = response.data.toString();
      data.statusCode = response.statusCode!;
    } /*else {
      if (response.data != null && response.data.toString().isNotEmpty) {
        var data = getLevel2TokenData(response);
        data.statusMsg = response.data.toString();
        data.statusCode = response.statusCode!;
      } else {
        data.statusMsg = response.data.toString();
        data.statusCode = response.statusCode!;
      }
    }*/
    return data;
  }

  Meta getData(Response response) {
    GMAPIResponse gmResponse = GMAPIResponse.fromJson(response.data);
    Meta data = Meta();

    if (gmResponse.result.isNotEmpty) {
      data.statusMsg = AESCrypt().decrypt(gmResponse.result);
      data.statusCode = 200;
    } else {
      data.statusMsg = GMError.fromJson(jsonDecode(AESCrypt().decrypt(gmResponse.error))).message;
      data.statusCode = 201;
    }
    logPrinting(data.toJson().toString());
    return data;
  }

  Meta getTokenData(Response response) {
    GMLogger.d(response.data.toString());
    GMAPIResponse gmResponse = GMAPIResponse.fromJson(response.data);
    GMLogger.d(response.data.toString());

    Meta data = Meta();
    if (gmResponse.token.isNotEmpty) {
      data.statusMsg = gmResponse.token;
      data.statusCode = 200;
    } else {
      data.statusMsg = GMError.fromJson(jsonDecode(AESCrypt().decrypt(gmResponse.error))).message;
      data.statusCode = 201;
    }
    logPrinting(data.toJson().toString());
    return data;
  }

  LoginMeta getLevel2TokenData(Response response) {
    GMAPIResponse gmResponse = GMAPIResponse.fromJson(response.data);
    LoginMeta data = LoginMeta();
    if (gmResponse.token.isNotEmpty) {
      data.level2token = gmResponse.token;
      data.statusMsg = AESCrypt().decrypt(gmResponse.result);
      data.statusCode = 200;
    } else if (gmResponse.result.isNotEmpty) {
      data.statusMsg = AESCrypt().decrypt(gmResponse.result);
      data.statusCode = 200;
    } else {
      data.statusMsg = GMError.fromJson(jsonDecode(AESCrypt().decrypt(gmResponse.error))).message;
      data.statusCode = 201;
    }
    logPrinting(data.toJson().toString());
    return data;
  }

  Future<double> getNetSpeed(String url) async {
    double finalDownloadRate = 0.0;
    var startTime = DateTime.now().millisecondsSinceEpoch;
    try {
      Response response = await dio.get(
        url,
        //Received data with List<int>
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );
      GMLogger.d(response.headers.toString());
      var endTime = DateTime.now().millisecondsSinceEpoch;
      var downloadElapsedTime = (endTime - startTime) / 1000.0;
      var contentLength = response.headers.value("content-length");
      var kbs = (int.parse(contentLength!)) / (1024);
      finalDownloadRate = (kbs / downloadElapsedTime);
      return finalDownloadRate;
    } catch (e) {
      GMLogger.d(e.toString());
      return finalDownloadRate;
    }
  }
}
