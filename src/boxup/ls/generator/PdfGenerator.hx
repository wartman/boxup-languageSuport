package boxup.ls.generator;

import boxup.Builtin;
import boxup.cli.Definition;
import pdfkit.PdfDocument;

// @note: note ready yet -- our current API expects generators 
//        to return a string.
//
//        Which is probably a bad idea anyway.
class PdfGenerator implements Generator<PdfGeneratorStream> {
  final definition:Definition;

  public function new(definition) {
    this.definition = definition;
  }
  
  public function generate(nodes:Array<Node>, source:Source):Result<PdfGeneratorStream> {
    var doc = new PdfDocument({
      compress: false,
      size: definition.getMeta('pdf.size', 'LETTER'),
      margins: {
        top: Std.parseInt(definition.getMeta('pdf.marginTop', '30')),
        left: Std.parseInt(definition.getMeta('pdf.marginLeft', '20')),
        bottom: Std.parseInt(definition.getMeta('pdf.marginTop', '30')),
        right: Std.parseInt(definition.getMeta('pdf.marginRight', '20'))
      }
    });
    var buffer = new PdfGeneratorStream();

    doc.pipe(buffer);
    generateNodes(nodes, doc, {});
    doc.end();

    return Ok(buffer);
  }

  function generateNodes(nodes:Array<Node>, doc:PdfDocument, style:PdfTextOptions) {
    for (node in nodes) generateNode(node, doc, style);
  }

  function generateNode(node:Node, doc:PdfDocument, style:PdfTextOptions) {
    switch node.type {
      //@todo: blocks -- handle with pdf.renderHint

      case Paragraph:
        // For now we're ignoring bold/italic/etc
        var text:Array<String> = [];
        for (child in node.children) switch child.type {
          case Text: text.push(child.textContent);
          case Block(BItalic) | Block(BBold):
            for (c in child.children) switch c.type {
              case Text: text.push(c.textContent);
              default: // hm
            }
          default: // hm
        }

        doc
          .font('Default', 12)
          .text(text.join(''), style);

        doc.moveDown();

      case Block(BItalic) | Block(BBold):
        generateNodes(node.children, doc, style);

      case Text:
        doc.text(node.textContent, style);

      default:
        // skip
    }
  }
}
