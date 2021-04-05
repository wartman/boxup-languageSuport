package boxup.ls.core;

import vscode.ExtensionContext;

class PluginCollection implements Plugin {
  final plugins:Array<Plugin> = [];

  public function new() {}

  public function add(plugin:Plugin) {
    plugins.push(plugin);
  }

  public function register(context:ExtensionContext) {
    for (p in plugins) p.register(context);
  }
}
