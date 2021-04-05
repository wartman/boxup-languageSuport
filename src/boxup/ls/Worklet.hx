package boxup.ls;

import boxup.cli.ContextStream;
import vscode.ExtensionContext;
import boxup.cli.ConfigStream;
import boxup.cli.resolver.*;
import boxup.cli.generator.*;
import boxup.ls.core.Plugin;
import boxup.ls.loader.WorkspaceBoxConfigLoader;
import boxup.ls.diagnostic.DiagnosticStream;

using Lambda;
using haxe.io.Path;
using boxup.ls.core.Util;

class Worklet implements Plugin {
  final reporter:Reporter;
  final reader:Readable<Result<Source>>;
  final generators = [
    'html' => HtmlGenerator.new,
    'md' => MarkdownGenerator.new,
    // 'pdf' => PdfGenerator.new
  ];

  public function new(reporter, reader) {
    this.reporter = reporter;
    this.reader = reader;
  }

  public function register(context:ExtensionContext) {
    var reset = run();
    Vscode.workspace.onDidChangeTextDocument(change -> {
      if (change.document.isBoxConfig() || change.document.isDefinitionDocument()) {
        reset();
        run();
      }
    });
    // Vscode.workspace.onDidCreateFiles(files -> {
    // });
  }

  function run():()->Void {
    var configLoader = new WorkspaceBoxConfigLoader();
    var config = new ConfigStream([ for (key in generators.keys()) key ]);
    
    config
      .map(new ContextStream([ new FileNameResolver() ]))
      .map(new DiagnosticStream(reporter, reader));

    configLoader.pipe(config);
    configLoader.load();

    return configLoader.close;
  }
}
