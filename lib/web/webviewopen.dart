import 'dart:html';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class WebviewopenPlugin {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
        "webviewopen", const StandardMethodCodec(), registrar.messenger);
    var plugin = WebviewopenPlugin();
    channel.setMethodCallHandler(plugin.handleMethod);
  }

  Future<dynamic> handleMethod(MethodCall call) {
    if (call.method == 'getPlatformVersion') {
      return Future.value(window.navigator.appVersion);
    } else if (call.method == 'toDetails') {
//      ${call.arguments}
      window.sessionStorage['value'] = call.arguments;
      window.open("details.html", "${DateTime.now()}");
    }
    return null;
  }
}
