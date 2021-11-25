import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_window_close/flutter_window_close.dart';

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
    return const MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var _alertShowing = false;

  @override
  void initState() {
    super.initState();

    FlutterWindowClose.setWindowShouldCloseHandler(() async {
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
              ],
            );
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                FlutterWindowClose.closeWindow();
              },
              child: const Text('Close Window')),
        ],
      )),
    );
  }
}
