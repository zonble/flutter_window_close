#include "include/flutter_window_close/flutter_window_close_plugin.h"

#include <Windows.h>

// These headers must be present after |Windows.h|
#include <Commctrl.h>
#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

namespace {

class FlutterWindowClosePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);

  FlutterWindowClosePlugin(flutter::PluginRegistrarWindows* registrar);

  virtual ~FlutterWindowClosePlugin();

  HWND GetWindow();

 private:
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  std::optional<LRESULT> WindowProcDelegate(HWND hwnd, UINT message,
                                            WPARAM wparam, LPARAM lparam);

  flutter::PluginRegistrarWindows* registrar_;
  std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>>
      notification_channel_;
  int64_t window_proc_delegate_id_ = -1;
};

void FlutterWindowClosePlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows* registrar) {
  auto plugin = std::make_unique<FlutterWindowClosePlugin>(registrar);
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "flutter_window_close",
          &flutter::StandardMethodCodec::GetInstance());
  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto& call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });
  registrar->AddPlugin(std::move(plugin));
}

FlutterWindowClosePlugin::FlutterWindowClosePlugin(
    flutter::PluginRegistrarWindows* registrar)
    : registrar_(registrar),
      notification_channel_(std::move(
          std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
              registrar->messenger(), "flutter_window_close_notification",
              &flutter::StandardMethodCodec::GetInstance()))) {
  if (window_proc_delegate_id_ == -1) {
    window_proc_delegate_id_ = registrar_->RegisterTopLevelWindowProcDelegate(
        std::bind(&FlutterWindowClosePlugin::WindowProcDelegate, this,
                  std::placeholders::_1, std::placeholders::_2,
                  std::placeholders::_3, std::placeholders::_4));
  }
}

FlutterWindowClosePlugin::~FlutterWindowClosePlugin() {
  if (window_proc_delegate_id_ != -1) {
    registrar_->UnregisterTopLevelWindowProcDelegate(
        static_cast<int32_t>(window_proc_delegate_id_));
  }
}

HWND FlutterWindowClosePlugin::GetWindow() {
  return ::GetAncestor(registrar_->GetView()->GetNativeWindow(), GA_ROOT);
}

void FlutterWindowClosePlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name().compare("closeWindow") == 0) {
    ::PostMessage(GetWindow(), WM_CLOSE, 0, 0);
    result->Success(flutter::EncodableValue(nullptr));
  } else if (method_call.method_name().compare("destroyWindow") == 0) {
    ::DestroyWindow(GetWindow());
    result->Success(flutter::EncodableValue(nullptr));
  } else {
    result->NotImplemented();
  }
}

std::optional<LRESULT> FlutterWindowClosePlugin::WindowProcDelegate(
    HWND hwnd, UINT message, WPARAM wparam, LPARAM lparam) {
  switch (message) {
    case WM_CLOSE: {
      notification_channel_->InvokeMethod(
          "onWindowClose", std::make_unique<flutter::EncodableValue>(nullptr));
      return 0;
    }
  }
  return std::nullopt;
}

}  // namespace

void FlutterWindowClosePluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  FlutterWindowClosePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
