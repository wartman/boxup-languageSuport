package boxup.ls.command;

import vscode.ExtensionContext;
import boxup.ls.core.Plugin;

class Controller implements Plugin {
  public final onCompile:Signal<Controller> = new Signal();

  public function new() {}

  public function register(context:ExtensionContext) {
    context.subscriptions.push(
      Vscode.commands.registerCommand('box.compile', () -> {
        onCompile.emit(this);
      })
    );
    // Vscode.tasks.registerTaskProvider('box', {

    // });
  }
}