#include "include/flutter_window_close/flutter_window_close_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <map>
#include <memory>
#include <sstream>

namespace {

using flutter::EncodableMap;
using flutter::EncodableValue;
//
//static std::string
//GetStringArgument(const flutter::MethodCall<>& method_call, const char* key)
//{
//    std::string arg;
//    const auto* arguments = std::get_if<EncodableMap>(method_call.arguments());
//    if (arguments) {
//        auto arg_it = arguments->find(EncodableValue(key));
//        if (arg_it != arguments->end()) {
//            arg = std::get<std::string>(arg_it->second);
//        }
//    }
//    return arg;
//}

static int
GetIntArgument(const flutter::MethodCall<>& method_call, const char* key)
{
    int arg = 0;
    const auto* arguments = std::get_if<EncodableMap>(method_call.arguments());
    if (arguments) {
        auto arg_it = arguments->find(EncodableValue(key));
        if (arg_it != arguments->end()) {
            arg = std::get<int>(arg_it->second);
        }
    }
    return arg;
}

class FlutterWindowClosePlugin : public flutter::Plugin {
public:
    static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);

    FlutterWindowClosePlugin();

    virtual ~FlutterWindowClosePlugin();

private:
    // Called when a method is called on this plugin's channel from Dart.
    void HandleMethodCall(
        const flutter::MethodCall<flutter::EncodableValue>& method_call,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

// static
void FlutterWindowClosePlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows* registrar)
{
    auto channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
        registrar->messenger(), "flutter_window_close",
        &flutter::StandardMethodCodec::GetInstance());

    auto plugin = std::make_unique<FlutterWindowClosePlugin>();

    channel->SetMethodCallHandler(
        [plugin_pointer = plugin.get()](const auto& call, auto result) {
            plugin_pointer->HandleMethodCall(call, std::move(result));
        });

    registrar->AddPlugin(std::move(plugin));
}

FlutterWindowClosePlugin::FlutterWindowClosePlugin() { }

FlutterWindowClosePlugin::~FlutterWindowClosePlugin() { }

void FlutterWindowClosePlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
{
    if (method_call.method_name().compare("exit") == 0) {
        int exitCode = GetIntArgument(method_call, "exit_code");
        PostQuitMessage(exitCode);
        result->Success(flutter::EncodableValue(nullptr));
    } else if (method_call.method_name().compare("exitAnyWay") == 0) {
        int exitCode = GetIntArgument(method_call, "exit_code");
        exit(exitCode);
        // Lines after "exit" will all be dead code.
    } else {
        result->NotImplemented();
    }
}

} // namespace

void FlutterWindowClosePluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar)
{
    FlutterWindowClosePlugin::RegisterWithRegistrar(
        flutter::PluginRegistrarManager::GetInstance()
            ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
