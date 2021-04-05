package boxup.ls.diagnostic;

import boxup.cli.Context;
import boxup.ls.document.NodeStream;

class DiagnosticStream extends AbstractStream<Chunk<Context>, Chunk<Context>> {
  final reporter:Reporter;
  final reader:Readable<Result<Source>>;

  public function new(reporter, reader) {
    this.reporter = reporter;
    this.reader = reader;
    super();
  }

  public function write(chunk:Chunk<Context>) {
    chunk.result.handleValue(context -> {
      var nodes = new NodeStream();
      
      nodes
        .map(new ValidatorStream(context.definitions))
        .map(new ReporterStream(reporter))
        .pipe(new WriteStream(_ -> forward(chunk)));

      reader.pipe(nodes);
    });
    chunk.result.handleError(error -> {
      reporter.report(error, Source.none());
      forward(chunk);
    });
  }
}
