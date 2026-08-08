import 'dart:io';

import 'package:adaniwilmar/screen/homebloc/bloc.dart';
import 'package:adaniwilmar/screen/screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:safe_device/safe_device.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/constant.dart';
import '../firebase/CustomNotificationFunction.dart';
import '../gmcore/model/Meta.dart';
import '../gmcore/network/GMLogger.dart';
import '../repo/service_repository.dart';
import '../utils/constant.dart';
import '../widget/common_text.dart';

class HomePageNew extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: HomePageNewState(),
    );
  }
}

class HomePageNewState extends StatefulWidget {
  HomePageNewState({this.selectedIndex = 0, Key? key}) : super(key: key);
  int selectedIndex = 0;

  @override
  State<HomePageNewState> createState() => _HomePageNewState();
}

class _HomePageNewState extends State<HomePageNewState> with TickerProviderStateMixin, WidgetsBindingObserver {
  int selectedIndex = 0;

  _HomePageNewState({this.selectedIndex = 0});

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  late TabController _tabController;
  HomeScreen hmScr = HomeScreen();

  // /// Create a [AndroidNotificationChannel] for heads up notifications
  // late AndroidNotificationChannel channel;
  //
  // bool isFlutterLocalNotificationsInitialized = false;
  //
  // Future<void> setupFlutterNotifications() async {
  //   if (isFlutterLocalNotificationsInitialized) {
  //     return;
  //   }
  //   channel = const AndroidNotificationChannel(
  //     'high_importance_channel', // id
  //     'High Importance Notifications', // title
  //     description:
  //         'This channel is used for important notifications.', // description
  //     importance: Importance.high,
  //   );
  //
  //   flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //
  //   /// Create an Android Notification Channel.
  //   ///
  //   /// We use this channel in the `AndroidManifest.xml` file to override the
  //   /// default FCM channel to enable heads up notifications.
  //   await flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //           AndroidFlutterLocalNotificationsPlugin>()
  //       ?.createNotificationChannel(channel);
  //
  //   /// Update the iOS foreground notification presentation options to allow
  //   /// heads up notifications.
  //   await FirebaseMessaging.instance
  //       .setForegroundNotificationPresentationOptions(
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //   );
  //   isFlutterLocalNotificationsInitialized = true;
  // }

  void configLocalNotification() {
    var initializationSettingsAndroid = const AndroidInitializationSettings('ic_launcher_adaptive_fore');
    var initializationSettingsIOS = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  }

  String? payload;

  // ignore: missing_return
  static Future<dynamic>? back(
    Map<String, dynamic> message,
  ) {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

    if (message.containsKey('notification')) {
      (message['image'] == "" || message['image'].toString().trim().length == 0)
          ? showOngoingNotification(
              flutterLocalNotificationsPlugin,
              title: message['title'].toString(),
              body: message['message'].toString(),
            )
          : showImageNotification(
              flutterLocalNotificationsPlugin,
              title: message['title'].toString(),
              picture: Image.network(message['image']),
              body: message['message'].toString(),
            );
    }
  }

  Future onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title!),
        content: Text(body!),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {},
          )
        ],
      ),
    );
  }

  registerNotification(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage messageObj) {
      RemoteNotification? notification = messageObj.notification;
      // AndroidNotification android = messageObj.notification?.android;
      Map<String, dynamic> message = messageObj.data;
      Constants.isLogoutDoneToClearPreference = false;
      Constants.NOTIFICATION_RECD = true;

      BlocProvider.of<HomeBloc>(context).add(NotifyScreen());
      if (Platform.isIOS) {
        if (message['title'] != null && message['title'].toString() != 'SilentNotification') {
          (message['image'] == null || message['image'] == "" || message['image'].toString().trim().length == 0)
              ? showOngoingNotification(
                  flutterLocalNotificationsPlugin,
                  title: message['title'].toString(),
                  body: message['message'].toString(),
                )
              : showImageNotification(
                  flutterLocalNotificationsPlugin,
                  title: message['title'].toString(),
                  body: message['message'].toString(),
                  picture: Image.network(message['image']),
                );
        }
      } else {
        if (message['title'] != null && message['title'].toString() != 'SilentNotification') {
          (message['image'] == null || message['image'] == "" || message['image'].toString().trim().length == 0)
              ? showOngoingNotification(
                  flutterLocalNotificationsPlugin,
                  title: message['title'].toString(),
                  body: message['message'].toString(),
                )
              : showImageNotification(
                  flutterLocalNotificationsPlugin,
                  title: message['title'].toString(),
                  body: message['message'].toString(),
                  picture: Image.network(message['image']),
                );
        }
      }
      return;
      // showNotification(notification);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (!Constants.isViewMore && !Constants.isLogoutDoneToClearPreference) {
        if (payload != null) {
          try {
            if (Constants.AUTH_USERID != 0) {
              Constants.NOTIFICATION_RECD = true;
              Navigator.pop(context, true);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
            }
          } catch (e) {
            GMLogger.v(e);
          }
        }
      } else if (Constants.isViewMore) {
        Constants.isViewMore = false;
      }
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // void showFlutterNotification(RemoteMessage message) {
  //   print(message.toString());
  //   // RemoteNotification? notification = message.notification;
  //   // AndroidNotification? android = message.notification?.android;
  //   // if (notification != null && android != null) {
  //   //   flutterLocalNotificationsPlugin.show(
  //   //     notification.hashCode,
  //   //     notification.title,
  //   //     notification.body,
  //   //     NotificationDetails(
  //   //       android: AndroidNotificationDetails(
  //   //         channel.id,
  //   //         channel.name,
  //   //         channelDescription: channel.description,
  //   //         // TODO add a proper drawable resource to android, for now using
  //   //         //      one that already exists in example app.
  //   //         icon: 'launch_background',
  //   //       ),
  //   //     ),
  //   //   );
  //   // }
  //   // print(" message received " + message.hashCode.toString());
  //   Map<String, dynamic> data = message.data;
  //   if (data != null) {
  //     flutterLocalNotificationsPlugin.show(
  //       message.notification.hashCode,
  //       data["title"],
  //       data["message"],
  //       NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           channel.id,
  //           channel.name,
  //           channelDescription: channel.description,
  //           // TODO add a proper drawable resource to android, for now using
  //           //      one that already exists in example app.
  //           icon: 'launch_background',
  //         ),
  //       ),
  //     );
  //   }
  // }
  Future<bool> isDeviceCompromised() async {
    bool isRooted = await SafeDevice.isJailBroken;
    bool isEmulator = await SafeDevice.isRealDevice == false;

    return isRooted || isEmulator;
  }

  void checkRoot() async {
    if (await isDeviceCompromised()) {
      showErrorDialog(
          "Security Alert", "For security reasons, this application does not support rooted or jailbroken devices.");
    } else if (await SafeDevice.isDevelopmentModeEnable) {
      showErrorDialog("Security Alert",
          "For security reasons, this application does not support devices with Developer Mode enabled. Please disable Developer Mode in your settings to proceed.");
    }
  }

  void showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => SystemNavigator.pop(),
              child: Text("Exit"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    //checkRoot();
    configLocalNotification();
    registerNotification(context);
    sendAliveTimeNetworkCall();
    _tabController = TabController(
      vsync: this,
      length: Constants.DEALER == Constants.AUTH_ROLEID ? 4 : 5,
      initialIndex: selectedIndex,
    );
    // setupFlutterNotifications();
    // FirebaseMessaging.instance
    //     .getInitialMessage()
    //     .then((RemoteMessage? message) {
    //   if (message != null) {}
    // });

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   Map<String, dynamic> data = message.data;
    //   if (data != null) {
    //     flutterLocalNotificationsPlugin.show(
    //       message.notification.hashCode,
    //       data["title"],
    //       data["message"],
    //       NotificationDetails(
    //         android: AndroidNotificationDetails(
    //           channel.id,
    //           channel.name,
    //           channelDescription: channel.description,
    //           // TODO add a proper drawable resource to android, for now using
    //           //      one that already exists in example app.
    //           icon: 'launch_background',
    //         ),
    //       ),
    //     );
    //   }
    //   // RemoteNotification? notification = message.notification;
    //   // AndroidNotification? android = message.notification?.android;
    //   //
    //   // if (notification != null && android != null) {
    //   //   flutterLocalNotificationsPlugin.show(
    //   //       notification.hashCode,
    //   //       notification.title,
    //   //       notification.body,
    //   //       NotificationDetails(
    //   //         android: AndroidNotificationDetails(
    //   //           channel.id,
    //   //           channel.name,
    //   //           channelDescription: channel.description,
    //   //           // TODO add a proper drawable resource to android, for now using
    //   //           //      one that already exists in example app.
    //   //           icon: 'launch_background',
    //   //         ),
    //   //       ));
    //   // }
    // });
    //
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print(message.toString());
    //   print('A new onMessageOpenedApp event was published!');
    // });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _onItemTappedw(int index) async {
    setState(() async {
      selectedIndex = index;
      // _tabController.animateTo(index,
      //     duration: const Duration(milliseconds: 1000), curve: Curves.easeOut);
      // BlocProvider.of<HomeBloc>(context).add(LoadLastAliveTime());
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('LAST_ALIVE_TIME', DateTime.now().toString());
    });
  }

  Future<void> _onItemTapped(int index) async {
    setState(() {
      selectedIndex = index;
      // _tabController.animateTo(index,
      //     duration: const Duration(milliseconds: 1000), curve: Curves.easeOut);
    });

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('LAST_ALIVE_TIME', DateTime.now().toString());
  }

  Future<bool> _onWillPop(BuildContext context) async {
    bool? exitResult = await showDialog(
      context: context,
      builder: (context) => _buildExitDialog(context),
    );
    return exitResult ?? false;
  }

  AlertDialog _buildExitDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Please confirm'),
      content: const Text('Do you want to exit the app?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text('Yes'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: getRoleMenus(),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          padding: const EdgeInsets.all(8),
          child: TabBar(
            isScrollable: false,
            onTap: _onItemTapped,
            unselectedLabelColor: Constant.colorBlack,
            labelColor: Colors.white,
            indicatorColor: Colors.transparent,
            tabs: getRoleTabs(),
            controller: _tabController,
          ),
        ),
      ),
    );
  }

  List<Widget> getRoleMenus() {
    List<Widget> menuWidgets = [];
    menuWidgets.add(hmScr);
    menuWidgets.add(SaudaScreen());
    menuWidgets.add(SalesScreen());
    if (Constants.AUTH_ROLEID != Constants.DEALER) {
      menuWidgets.add(StpScreen());
    }
    menuWidgets.add(MoreScreen());
    return menuWidgets;
  }

  List<Widget> getRoleTabs() {
    List<Widget> roleWidgets = [];
    roleWidgets.add(Tab(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: SvgPicture.asset(
              selectedIndex == 0 ? "assets/images/HomeON.svg" : "assets/images/HomeOFF.svg",
              fit: BoxFit.fill,
            ),
          ),
          CommonText(
            name: "Home",
            fontColor: Constant.colorBlack,
            fontSize: Constant.fontSize12,
          )
        ],
      ),
    ));
    roleWidgets.add(Tab(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset(
            selectedIndex == 1 ? "assets/images/SaudaON.svg" : "assets/images/SaudaOFF.svg",
            fit: BoxFit.fill,
          ),
        ),
        CommonText(
          name: "Sauda",
          fontColor: Constant.colorDullGray77,
          fontSize: Constant.fontSize12,
        )
      ],
    )));
    roleWidgets.add(Tab(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset(
            selectedIndex == 2 ? "assets/images/SalesON.svg" : "assets/images/SalesOFF.svg",
            fit: BoxFit.fill,
          ),
        ),
        CommonText(
          name: "Sales",
          fontColor: Constant.colorDullGray77,
          fontSize: Constant.fontSize12,
        )
      ],
    )));
    if (Constants.AUTH_ROLEID != Constants.DEALER) {
      roleWidgets.add(Tab(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: SvgPicture.asset(
              selectedIndex == 3 ? "assets/images/STPON.svg" : "assets/images/STPOFF.svg",
              fit: BoxFit.fill,
            ),
          ),
          CommonText(
            name: "STP",
            fontColor: Constant.colorDullGray77,
            fontSize: Constant.fontSize12,
          )
        ],
      )));
    }
    roleWidgets.add(Tab(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset(
            (selectedIndex == 4 && Constants.AUTH_ROLEID != Constants.DEALER) || (selectedIndex == 3 && Constants.AUTH_ROLEID == Constants.DEALER)
                ? "assets/images/MoreON.svg"
                : "assets/images/MoreOFF.svg",
            fit: BoxFit.fill,
          ),
        ),
        CommonText(
          name: "More",
          fontColor: Constant.colorDullGray77,
          fontSize: Constant.fontSize12,
        )
      ],
    )));
    return roleWidgets;
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        //Android
        sendAliveTime();
        break;
      case AppLifecycleState.inactive:
        // ios
        //   if (DashboardWidget.timer != null && DashboardWidget.timer!.isActive) {
        //     DashboardWidget.timer!.cancel();
        //   }
        //   sendAliveTime();
        break;
      case AppLifecycleState.paused:
        //Android
        //   if (DashboardWidget.timer != null && DashboardWidget.timer!.isActive) {
        //     DashboardWidget.timer!.cancel();
        //   }
        //   sendAliveTime();
        break;
      case AppLifecycleState.detached:
        // if (DashboardWidget.timer != null && DashboardWidget.timer!.isActive) {
        //   DashboardWidget.timer!.cancel();
        // }
        sendAliveTime();
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  Future<void> sendAliveTimeNetworkCall() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Meta meta = await ServiceRepository().getLastAliveTime();
    pref.setString('LAST_ALIVE_TIME', DateTime.now().toString());
  }

  Future<void> sendAliveTime() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? lastAliveTime = pref.getString('LAST_ALIVE_TIME');
    DateTime date1 = DateTime.parse(lastAliveTime ?? (DateTime.now().toString()));
    DateTime date2 = DateTime.now().subtract(const Duration(minutes: 30));
    if (date1.isBefore(date2)) {
      sendAliveTimeNetworkCall();
    } else if (date1.isAtSameMomentAs(date2)) {
    } else {
      GMLogger.v("date1 is later than date2");
    }
  }

  @pragma('vm:entry-point')
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage messageObj) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();
    RemoteNotification? notification = messageObj.notification;
    Map<String, dynamic> message = messageObj.data;
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

    if (message.containsKey('notification')) {
      (message['image'] == "" || message['image'].toString().trim().length == 0)
          ? showOngoingNotification(
              flutterLocalNotificationsPlugin,
              title: message['title'].toString(),
              body: message['message'].toString(),
            )
          : showImageNotification(
              flutterLocalNotificationsPlugin,
              title: message['title'].toString(),
              picture: Image.network(message['image']),
              body: message['message'].toString(),
            );
    }

    GMLogger.v("Handling a background message: ${messageObj.messageId}");
  }
}
