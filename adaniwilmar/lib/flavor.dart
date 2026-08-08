import 'package:adaniwilmar/utils/constant.dart';

// ignore: constant_identifier_names
enum Flavor { DEV, BETA, RELEASE }

class Injector {
  static final Injector _singleton = Injector._internal();
  static Flavor? _flavor;

  static void configure(Flavor flavor) {
    _flavor = flavor;
  }

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  String get baseUrl {
    String url = "";
    switch (_flavor!) {
      case Flavor.DEV:
        url = Constants.BaseUrlDev;
        break;
      case Flavor.BETA:
        url = Constants.BaseUrlTest;
        break;
      case Flavor.RELEASE:
        url = Constants.BaseUrlRelease;
        break;
    }

    return url;
  }

}
