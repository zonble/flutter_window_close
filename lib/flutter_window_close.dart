import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A plug-in that helps your Flutter desktop app to handle window close event.
///
/// It supports Windows, macOS and Linux.
class FlutterWindowClose {
  FlutterWindowClose._();

  static Future<bool> Function()? _onWindowShouldClose;
  static MethodChannel? _notificationChannel;
  static const MethodChannel _channel = MethodChannel('flutter_window_close');

  static Future<void> _initIfRequired() async {
    if (_notificationChannel != null) {
      return;
    }

    WidgetsFlutterBinding.ensureInitialized();
    await _channel.invokeMethod('init');

    var channel = const MethodChannel('flutter_window_close_notification');
    channel.setMethodCallHandler((call) async {
      if (call.method == 'onWindowClose') {
        final handler = FlutterWindowClose._onWindowShouldClose;

        // Note: the 'destroyWindow' method just close the window without
        // any confirming.
        if (handler != null) {
          final result = await handler();
          if (result) _channel.invokeMethod('destroyWindow');
        } else {
          _channel.invokeMethod('destroyWindow');
        }
      }
      return null;
    });
    _notificationChannel = _channel;
  }

  /// Sets a function to handle window close events.
  ///
  /// When a user click on the close button on a window, the plug-in redirects
  /// the event to your function. The function should return a future that
  /// returns a boolean to tell the plug-in whether the user really wants to
  /// close the window or not. True will let the window to be closed, while
  /// false let the window to remain open.
  ///
  /// By default there is no handler, and the window will be directly closed
  /// when a window close event happens. You can also reset the handler by
  /// passing null to the method.
  ///
  /// Example:
  ///
  /// ``` dart
  /// FlutterWindowClose.setWindowShouldCloseHandler(() async {
  ///     return await showDialog(
  ///         context: context,
  ///         builder: (context) {
  ///           return AlertDialog(
  ///           title: const Text('Do you really want to quit?'),
  ///           actions: [
  ///             ElevatedButton(
  ///             onPressed: () => Navigator.of(context).pop(true),
  ///             child: const Text('Yes')),
  ///             ElevatedButton(
  ///             onPressed: () => Navigator.of(context).pop(false),
  ///             child: const Text('No')),
  ///           ]);
  ///         });
  /// });
  /// ```
  ///
  /// The method does not support Flutter Web.
  static Future<void> setWindowShouldCloseHandler(
      Future<bool> Function()? handler) async {
    if (kIsWeb) throw Exception('The method does not work in Flutter Web.');
    _onWindowShouldClose = handler;
    await _initIfRequired();
  }

  /// Sends a message to close the window hosting your Flutter app.
  ///
  /// - On Windows, it calls `PostMessage(handle, WM_CLOSE, 0, 0)`. See
  ///   [WM_CLOSE](https://docs.microsoft.com/en-us/windows/win32/winmsg/wm-close)
  /// - On macOS, it calls [-\[NSWindow performClose:\]](https://developer.apple.com/documentation/appkit/nswindow/1419288-performclose?language=objc)
  /// - On Linux, it calls [gtk_window_close](https://gnome.pages.gitlab.gnome.org/gtk/gtk4/method.Window.close.html)
  /// - The method does not support Flutter Web.
  static Future<void> closeWindow() async {
    if (kIsWeb) throw Exception('The method does not work in Flutter Web.');
    await _initIfRequired();
    await _channel.invokeMethod('closeWindow');
  }

  static Future<void> destroyWindow() async {
    if (kIsWeb) throw Exception('The method does not work in Flutter Web.');
    await _initIfRequired();
    await _channel.invokeMethod('destroyWindow');
  }

  /// Sets a return value when the current window or tab is being closed
  /// when your app is running in Flutter Web.
  static Future<void> setWebReturnValue(String? returnValue) async {
    if (!kIsWeb) throw Exception('The method only works in Flutter Web.');
    await _channel.invokeMethod('setWebReturnValue', returnValue);
  }
}
