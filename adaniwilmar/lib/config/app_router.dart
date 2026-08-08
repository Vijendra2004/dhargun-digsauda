import 'package:flutter/material.dart';
import '../screen/screen.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings setting) {
    switch (setting.name) {
      case '/':
        return LoginScreen.route();
      case HomeScreen.routeName:
        return HomeScreen.route();
      case SaudaScreen.routeName:
        return SaudaScreen.route();
      case SalesScreen.routeName:
        return SalesScreen.route();
      case StpScreen.routeName:
        return StpScreen.route();
      case MoreScreen.routeName:
        return MoreScreen.route();
      case StockListScreen.routeName:
        return StockListScreen.route();
      case StockCreationScreen.routeName:
        return StockCreationScreen.route();
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: '/error'),
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text('Error'),
              ),
            ));
  }
}
