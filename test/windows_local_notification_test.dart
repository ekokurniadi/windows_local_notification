import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:windows_local_notification/windows_local_notification.dart';

void main() {
  const MethodChannel channel = MethodChannel('windows_local_notification');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    // expect(await WindowsLocalNotification.platformVersion, '42');
  });
}
