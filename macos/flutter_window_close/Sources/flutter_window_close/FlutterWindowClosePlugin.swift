import Cocoa
import FlutterMacOS

public class FlutterWindowClosePlugin: NSObject, FlutterPlugin, NSWindowDelegate {
    /// The window that contains the view that is registering the plugins.
    private var window: NSWindow?
    /// The method channel to notify the Flutter side.
    private var notificationChannel: FlutterMethodChannel?
    /// If the plugin is initialized.
    private var initialized = false

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "flutter_window_close", binaryMessenger: registrar.messenger)
        let instance = FlutterWindowClosePlugin()
        instance.notificationChannel = FlutterMethodChannel(
            name: "flutter_window_close_notification", binaryMessenger: registrar.messenger)
        instance.window = registrar.view?.window
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

    //MARK: - NSWindow delegate

    public func windowShouldClose(_ sender: NSWindow) -> Bool {
        if initialized == false {
            return true
        }

        notificationChannel?.invokeMethod("onWindowClose", arguments: nil)
        return false
    }
}
