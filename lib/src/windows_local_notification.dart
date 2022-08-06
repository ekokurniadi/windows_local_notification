import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'windows_notification_close_reason.dart';
import 'windows_notification_listener.dart';
import 'windows_notification.dart';
import 'shortcut_policy.dart';

class WindowsLocalNotification {
  WindowsLocalNotification._() {
    _channel.setMethodCallHandler(_methodCallHandler);
  }

  /// The shared instance of [WindowsLocalNotification].
  static final WindowsLocalNotification instance = WindowsLocalNotification._();

  final MethodChannel _channel =
      const MethodChannel('windows_local_notification');

  final ObserverList<WindowsNotificationListener> _listeners =
      ObserverList<WindowsNotificationListener>();

  bool _isInitialized = false;
  String? _appName;
  final Map<String, WindowsNotification> _notifications = {};

  Future<void> _methodCallHandler(MethodCall call) async {
    String notificationId = call.arguments['notificationId'];
    WindowsNotification? localNotification = _notifications[notificationId];

    for (final WindowsNotificationListener listener in listeners) {
      if (!_listeners.contains(listener)) {
        return;
      }

      if (call.method == 'onLocalNotificationShow') {
        listener.onLocalNotificationShow(localNotification!);
      } else if (call.method == 'onLocalNotificationClose') {
        WindowsNotificationCloseReason closeReason =
            WindowsNotificationCloseReason.values.firstWhere(
          (e) => describeEnum(e) == call.arguments['closeReason'],
          orElse: () => WindowsNotificationCloseReason.unknown,
        );
        listener.onLocalNotificationClose(
          localNotification!,
          closeReason,
        );
      } else if (call.method == 'onLocalNotificationClick') {
        listener.onLocalNotificationClick(localNotification!);
      } else if (call.method == 'onLocalNotificationClickAction') {
        int actionIndex = call.arguments['actionIndex'];
        listener.onLocalNotificationClickAction(
          localNotification!,
          actionIndex,
        );
      } else {
        throw UnimplementedError();
      }
    }
  }

  List<WindowsNotificationListener> get listeners {
    final List<WindowsNotificationListener> localListeners =
        List<WindowsNotificationListener>.from(_listeners);
    return localListeners;
  }

  bool get hasListeners {
    return _listeners.isNotEmpty;
  }

  void addListener(WindowsNotificationListener listener) {
    _listeners.add(listener);
  }

  void removeListener(WindowsNotificationListener listener) {
    _listeners.remove(listener);
  }

  Future<void> setup({
    required String appName,
    ShortcutPolicy shortcutPolicy = ShortcutPolicy.requireCreate,
  }) async {
    final Map<String, dynamic> arguments = {
      'appName': appName,
      'shortcutPolicy': describeEnum(shortcutPolicy),
    };
    if (Platform.isWindows) {
      _isInitialized = await _channel.invokeMethod('setup', arguments);
    } else {
      _isInitialized = true;
    }
    _appName = appName;
  }

  /// Immediately shows the notification to the user.
  Future<void> notify(WindowsNotification notification) async {
    if ((Platform.isLinux || Platform.isWindows) && !_isInitialized) {
      throw Exception(
        'Not initialized, please call `windowsLocalNotification.setup` first to initialize',
      );
    }

    _notifications[notification.identifier] = notification;

    final Map<String, dynamic> arguments = notification.toJson();
    arguments['appName'] = _appName;
    await _channel.invokeMethod('notify', arguments);
  }

  /// Closes the notification immediately.
  Future<void> close(WindowsNotification notification) async {
    final Map<String, dynamic> arguments = notification.toJson();
    await _channel.invokeMethod('close', arguments);
  }

  /// Destroys the notification immediately.
  Future<void> destroy(WindowsNotification notification) async {
    await close(notification);
    removeListener(notification);
    _notifications.remove(notification.identifier);
  }
}

final windowsLocalNotification = WindowsLocalNotification.instance;
