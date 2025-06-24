import 'dart:async';

// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
import 'dart:js_interop';
import 'package:web/web.dart';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// A web implementation of the FlutterHi plugin.
class FlutterWindowClosePluginWeb {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'flutter_window_close',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = FlutterWindowClosePluginWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  FlutterWindowClosePluginWeb() {
    window.addEventListener(
      'beforeunload',
      (JSAny event) {
        if (event.isA<BeforeUnloadEvent>()) {
          final unloadEvent = event as BeforeUnloadEvent;
          unloadEvent.preventDefault();
          if (_returnValue != null) {
            unloadEvent.returnValue = _returnValue!;
          }
        }
      }.toJS,
    );
  }

  String? _returnValue;

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'setWebReturnValue':
        _returnValue = call.arguments;
        break;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'flutter_hi for web doesn\'t implement \'${call.method}\'',
        );
    }
  }
}
