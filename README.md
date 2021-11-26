# flutter_window_close

flutter_window_close lets your Flutter app has a chance to confirm if the user
wants to close your app. It works on desktop platforms including Windows, macOS
and Linux.

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
