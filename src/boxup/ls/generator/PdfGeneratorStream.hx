package boxup.ls.generator;

import js.node.Buffer;
import js.lib.Error;
import js.node.stream.Writable;

class PdfGeneratorStream extends Writable<PdfGeneratorStream> {
  var chunks:Array<Buffer>;

  public function new() {
    super({});
    chunks = [];
  }

  override function _write(chunk:Dynamic, encoding:String, callback:Null<Error> -> Void) {
    chunks.push(chunk);
    callback(null);
  }

  public function onComplete(cb:(chunks:Array<Buffer>)->Void) {
    function handle() {
      cb(chunks);
    }
    if (writableFinished) {
      handle();
    } else {
      once('finish', handle);
    }
  }
}
