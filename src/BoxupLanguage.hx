import boxup.ls.command.Controller;
import boxup.ls.Worklet;
import vscode.ExtensionContext;
import boxup.ls.diagnostic.DiagnosticReporter;
import boxup.ls.loader.TextDocumentLoader;

@:expose('activate')
function activate(context:ExtensionContext) {
  var reporter = new DiagnosticReporter();
  var reader = new TextDocumentLoader();
  var controller = new Controller();
  var worklet = new Worklet(reporter, controller, reader);

  reporter.register(context);
  reader.register(context);
  controller.register(context);
  worklet.register(context);
}

// import capsule.Container;
// import vscode.Uri;
// import vscode.ExtensionContext;
// import boxup.ls.core.PluginCollection;
// import boxup.ls.core.CoreModule;
// import boxup.ls.diagnostic.DiagnosticModule;
// import boxup.ls.definition.DefinitionModule;
// import boxup.ls.document.DocumentModule;

// @:expose('activate')
// function activate(context:ExtensionContext) {
//   var container = new Container();

//   container.use(new CoreModule({
//     extensionUri: Uri.parse(context.extensionUri)
//   }));
//   container.use(DefinitionModule);
//   container.use(DiagnosticModule);
//   container.use(DocumentModule);

//   container.get(PluginCollection).register(context);
// }
