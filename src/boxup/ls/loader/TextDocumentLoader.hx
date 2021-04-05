package boxup.ls.loader;

import vscode.TextDocument;
import vscode.ExtensionContext;
import boxup.cli.Loader;
import boxup.ls.core.Plugin;

using boxup.ls.core.Util;

class TextDocumentLoader 
  extends ReadStream<Result<Source>> 
  implements Loader
  implements Plugin
{
  public function load() {
    // noop?
  }

  public function register(context:ExtensionContext) {
    Vscode.workspace.onDidChangeTextDocument(change -> {
      if (change.document.isBoxupDocument()) send(change.document);
    });
    Vscode.window.onDidChangeActiveTextEditor(change -> {
      if (change.document.isBoxupDocument()) send(change.document);
    });
  }

  function send(doc:TextDocument) {
    var source = new Source(doc.uri.toString(), doc.getText());
    if (isReadable()) onData.emit(Ok(source));
  }
}
