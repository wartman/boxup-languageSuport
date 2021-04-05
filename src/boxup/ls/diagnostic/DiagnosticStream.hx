package boxup.ls.diagnostic;

import boxup.cli.Context;

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
      var scanner = new ScannerStream();

      scanner
        .map(new ParserStream())
        .map(new ValidatorStream(context.definitions))
        .map(new ReporterStream(reporter))
        .pipe(new WriteStream(_ -> forward(chunk)));

      onClose.add(_ -> scanner.end());
      reader.pipe(scanner);
    });
    chunk.result.handleError(error -> {
      reporter.report(error, chunk.source);
      forward(chunk);
    });
  }
}
