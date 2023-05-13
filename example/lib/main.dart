import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
// import 'package:menubar/menubar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MainPage());
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var _alertShowing = false;
  var _index = 0;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      FlutterWindowClose.setWebReturnValue('Are you sure?');
      return;
    }

    FlutterWindowClose.setWindowShouldCloseHandler(() async {
      if (_index == 0) {
        if (_alertShowing) return false;
        _alertShowing = true;

        return await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  title: const Text('Do you really want to quit?'),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                          _alertShowing = false;
                        },
                        child: const Text('Yes')),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                          _alertShowing = false;
                        },
                        child: const Text('No'))
                  ]);
            });
      } else if (_index == 1) {
        final result = await FlutterPlatformAlert.showCustomAlert(
          windowTitle: "Really?",
          text: "Do you really want to quit?",
          positiveButtonTitle: "Quit",
          negativeButtonTitle: "Cancel",
        );
        return result == CustomButton.positiveButton;
      } else if (_index == 3) {
        return await Future.delayed(const Duration(seconds: 1), () => true);
      }
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(title: const Text('flutter_window_close')),
        body: const Center(child: Text('Please try to close the tab/window.')),
      );
    }

    final platformMenus = <PlatformMenuItem>[
      PlatformMenu(label: 'Flutter Window Close Example', menus: [
        PlatformMenuItem(
            label: 'Quit Flutter Window Close Example',
            onSelected: () => FlutterWindowClose.closeWindow())
      ]),
      PlatformMenu(label: 'Help', menus: [
        PlatformMenuItem(
            label: 'About',
            onSelected: () => FlutterPlatformAlert.showCustomAlert(
                  windowTitle: 'About',
                  text:
                      'flutter_window_close\n\nhttps://pub.dev/packages/flutter_window_close',
                ))
      ]),
    ];

    final menu = MenuBar(
        style: MenuStyle(
          elevation: MaterialStateProperty.resolveWith((states) => 0),
          backgroundColor:
              MaterialStateColor.resolveWith((states) => Colors.white),
        ),
        children: [
          SubmenuButton(
            menuChildren: [
              MenuItemButton(
                  child: const Text('Exit'),
                  onPressed: () => FlutterWindowClose.closeWindow()),
            ],
            child: const Text('File'),
          ),
          SubmenuButton(
            menuChildren: [
              MenuItemButton(
                  child: const Text('About'),
                  onPressed: () {
                    FlutterPlatformAlert.showCustomAlert(
                      windowTitle: 'About',
                      text:
                          'flutter_window_close\n\nhttps://pub.dev/packages/flutter_window_close',
                    );
                  }),
            ],
            child: const Text('Help'),
          ),
        ]);

    var inner = Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Platform.isLinux || Platform.isWindows) menu,
          Expanded(
            child: Scaffold(
              appBar: AppBar(title: const Text('flutter_window_close')),
              body: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    leading: Radio<int>(
                      groupValue: _index,
                      value: 0,
                      onChanged: (int? value) =>
                          setState(() => _index = value ?? 0),
                    ),
                    title: const Text('Confirm Closing Using Flutter'),
                  ),
                  ListTile(
                    leading: Radio<int>(
                      groupValue: _index,
                      value: 1,
                      onChanged: (int? value) =>
                          setState(() => _index = value ?? 1),
                    ),
                    title:
                        const Text('Confirm Closing Using Native Alert Dialog'),
                  ),
                  ListTile(
                    leading: Radio<int>(
                      groupValue: _index,
                      value: 2,
                      onChanged: (int? value) =>
                          setState(() => _index = value ?? 2),
                    ),
                    title: const Text('No Confirm'),
                  ),
                  ListTile(
                    leading: Radio<int>(
                      groupValue: _index,
                      value: 3,
                      onChanged: (int? value) =>
                          setState(() => _index = value ?? 2),
                    ),
                    title: const Text('No Confirm with Delay'),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: () => FlutterWindowClose.closeWindow(),
                      child: const Text('Close Window')),
                ],
              )),
            ),
          ),
        ],
      ),
    );

    if (Platform.isMacOS) {
      return PlatformMenuBar(
        menus: platformMenus,
        child: inner,
      );
    }

    return inner;
  }
}
