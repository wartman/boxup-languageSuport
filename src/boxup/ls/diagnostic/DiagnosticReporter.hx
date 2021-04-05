package boxup.ls.diagnostic;

import vscode.Range;
import vscode.Diagnostic;
import vscode.Uri;
import vscode.DiagnosticCollection;
import vscode.ExtensionContext;
import boxup.ls.core.Plugin;

using boxup.ls.core.Util;
using StringTools;

class DiagnosticReporter implements Plugin implements Reporter {
  final collection:DiagnosticCollection;
  
  public function new() {
    collection = Vscode.languages.createDiagnosticCollection('boxup');
  }

  public function register(context:ExtensionContext) {
    context.subscriptions.push(collection);
    Vscode.workspace.onDidChangeTextDocument(change -> {
      if (change.document.isBoxupDocument()) {
        clear(change.document.uri);
      }
    });
    Vscode.workspace.onDidCloseTextDocument(document -> {
      if (document.isBoxupDocument()) {
        remove(document.uri);
      }
    });
  }
  
  public function clear(uri:Uri) {
    collection.set(uri, []);
  }

  public function remove(uri:Uri) {
    collection.delete(uri);
  }

  public function report(errors:ErrorCollection, source:Source) {
    collection.clear();
    var diags:Map<String, Array<Diagnostic>> = [];

    for (error in errors) {
      if (error.pos.file.startsWith('<')) {
        Vscode.window.showErrorMessage(error.toString());
        return;
      }

      var uri = Uri.parse(error.pos.file);
      var path = uri.toString();
      var editor = uri.getEditorByUri();
      
      if (editor == null) return;

      var source = editor.document.getText();
      var pos = error.pos;
      var startLine = 0;
      var endLine = 0;
      var charPos = 0;
      var startChar = 0;
      var endChar = 0;

      while (charPos <= pos.min) {
        charPos++;
        startChar++;
        if (source.charAt(charPos) == '\n') {
          startLine++;
          startChar = -2; // why????
        }
      }

      endLine = startLine;
      endChar = startChar;
      
      while (charPos <= pos.max) {
        charPos++;
        endChar++;
        if (source.charAt(charPos) == '\n') {
          endLine++;
          endChar = 0;
        }
      }

      var range = new Range(startLine, startChar, endLine, endChar);
      var diag = new Diagnostic(range, error.message, Error);

      if (!diags.exists(path)) {
        diags.set(path, []);
      }
      
      diags.get(path).push(diag);
    }

    for (path => ds in diags) {
      collection.set(Uri.parse(path), ds);
    }
  }
}
