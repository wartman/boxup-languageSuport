package boxup.ls.command;

import boxup.cli.writer.FileWriter;
import boxup.cli.*;

// @todo: just replace this with a vscode.Task
class CommandStream extends AbstractStream<Chunk<Context>, Chunk<Context>> {
  final controller:Controller;
  final reporter:Reporter;
  final generators:Map<String, (definition:Definition)->Generator<String>>;

  public function new(controller, generators, reporter) {
    this.controller = controller;
    this.generators = generators;
    this.reporter = reporter;
    super();
  }
  
  public function write(chunk:Chunk<Context>) {
    var cancel = controller.onCompile.add(_ -> compile(chunk));
    onClose.add(_ -> cancel());
    forward(chunk);
  }

  function compile(chunk:Chunk<Context>) {
    if (!isWritable()) return;

    var tasks = new TaskStream(generators);
    var writer = new FileWriter();

    tasks
      .map(new TaskRunnerStream())
      .map(new ReporterStream(reporter))
      .pipe(writer);

    tasks.write(chunk);
    tasks.end();
  }
}
