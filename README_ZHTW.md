# flutter_window_close

2021 © Weizhong Yang a.k.a zonble

[![Pub](https://img.shields.io/pub/v/flutter_window_close.svg)](https://pub.dartlang.org/packages/flutter_window_close) [![example workflow](https://github.com/zonble/flutter_window_close/actions/workflows/ci.yaml/badge.svg)](https://github.com/zonble/flutter_window_close/actions) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/zonble/flutter_window_close/blob/main/LICENSE)

flutter_window_close 元件可以讓用戶在關閉您所開發的 Flutter 桌面應用程式的視窗
時，詢問用戶是否確定要關閉。這個元件可以用在 Windows、macOS 以及 Linux 等桌面平
台。

![macOS](https://img.shields.io/badge/mac%20os-000000?style=for-the-badge&logo=macos&logoColor=F0F0F0)
![Windows](https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)

![Example](https://raw.githubusercontent.com/zonble/flutter_window_close/main/close.gif)

## 使用說明

在開發桌面應用程式的時候，我們經常會在用戶按下視窗上的關閉按鈕時，跳出「您是否確
定要關閉」這樣的對話框，避免用戶只是因為不小心誤觸，而打斷用戶原本的操作，或是造
成用戶的資料遺失。這個套件可以讓您在使用 Flutter 開發桌面應用程式時，實現上述功
能。

這個套件會在各種桌面平台上，監聽視窗關閉的事件，然後將攔截到的事件送到 Flutter 內
部處理。在使用這個套件時，您只需要在 Flutter 應用程式中，設置一個用來處理視窗關
閉事件的函式，然後用一個 Future 回傳是否確實要關閉的 Boolean 值。比方說，你可以
回傳 Flutter 當中的 showAlert 的結果，範例如下：

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

這個元件介接了以下 API：

- Windows:我們攔截了
  [WM_CLOSE](https://docs.microsoft.com/en-us/windows/win32/winmsg/wm-close)訊息
- macOS:我們攔截了
  [NSWindowDelegate](https://developer.apple.com/documentation/appkit/nswindowdelegate)
  的
  [windowShouldClose(\_:)](https://developer.apple.com/documentation/appkit/nswindowdelegate/1419380-windowshouldclose)
  這個 delegate method
- Linux:
  [Widget::delete-event](https://docs.gtk.org/gtk3/signal.Widget.delete-event.html)
  signal

這個套件不支援行動平台以及 Flutter Web。

## macOS

在 macOS 上，視窗在整個開發框架的定義以及開發觀念，與 Windows/Linux 上不太一樣，
所以，在 macOS 上，使用這個套件時，也需要特別留意一下下面的說明。

在 Windows 與 Linux 平台上，視窗比較像是 MVC 當中的 Controller 的角色，在每個視
窗當中發生的事件，往往會往視窗上面送，而且視窗中的元件也可以比較明確知道上層的
Window 是什麼。在 Windows 上，我們可以用
[GetActiveWindow](https://docs.microsoft.com/zh-tw/windows/win32/api/winuser/nf-winuser-getactivewindow)
拿到所屬視窗，在 Linux 上，則可以用
[gtk_widget_get_ancestor](https://people.gnome.org/~shaunm/girdoc/C/Gtk.Widget.get_ancestor.html)
或是
[gtk_widget_get_toplevel](https://people.gnome.org/~shaunm/girdoc/C/Gtk.Widget.get_toplevel.html)，
但是在 macOS 則不然。

在 macOS 上，視窗比較像是 View 的角色，每個 App 中可以有多個視窗，每個視窗也不見
得都一定會有專屬的 Window Controller，任何一個物件只要建立了一個 IBOutlet，就可
以連接、控制某個視窗。在 Flutter 框架中，每個 Plug-in 目前也沒辦法正確拿到所屬的
View 以及視窗物件。

在目前的實做中，會在 Plugin 啟動時，主動監聽 App 中所有視窗中的第一個，也就是
[NSApplication](https://developer.apple.com/documentation/appkit/nsapplication)
的 singleton 物件中的
[windows](https://developer.apple.com/documentation/appkit/nsapplication/1428402-windows)
列表的第一個。如果你在 macOS 上的 app，就只是根據 Flutter 官方範本產生的，大概沒
有什麼問題，但如果你有多個視窗，而你的第一個視窗又不是 Flutter 所在的視窗的話，
那你就不會收到視窗關閉的事件了。

## Flutter Web

如果你的 Flutter App 是在 Web 中運作，那，我們能做的相當有限。要讓用戶在關閉某個
瀏覽器分頁或是視窗時，跳出提示訊息，只能夠調整
[onbeforeunload](https://developer.mozilla.org/zh-TW/docs/Web/API/WindowEventHandlers/onbeforeunload)
的回傳字串。你可以透過呼叫 `setWebReturnValue` 設置一個提示訊息。

## 授權

本專案使用 MIT 授權
