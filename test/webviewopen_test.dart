import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webviewopen/webviewopen.dart';

void main() {
  const MethodChannel channel = MethodChannel('webviewopen');

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
    expect(await Webviewopen.platformVersion, '42');
  });
}
