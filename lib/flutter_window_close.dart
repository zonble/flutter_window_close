import 'dart:async';

import 'package:flutter/services.dart';

class FlutterWindowClose {
  static Future<bool> Function()? _onWindowShoudClose;
  static MethodChannel? _notificationChannel;

  static void setWindowShouldCloseHandler(Future<bool> Function()? handler) {
    _onWindowShoudClose = handler;
    if (_notificationChannel == null) {
      var channel = const MethodChannel('flutter_window_close_notification');
      channel.setMethodCallHandler((call) async {
        if (call.method == 'onWindowClose') {
          final handler = FlutterWindowClose._onWindowShoudClose;
          if (handler != null) {
            final result = await handler();
            if (result) {
              _channel.invokeMethod('destroyWindow');
            }
          } else {
            _channel.invokeMethod('destroyWindow');
          }
        }
        return null;
      });
      _notificationChannel = _channel;
    }
  }

  static const MethodChannel _channel = MethodChannel('flutter_window_close');

  static void closeWindow() {
    _channel.invokeMethod('closeWindow');
  }
}
