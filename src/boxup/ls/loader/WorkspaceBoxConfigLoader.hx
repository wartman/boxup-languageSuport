package boxup.ls.loader;

import boxup.cli.Loader;

using boxup.ls.core.Util;

class WorkspaceBoxConfigLoader 
  extends ReadStream<Result<Source>> 
  implements Loader 
{
  public function load() { 
    Vscode.workspace.findFiles('.boxconfig').then(uris -> {
      if (uris.length == 0) {
        if (isReadable()) 
          onData.emit(Fail(new Error('Cound not find a .boxconfig file', Position.unknown())));
        return;
      }
      for (uri in uris) {
        Vscode.workspace.fs.readFile(uri).then(bytes -> {
          // HMM this seems dicy
          var content = [ for (b in bytes) String.fromCharCode(b) ].join('');
          var source = new Source(uri.fsPath, content);
          if (isReadable()) onData.emit(Ok(source));
        });
      }
    }, err -> {
      throw err; // ??
    });
  }
}
