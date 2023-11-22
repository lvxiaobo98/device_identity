import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:device_identity/device_identity.dart';

void main() {
  const MethodChannel channel = MethodChannel('device_identity');

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
    expect(await DeviceIdentity.platformVersion, '42');
  });
}
