import 'windows_notification_close_reason.dart';
import 'windows_notification.dart';

abstract class WindowsNotificationListener {
  void onLocalNotificationShow(WindowsNotification notification) {}
  void onLocalNotificationClose(
    WindowsNotification notification,
    WindowsNotificationCloseReason closeReason,
  ) {}
  void onLocalNotificationClick(WindowsNotification notification) {}
  void onLocalNotificationClickAction(
    WindowsNotification notification,
    int actionIndex,
  ) {}
}
