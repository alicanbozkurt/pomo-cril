import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meta/meta.dart';

Future<NotificationDetails> _imageAndIcon(
    BuildContext context, String picture, String icon) async {
 

  final bigPictureStyleInformation = BigPictureStyleInformation(
    picture,
    BitmapSource.FilePath,
    largeIcon: icon,
    largeIconBitmapSource: BitmapSource.FilePath,
  );

  final androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'big text channel id',
    'big text channel name',
    'big text channel description',
    style: AndroidNotificationStyle.BigPicture,
    styleInformation: bigPictureStyleInformation,
  );
  return NotificationDetails(androidPlatformChannelSpecifics, null);
}

Future showIconAndImageNotification(
  BuildContext context,
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  @required String picture,
  @required String icon,
  int id = 0,
}) async =>
    notifications.show(
        id, title, body, await _imageAndIcon(context, picture, icon));

Future<NotificationDetails> _image(BuildContext context, String picture) async {

  final bigPictureStyleInformation = BigPictureStyleInformation(
    picture,
    BitmapSource.FilePath,
  );

  final androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'big text channel id',
    'big text channel name',
    'big text channel description',
    style: AndroidNotificationStyle.BigPicture,
    styleInformation: bigPictureStyleInformation,
  );
  return NotificationDetails(androidPlatformChannelSpecifics, null);
}

Future showImageNotification(
  BuildContext context,
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  @required String picture,
  int id = 0,
}) async =>
    notifications.show(id, title, body, await _image(context, picture));

Future<NotificationDetails> _icon(BuildContext context, String icon) async {


  final androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'big text channel id',
    'big text channel name',
    'big text channel description',
    largeIcon: icon,
  );
  return NotificationDetails(androidPlatformChannelSpecifics, null);
}

Future showIconNotification(
  BuildContext context,
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  @required String icon,
  int id = 0,
}) async =>
    notifications.show(id, title, body, await _icon(context, icon));

NotificationDetails get _noSound {
  final androidChannelSpecifics = AndroidNotificationDetails(
    'silent channel id',
    'silent channel name',
    'silent channel description',
    playSound: false,
  );
  final iOSChannelSpecifics = IOSNotificationDetails(presentSound: false);

  return NotificationDetails(androidChannelSpecifics, iOSChannelSpecifics);
}

Future showSilentNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  int id = 0,
}) =>
    _showNotification(notifications,
        title: title, body: body, id: id, type: _noSound);

NotificationDetails get _ongoing {
  final androidChannelSpecifics = AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    'your channel description',
    importance: Importance.Max,
    priority: Priority.High,
    ongoing: true,
    autoCancel: false,
  );
  final iOSChannelSpecifics = IOSNotificationDetails();
  return NotificationDetails(androidChannelSpecifics, iOSChannelSpecifics);
}

Future showOngoingNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  int id = 0,
}) =>
    _showNotification(notifications,
        title: title, body: body, id: id, type: _ongoing);

Future _showNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  @required NotificationDetails type,
  int id = 0,
}) =>
    notifications.show(id, title, body, type);