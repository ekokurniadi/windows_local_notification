//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <screen_retriever/screen_retriever_plugin.h>
#include <window_manager/window_manager_plugin.h>
#include <windows_local_notification/windows_local_notification_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  ScreenRetrieverPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ScreenRetrieverPlugin"));
  WindowManagerPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WindowManagerPlugin"));
  WindowsLocalNotificationPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WindowsLocalNotificationPlugin"));
}
