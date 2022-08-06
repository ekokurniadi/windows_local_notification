import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'windows_notification_action.dart';
import 'windows_notification_close_reason.dart';
import 'windows_notification_listener.dart';
import 'windows_local_notification.dart';

class WindowsNotification with WindowsNotificationListener {
  String identifier = const Uuid().v4();

  /// Representing the title of the notification.
  String title;

  /// Representing the subtitle of the notification.
  String? subtitle;

  /// Representing the body of the notification.
  String? body;

  /// Representing whether the notification is silent.
  bool silent;

  /// Representing the actions of the notification.
  List<WindowsNotificationAction>? actions;

  VoidCallback? onShow;
  ValueChanged<WindowsNotificationCloseReason>? onClose;
  VoidCallback? onClick;
  ValueChanged<int>? onClickAction;

  WindowsNotification({
    String? identifier,
    required this.title,
    this.subtitle,
    this.body,
    this.silent = false,
    this.actions,
  }) {
    if (identifier != null) {
      this.identifier = identifier;
    }
    windowsLocalNotification.addListener(this);
  }

  factory WindowsNotification.fromJson(Map<String, dynamic> json) {
    List<WindowsNotificationAction>? actions;

    if (json['actions'] != null) {
      Iterable l = json['actions'] as List;
      actions =
          l.map((item) => WindowsNotificationAction.fromJson(item)).toList();
    }

    return WindowsNotification(
      identifier: json['identifier'],
      title: json['title'],
      subtitle: json['subtitle'],
      body: json['body'],
      silent: json['silent'],
      actions: actions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'title': title,
      'subtitle': subtitle ?? '',
      'body': body ?? '',
      'silent': silent,
      'actions': (actions ?? []).map((e) => e.toJson()).toList(),
    }..removeWhere((key, value) => value == null);
  }

  /// Immediately shows the notification to the user
  Future<void> show() {
    return windowsLocalNotification.notify(this);
  }

  /// Closes the notification immediately.
  Future<void> close() {
    return windowsLocalNotification.close(this);
  }

  /// Destroys the notification immediately.
  Future<void> destroy() {
    return windowsLocalNotification.destroy(this);
  }

  @override
  void onLocalNotificationShow(WindowsNotification notification) {
    if (identifier != notification.identifier || onShow == null) {
      return;
    }
    onShow!();
  }

  @override
  void onLocalNotificationClose(
    WindowsNotification notification,
    WindowsNotificationCloseReason closeReason,
  ) {
    if (identifier != notification.identifier || onClose == null) {
      return;
    }
    onClose!(closeReason);
  }

  @override
  void onLocalNotificationClick(WindowsNotification notification) {
    if (identifier != notification.identifier || onClick == null) {
      return;
    }
    onClick!();
  }

  @override
  void onLocalNotificationClickAction(
    WindowsNotification notification,
    int actionIndex,
  ) {
    if (identifier != notification.identifier || onClickAction == null) {
      return;
    }
    onClickAction!(actionIndex);
  }
}
