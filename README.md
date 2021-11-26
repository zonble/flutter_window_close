# flutter_window_close

2021 © Weizhong Yang a.k.a zonble

[![Pub](https://img.shields.io/pub/v/flutter_window_close.svg)](https://pub.dartlang.org/packages/flutter_window_close) [![example workflow](https://github.com/zonble/flutter_window_close/actions/workflows/ci.yaml/badge.svg)](https://github.com/zonble/flutter_window_close/actions) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/zonble/flutter_window_close/blob/main/LICENSE)

flutter_window_close lets your Flutter app has a chance to confirm if the user
wants to close your app. It works on desktop platforms including Windows, macOS
and Linux.

![macOS](https://img.shields.io/badge/mac%20os-000000?style=for-the-badge&logo=macos&logoColor=F0F0F0)
![Windows](https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)

## Getting Started

It is very common that an app would prompt a message like "Do you really want to
quit" when users click on the close button, in order to notify that there are
still undone tasks and the users may lose their data if they want to quit
anyway. It prevents the users from losing data unwillingly.

To let a Flutter desktop app to support that, the plug-in listens to the events
from the window hosting Flutter's view, and send the events to Flutter. What you
need to do is to assign an anonymous function that can answer if the window
should be closed. For example, you can show an alert dialog to ask what the
current user is willing to do:

```dart
FlutterWindowClose.setWindowShouldCloseHandler(() async {
    return await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  title: const Text('Do you really want to quit?'),
                  actions: [
                    ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Yes')),
                    ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('No')),
                  ]);
            });
});
```

The plugin bridges following APIs:

- Windows:
  [WM_CLOSE](https://docs.microsoft.com/en-us/windows/win32/winmsg/wm-close)
  message in WinProc
- macOS:
  [windowShouldClose(\_:)](https://developer.apple.com/documentation/appkit/nswindowdelegate/1419380-windowshouldclose)
  in
  [NSWindowDelegate](https://developer.apple.com/documentation/appkit/nswindowdelegate)
- Linux:
  [Widget::delete-event](https://docs.gtk.org/gtk3/signal.Widget.delete-event.html)
  signal

## macOS

There could be some issues while using the package on macOS. Each platform has
its paradigm and the developer framework macOS sees window objects in a
different way from Windows and Linux.

On Windows and Linux, windows are more like controllers in MVC pattern , and
when it comes to Flutter, there would be always a root window in the process of
an app, and our plugin could easily know which is the window to listen to. In
the code level, we use
[GetActiveWindow](https://docs.microsoft.com/zh-tw/windows/win32/api/winuser/nf-winuser-getactivewindow)
while we can use
[gtk_widget_get_ancestor](https://people.gnome.org/~shaunm/girdoc/C/Gtk.Widget.get_ancestor.html)
or
[gtk_widget_get_toplevel](https://people.gnome.org/~shaunm/girdoc/C/Gtk.Widget.get_toplevel.html).

On the contrary, windows are more like views on macOS. An app can have multiple
windows, and the app can stay still open event all windows are closed. We can
also create an object with multiple IBOutlets to multiple windows. Flutter macOS
does not tell plugins which window is the one running Flutter as well.

The plugin listens to the first window in the
[windows](https://developer.apple.com/documentation/appkit/nsapplication/1428402-windows)
list of the NSApplication object. It works if you have only one window in your
macOS Flutter app. If you just create a new app using the official template for
macOS, you may need not to change anything. However, if your app has multiple
windows, the behavior of the plugin might be unexpectable.
