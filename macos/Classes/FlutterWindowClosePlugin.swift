import Cocoa
import FlutterMacOS

public class FlutterWindowClosePlugin: NSObject, FlutterPlugin, NSWindowDelegate {
    private var window: NSWindow?
    private var notificationChannel: FlutterMethodChannel?
    private var initialized = false

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_window_close", binaryMessenger: registrar.messenger)
        let instance = FlutterWindowClosePlugin()
        instance.notificationChannel = FlutterMethodChannel(name: "flutter_window_close_notification", binaryMessenger: registrar.messenger)
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
        case "init":
            initialized = true
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    public func windowShouldClose(_ sender: NSWindow) -> Bool {
        if initialized == false {
            return true
        }

        notificationChannel?.invokeMethod("onWindowClose", arguments: nil)
        return false
    }
}
