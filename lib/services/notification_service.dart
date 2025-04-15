import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  
  final List<String> _calmingMessages = [
    'Take a moment to breathe deeply and find your center.',
    'Remember to pause and check in with yourself today.',
    'A few minutes of mindfulness can make a big difference.',
    'You\'re doing great. Take time to acknowledge your progress.',
    'Your well-being matters. How about a quick relaxation exercise?',
    'Feeling stressed? Try a short breathing exercise.',
    'Take a mindful moment to reset and recharge.',
    'Remember to be kind to yourself today.',
    'A calm mind leads to better decisions.',
    'Small steps toward peace add up to big changes.',
  ];

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _notifications.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );
  }

  String _getRandomMessage() {
    _calmingMessages.shuffle();
    return _calmingMessages.first;
  }

  Future<void> scheduleDailyNotification(TimeOfDay time, int id, String title) async {
    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notifications.zonedSchedule(
      id,
      title,
      _getRandomMessage(),
      tz.TZDateTime.from(scheduledDate, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_notifications',
          'Daily Reminders',
          channelDescription: 'Daily mindfulness and exercise reminders',
          importance: Importance.high,
          priority: Priority.high,
          sound: RawResourceAndroidNotificationSound('notification_sound'),
          playSound: true,
          enableVibration: true,
          color: const Color(0xFF66D1B8),
        ),
        iOS: const DarwinNotificationDetails(
          sound: 'notification_sound.aiff',
          presentSound: true,
          presentBadge: true,
          presentAlert: true,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> scheduleAllDailyNotifications(
    TimeOfDay morning,
    TimeOfDay afternoon,
    TimeOfDay evening,
  ) async {
    await cancelAllNotifications();
    
    await scheduleDailyNotification(
      morning,
      1,
      'Morning Mindfulness',
    );
    
    await scheduleDailyNotification(
      afternoon,
      2,
      'Afternoon Reset',
    );
    
    await scheduleDailyNotification(
      evening,
      3,
      'Evening Reflection',
    );
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  Future<void> requestPermissions() async {
    await _notifications.resolvePlatformSpecificImplementation<
      IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
  }
} 