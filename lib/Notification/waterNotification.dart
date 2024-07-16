import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  // إنشاء إشعار دوري مرتين في اليوم
  static void createDailyNotifications() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1001,
        channelKey: 'daily_channel',
        title: 'تذكير صباحي',
        body: 'لا تنسى شرب الماء اليوم!',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: 8,  // الساعة
        minute: 0,  // الدقيقة
        second: 0,
        millisecond: 0,
        preciseAlarm: true,
        repeats: true,
      ),
    );

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1002,
        channelKey: 'daily_channel',
        title: 'تذكير مسائي',
        body: 'تأكد من شرب كمية كافية من الماء قبل النوم!',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: 20,  // الساعة
        minute: 0,  // الدقيقة
        second: 0,
        millisecond: 0,
        preciseAlarm: true,
        repeats: true,
      ),
    );
  }
}
