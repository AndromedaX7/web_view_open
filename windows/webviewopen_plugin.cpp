// Copyright 2019 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
#include "webviewopen_plugin.h"

// This must be included before VersionHelpers.h.
#include <windows.h>

#include <VersionHelpers.h>
#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <map>
#include <memory>
#include <sstream>

namespace {

// *** Rename this class to match the windows pluginClass in your pubspec.yaml.
class WebviewopenPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  WebviewopenPlugin();

  virtual ~WebviewopenPlugin();

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

// static
void WebviewopenPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  // *** Replace "sample_plugin" with your plugin's channel name in this call.
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "webviewopen",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<WebviewopenPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

WebviewopenPlugin::WebviewopenPlugin() {}

WebviewopenPlugin::~WebviewopenPlugin() {}

void WebviewopenPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  // *** Replace the "getPlatformVersion" check with your plugin's method names.
  // See:
  // https://github.com/flutter/engine/tree/master/shell/platform/common/cpp/client_wrapper/include/flutter
  // and
  // https://github.com/flutter/engine/tree/master/shell/platform/windows/client_wrapper/include/flutter
  // for the relevant Flutter APIs.
    if (method_call.method_name().compare("getPlatformVersion") == 0) {
        std::ostringstream version_stream;
        version_stream << "Windows ";
        // The result returned here will depend on the app manifest of the runner.
        if (IsWindows10OrGreater()) {
            version_stream << "10+";
        }
        else if (IsWindows8OrGreater()) {
            version_stream << "8";
        }
        else if (IsWindows7OrGreater()) {
            version_stream << "7";
        }
        flutter::EncodableValue response(version_stream.str());
        result->Success(&response);
    }else if
    (method_call.method_name().compare("toDetails")== 0 ){
        ShellExecute(NULL, L"open", L"http://www.bilibili.com", NULL, NULL, SW_SHOWNORMAL);
  } else  {
    result->NotImplemented();
  }
}

}  // namespace

void WebviewopenPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  // The plugin registrar wrappers owns the plugins, registered callbacks, etc.,
  // so must remain valid for the life of the application.
  static auto *plugin_registrars =
      new std::map<FlutterDesktopPluginRegistrarRef,
                   std::unique_ptr<flutter::PluginRegistrarWindows>>;
  auto insert_result = plugin_registrars->emplace(
      registrar, std::make_unique<flutter::PluginRegistrarWindows>(registrar));

  WebviewopenPlugin::RegisterWithRegistrar(insert_result.first->second.get());
}
