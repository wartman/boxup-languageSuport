package boxup.ls.core;

import vscode.ExtensionContext;

interface Plugin {
  public function register(context:ExtensionContext):Void;
}