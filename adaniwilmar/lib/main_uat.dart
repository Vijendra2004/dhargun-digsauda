import 'dart:io';

import 'package:adaniwilmar/authentication/authentication.dart';
import 'package:adaniwilmar/config/app_router.dart';
import 'package:adaniwilmar/flavor.dart';
import 'package:adaniwilmar/repo/splash_repository.dart';
import 'package:adaniwilmar/screen/home.dart';
import 'package:adaniwilmar/screen/screen.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'config/theme.dart';
import 'gmcore/storage/SPUtils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Injector.configure(Flavor.RELEASE);
  await SPUtil.getInstance();
  SPUtil.putBool(Constants.CHECK_APP_UPDATE, true);
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  // firebaseMessaging.requestNotificationPermissions();
  firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true);

  String? token = await FirebaseMessaging.instance.getToken();

  Constants.AUTH_PUSH_TOKEN = token == null ? "" : token;

  SplashRepository().getRemoteKeys().then((value) {
    if (value.statusMsg == "Version Number invalidate") {
      Constants.APPUPDATE_REQUEST = true;
      runApp(const MyHomePage());
    } else {
      runApp(const MyHomePage());
    }
  });
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationBloc()..add(const CheckLoggedIn()),
      child: const MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {},
        child: MaterialApp(
          theme: theme(),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRouter.onGenerateRoute,
          initialRoute: LoginScreen.routeName,
          home: const SplashScreen(),
          // builder: (context, child) {
          //   return MediaQuery(
          //     child: const SplashScreen(),
          //     data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          //   );
          // },
          builder: (context, child) {
            final mediaQueryData = MediaQuery.of(context);
            return MediaQuery(
              child: child!,
              data: mediaQueryData.copyWith(textScaleFactor: 1.0),
            );
          },
        ));
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // Future.delayed(const Duration(seconds: 3), () {
    //   Navigator.pop(context);
    //   if (Constants.AUTH_TOKEN != "") {
    //     Navigator.push(
    //         context, MaterialPageRoute(builder: (context) => HomePageNew()));
    //   } else {
    //     Navigator.push(context,
    //         MaterialPageRoute(builder: (context) => const LoginScreen()));
    //     // MaterialPageRoute(builder: (context) => const LoginPage()));
    //   }
    // });
    Future.delayed(const Duration(seconds: 3), () {
      if (Constants.APPUPDATE_REQUEST) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context1) {
            return new WillPopScope(
              onWillPop: () {
                exit(0);
                //return;
              },
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                ),
                content: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Center(
                          child: Text(
                            "App Update" /*tr("logout")*/,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Center(
                          child: Text(
                            "New version is available for download",
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ElevatedButton(
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  )))),
                              child: new Text("Update",
                                  style: TextStyle(
                                    color: Colors.orangeAccent,
                                  )),
                              onPressed: () {
                                StoreRedirect.redirect(
                                    androidAppId: "com.impiger.adaniwilmar",
                                    iOSAppId: "");
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      } else {
        Navigator.pop(context);
        if (Constants.AUTH_TOKEN != "") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePageNew()));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
          // MaterialPageRoute(builder: (context) => const LoginPage()));
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var topPadding = MediaQuery.of(context).padding.top;
    return Container(
      color: Colors.white,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: (screenHeight - topPadding),
                child: Image.asset(
          'assets/images/awl_logo.gif',
                  fit: BoxFit.fill,
        ),
      ),
    );
  }
}
