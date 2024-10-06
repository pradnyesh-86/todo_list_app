import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/task.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);
    await _notifications.initialize(initSettings);
  }

  static Future<void> scheduleNotification(Task task) async {
    await _notifications.zonedSchedule(
      task.id!,
      'Task Reminder',
      task.title,
      tz.TZDateTime.from(
          task.dueDate, tz.local), // Make sure to initialize timezones
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id',
          'channel_name',
          importance: Importance.max,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation
              .wallClockTime, // Required argument
      matchDateTimeComponents: DateTimeComponents
          .time, // Optional: Add this if you want to match a specific time component
    );
  }
}
