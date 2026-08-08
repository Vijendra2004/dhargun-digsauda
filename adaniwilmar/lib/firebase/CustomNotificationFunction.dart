import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:adaniwilmar/firebase/utilImage.dart';

Future<NotificationDetails> _image(Image picture) async {
  final picturePath = await saveImage(picture);

  final bigPictureStyleInformation =
      BigPictureStyleInformation(FilePathAndroidBitmap(picturePath));

  final androidPlatformChannelSpecifics = AndroidNotificationDetails(
    Platform.isAndroid ? 'com.impiger.adaniwilmar' : 'com.impiger.adaniwilmar',
    'Adani Sauda App',
    //style: AndroidNotificationStyle.BigPicture,
    styleInformation: bigPictureStyleInformation,
  );

  return NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );
}

Future showImageNotification(
  FlutterLocalNotificationsPlugin notifications, {
  required String title,
  required String body,
  required Image picture,
  int id = 0,
}) async =>
    notifications.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: await _image(picture),
    );

NotificationDetails get _ongoing {
  final androidChannelSpecifics = AndroidNotificationDetails(
    Platform.isAndroid ? 'com.impiger.adaniwilmar' : 'com.impiger.adaniwilmar',
    'Adani Sauda App',
    importance: Importance.max,
    priority: Priority.high,
    icon: 'ic_launcher_adaptive_fore',
  );
  // final iOSChannelSpecifics = IOSNotificationDetails();
  return NotificationDetails(
    android: androidChannelSpecifics,
  );
}

Future showOngoingNotification(
  FlutterLocalNotificationsPlugin notifications, {
  required String title,
  required String body,
  int id = 0,
}) =>
    _showNotification(notifications,
        title: title, body: body, id: id, type: _ongoing);

Future _showNotification(
  FlutterLocalNotificationsPlugin notifications, {
  required String title,
  required String body,
  required NotificationDetails type,
  int id = 0,
}) =>
    notifications.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: type,
    );
