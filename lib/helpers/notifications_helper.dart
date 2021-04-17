import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationsHelper {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static const AndroidInitializationSettings _androidInitializationSettings =
      AndroidInitializationSettings('ic_launcher');
  static const IOSInitializationSettings _iosInitializationSettings =
      IOSInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );
  static const InitializationSettings _initializationSettings =
      InitializationSettings(
          android: _androidInitializationSettings,
          iOS: _iosInitializationSettings);

  NotificationsHelper() {
    flutterLocalNotificationsPlugin.initialize(_initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: ' + payload);
      }
    });
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future<bool> _requestiOSPermissions() {
    return flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> cancelNotification(int exerciseId) async {
    //Cancel latest notification
    await flutterLocalNotificationsPlugin.cancel(exerciseId);
  }

  Future<void> zonedScheduleNotification(
      int exerciseId, String exerciseName, int trainingHour) async {
    await _configureLocalTimeZone();
    await _requestiOSPermissions();
    cancelNotification(exerciseId);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        exerciseId,
        '$exerciseName training',
        'It is show time baby',
        tz.TZDateTime.from(DateUtils.dateOnly(DateTime.now()), tz.local)
            .add(Duration(days: 2, hours: trainingHour)),
        const NotificationDetails(
          android: AndroidNotificationDetails('your channel id',
              'your channel name', 'your channel description'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
