import 'dart:io';
import 'package:bibleram/main.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static const String _darwinNotificationCategoryIdentifier =
      'bibleram/daily_notifications';

  NotificationService()
      : flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    final List<DarwinNotificationCategory> darwinNotificationCategories =
        <DarwinNotificationCategory>[
      DarwinNotificationCategory(
        _darwinNotificationCategoryIdentifier,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.text(
            'text_1',
            'Action 1',
            buttonTitle: 'Send',
            placeholder: 'Placeholder',
          ),
        ],
      ),
    ];

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: false,
      notificationCategories: darwinNotificationCategories,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    await _configureLocalTimeZone();
    bool pingedOnReminders =
        sharedPreferences.getBool("pingedOnReminders") ?? false;
    if (!pingedOnReminders) {
      scheduleSystemReminderNotifications();
      sharedPreferences.setBool("pingedOnReminders", true);
    }
  }

  Future<void> _configureLocalTimeZone() async {
    if (kIsWeb || Platform.isLinux) {
      return;
    }
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  tz.TZDateTime _nextInstanceOfTime(DateTime notificationTime) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      notificationTime.hour,
      notificationTime.minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> scheduleSystemReminderNotifications() async {
    var now = DateTime.now();
    var tomorrow = now.add(Duration(days: 1));
    await flutterLocalNotificationsPlugin.zonedSchedule(
      -1,
      'Remember to practice scripture',
      'Click here to choose a verse to study',
      _nextInstanceOfTime(
        tz.TZDateTime(
            tz.local, tomorrow.year, tomorrow.month, tomorrow.day, 10),
      ),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'system_defined_study_notification',
          'System Defined Practice Notifications',
          channelDescription:
              'Notifications the user defines to study scripture',
        ),
        iOS: DarwinNotificationDetails(
          categoryIdentifier: _darwinNotificationCategoryIdentifier,
          subtitle: 'Remember to set a practice schedule to best practice',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  Future<void> scheduleDailyNotification({
    required DateTime notificationTime,
    required int id,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'Remember to practice scripture',
      'Click here to choose a verse to study',
      _nextInstanceOfTime(notificationTime),
      const NotificationDetails(
          android: AndroidNotificationDetails(
            'user_defined_study_notification',
            'User Defined Practice Notifications',
            channelDescription:
                'Notifications the user defines to study scripture',
          ),
          iOS: DarwinNotificationDetails(
              categoryIdentifier: _darwinNotificationCategoryIdentifier,
              subtitle: 'Click here to choose a verse to study')),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> clearNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
