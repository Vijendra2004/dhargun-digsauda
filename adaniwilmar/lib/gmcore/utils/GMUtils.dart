
import 'dart:async';
import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

class GMUtils {
  Future<bool> isInternetConnected() async {
    var connectivityResult = (await initConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    } else if (connectivityResult.contains(ConnectivityResult.mobile)) {
      return true;
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      return true;
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      return true;
    } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
      return true;
    }
    return false;
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<List<ConnectivityResult>> initConnectivity() async {

    final Connectivity _connectivity = Connectivity();
    late StreamSubscription<ConnectivityResult> _connectivitySubscription;
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      result.add(ConnectivityResult.none);
      return result;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) {
    //   return Future.value(null);
    // }

    return _updateConnectionStatus(result);
  }

 Future<List<ConnectivityResult>>  _updateConnectionStatus(List<ConnectivityResult> result) async {
   // ConnectivityResult _connectionStatus = ConnectivityResult.none;
    List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
    _connectionStatus = result;
    return _connectionStatus;
  }
}
