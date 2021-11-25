import 'dart:async';

import 'package:flutter/services.dart';

class FlutterWindowClose {
  static const MethodChannel _channel = MethodChannel('flutter_window_close');

  static void exit({int exitCode = 0}) {
    _channel.invokeMethod('exit', {'exit_code': exitCode});
  }

  static void exitAnyway({int exitCode = 0}) {
    _channel.invokeMethod('exitAnyWay', {'exit_code': exitCode});
  }

// static Future<String?> get platformVersion async {
//   final String? version = await _channel.invokeMethod('getPlatformVersion');
//   return version;
// }
}
