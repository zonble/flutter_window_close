import Cocoa
import FlutterMacOS

public class FlutterWindowClosePlugin: NSObject, FlutterPlugin, NSWindowDelegate {
    var window: NSWindow?
    var notificationChanne: FlutterMethodChannel?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_window_close", binaryMessenger: registrar.messenger)
        let instance = FlutterWindowClosePlugin()
        instance.notificationChanne = FlutterMethodChannel(name: "flutter_window_close_notification", binaryMessenger: registrar.messenger)
        instance.window = NSApp.windows.first
        instance.window?.delegate = instance
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "closeWindow":
            self.window?.performClose(nil)
            result(nil)
        case "destroyWindow":
            self.window?.close()
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    public func windowShouldClose(_ sender: NSWindow) -> Bool {
        notificationChanne?.invokeMethod("onWindowClose", arguments: nil)
        return false
    }
}
