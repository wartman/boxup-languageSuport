package boxup.ls.document;

class NodeStream extends AbstractStream<Result<Source>, Chunk<Array<Node>>> {
  public function write(result:Result<Source>) {
    var scanner = new ScannerStream();
    scanner
      .map(new ParserStream())
      .pipe(new WriteStream(forward));
    scanner.write(result);
  }
}
