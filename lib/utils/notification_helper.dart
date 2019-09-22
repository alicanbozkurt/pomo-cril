
import 'package:local_notifications/local_notifications.dart';

/*Future<NotificationDetails> _imageAndIcon(
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
*/

class NotificationHelper{
  AndroidNotificationChannel channel;
  init() async{
    channel = const AndroidNotificationChannel(
      id: 'default_notification',
      name: 'Default',
      description: 'Grant this app the ability to show notifications',
      importance: AndroidNotificationChannelImportance.HIGH
);

// Create the notification channel (this is a no-op on iOS and android <8.0 devices)
// Only need to run this one time per App install, any calls after that will be a no-op at the native level
// but will still need to use the platform channel. For this reason, avoid calling this except for the 
// first time you need to create the channel.
  await LocalNotifications.createAndroidNotificationChannel(channel: channel);

  }

Future showNotification(
   String title,
   String body,
   List<NotificationAction> actions
  ) async{

    await LocalNotifications.createNotification(
      title: title,
      content: body,
      id: 0,
      androidSettings: new AndroidSettings(
          channel: channel
      ),
      actions: actions
    );
  }
}