import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class NotificationsApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future _notificationSound() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('mycalls', 'callertones',
        channelDescription: 'client to driver call notification',
        sound: RawResourceAndroidNotificationSound(''),
        importance: Importance.max,
        priority: Priority.high,
        playSound: false,
        enableVibration: true,
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await _notifications.show(
      0, ' Driver ', 'Incoming Voice Call',
      platformChannelSpecifics, payload: 'call'
    );
  }
  static Future _notificationChat() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('mychat', 'chattone',
        channelDescription: 'client to driver chat notification',
        sound: RawResourceAndroidNotificationSound('dingdong'),
        importance: Importance.max,
        priority: Priority.high,
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await _notifications.show(
      0, ' Driver ', 'You have a new message',
      platformChannelSpecifics, payload: 'chat'
    );
  }

  static Future init({bool initScheduled = false}) async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: iOS);

    await _notifications.initialize(settings, onSelectNotification: (payload) async {
      onNotifications.add(payload);
    }
    );
  }

  static Future showsoundNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async => _notifications.show(id, title, body, await _notificationSound(), payload: payload);

  static Future showchatNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async => _notifications.show(id, title, body, await _notificationChat(), payload: payload);

}