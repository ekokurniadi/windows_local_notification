import 'package:flutter/material.dart';
import 'dart:async';
import 'package:window_manager/window_manager.dart';
import 'package:windows_local_notification/windows_local_notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// window manager is not required
  /// if you want handle some feature
  /// like prevent close, you can use
  /// [window manager]
  await windowManager.ensureInitialized();

  /// required setup for initialize [WindowsLocalNotification]
  await windowsLocalNotification.setup(
    appName: 'Windows Local Notification',
    shortcutPolicy: ShortcutPolicy.requireCreate,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> showNotification() async {
    WindowsNotification notification = WindowsNotification(
      title: "Notifikasi Pesan",
      body: "hello flutter windows!",
      actions: [
        WindowsNotificationAction(type: 'button', text: 'Show'),
        WindowsNotificationAction(type: 'button', text: 'Dismiss'),
      ],
    );
    notification.onShow = () {
      // TODO : CREATE YOUR FUNCTION HERE IF YOU WANT MAKE SOMETHING WHEN NOTIFICATION IS SHOWING
    };
    notification.onClose = (closeReason) {
      /// Only supported on [windows], other platforms closeReason is always unknown.
      switch (closeReason) {
        case WindowsNotificationCloseReason.userCanceled:
          // do something
          break;
        case WindowsNotificationCloseReason.timedOut:
          // do something
          break;
        default:
      }
    };
    notification.onClick = () {
      // TODO : HANDLE EVENT ON CLICK NOTIFICATION
    };
    notification.onClickAction = (actionIndex) {
      // TODO : HANDLE EVENT BUTTON ACTION ON CLICK NOTIFICATION
    };

    notification.show();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: ElevatedButton(
              onPressed: () async {
                await showNotification();
              },
              child: const Text("Show Notification")),
        ),
      ),
    );
  }
}
