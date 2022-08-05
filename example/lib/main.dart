import 'package:flutter/material.dart';
import 'dart:async';
import 'package:window_manager/window_manager.dart';
import 'package:windows_local_notification/windows_local_notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

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

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.

    // Add in main method.

    LocalNotification notification = LocalNotification(
      title: "Notifikasi Pesan",
      body: "hello flutter windows!",
    );
    notification.onShow = () {
      print('onShow ${notification.identifier}');
    };
    notification.onClose = (closeReason) {
      // Only supported on windows, other platforms closeReason is always unknown.
      switch (closeReason) {
        case LocalNotificationCloseReason.userCanceled:
          // do something
          break;
        case LocalNotificationCloseReason.timedOut:
          // do something
          break;
        default:
      }
      print('onClose $closeReason');
    };
    notification.onClick = () {
      print('onClick ${notification.identifier}');
    };
    notification.onClickAction = (actionIndex) {
      print('onClickAction ${notification.identifier} - $actionIndex');
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
                await initPlatformState();
              },
              child: const Text("Show Notification")),
        ),
      ),
    );
  }
}
