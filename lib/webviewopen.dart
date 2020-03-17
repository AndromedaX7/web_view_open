import 'dart:async';

import 'package:flutter/services.dart';

class Webviewopen {
  static const MethodChannel _channel = const MethodChannel('webviewopen');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static void toDetails(String content) async {
    await _channel.invokeMethod('toDetails', content);
  }
}
