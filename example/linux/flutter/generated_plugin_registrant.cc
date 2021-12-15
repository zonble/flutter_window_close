//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_platform_alert/flutter_platform_alert_plugin.h>
#include <flutter_window_close/flutter_window_close_plugin.h>
#include <menubar/menubar_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) flutter_platform_alert_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FlutterPlatformAlertPlugin");
  flutter_platform_alert_plugin_register_with_registrar(flutter_platform_alert_registrar);
  g_autoptr(FlPluginRegistrar) flutter_window_close_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FlutterWindowClosePlugin");
  flutter_window_close_plugin_register_with_registrar(flutter_window_close_registrar);
  g_autoptr(FlPluginRegistrar) menubar_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "MenubarPlugin");
  menubar_plugin_register_with_registrar(menubar_registrar);
}
