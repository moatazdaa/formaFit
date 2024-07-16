import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

void initializeNotifications() {
  AwesomeNotifications().initialize(
    'resource://drawable/notification_icon',
    [
      NotificationChannel(
        channelKey: 'daily_reminders',
        channelName: 'Daily reminders',
        channelDescription: 'Notification channel for daily reminders',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.amber,
        importance: NotificationImportance.High,
        playSound: true,
        enableVibration: true,
      ),
    ],
  );
}

void scheduleDailyReminders() {
  final now = DateTime.now();
  final nextTriggerTime = DateTime(now.year, now.month, now.day, 8, 0); // الساعة 8 صباحًا

  // إذا كانت الوقت الحالي قد تجاوز الساعة 8 صباحًا، أضف يومًا إضافيًا
  final scheduleTime = now.isAfter(nextTriggerTime) ? nextTriggerTime.add(Duration(days: 1)) : nextTriggerTime;

  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10,
      channelKey: 'daily_reminders',
      title: 'تذكير بالتمارين',
      body: 'لا تنسى إكمال تحدياتك اليومية!',
    ),
    schedule: NotificationCalendar.fromDate(date: scheduleTime),
  );
}
