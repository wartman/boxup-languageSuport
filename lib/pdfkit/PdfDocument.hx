package pdfkit;

import js.lib.Error;
import js.lib.Date;
import js.lib.ArrayBuffer;
import js.lib.Symbol;
import js.node.events.EventEmitter;
import js.node.Buffer;
import js.node.stream.Readable;
import js.node.stream.Writable;
import haxe.extern.EitherType;
import haxe.extern.Rest;
import haxe.Constraints;

typedef PdfDocumentInfo = {
  @:native('Title') public var ?title:String;
  @:native('Author') public var ?author:String;
  @:native('Subject') public var ?subject:String;
  @:native('Keywords') public var ?keywords:String;
  @:native('CreationDate') public var ?creationDate:Date;
  @:native('ModDate') public var ?modDate:Date;
}

enum abstract PdfVersion(String) to String {
  var V13 = '1.3';
  var V14 = '1.4';
  var V15 = '1.5';
  var V16 = '1.6';
  var V17 = '1.7';
  var V17ext3 = '1.7ext3';
}

enum abstract PdfDocumentLayout(String) to String {
  var Portrait = 'portrait'; 
  var Landscape = 'landscape';
}

typedef PdfDocumentPermissions = {
  public var ?modifying:Bool;
  public var ?copying:Bool;
  public var ?annotating:Bool;
  public var ?fillingForms:Bool;
  public var ?contentAccessibility:Bool;
  public var ?documentAssembly:Bool;
  public var ?printing:String;
}

typedef PdfDocumentOptions = {
  public var ?compress:Bool;
  public var ?info:PdfDocumentInfo;
  public var ?userPassword:String;
  public var ?ownerPassword:String;
  public var ?permissions:PdfDocumentPermissions;
  public var ?pdfVersion:PdfVersion;
  public var ?autoFirstPage:Bool;
  public var ?size:EitherType<Array<Int>, String>;
  public var ?margin:Int;
  public var ?margins: { 
    top:Int,
    left:Int,
    bottom:Int,
    right:Int 
  };
  public var ?layout:PdfDocumentLayout;
  public var ?bufferPages:Bool;
}

typedef PdfTextOptions = {
  /**  Set to false to disable line wrapping all together */
  public var ?lineBreak:Bool;
  /** The width that text should be wrapped to (by default, the page width minus the left and right margin) */
  public var ?width:Int;
  /**  The maximum height that text should be clipped to */
  public var ?height:Int;
  /** The character to display at the end of the text when it is too long. Set to true to use the default character. */
  public var ?ellipsis:EitherType<Bool, String>;
  /**  the number of columns to flow the text into */
  public var ?columns:Int;
  /** the amount of space between each column (1/4 inch by default) */
  public var ?columnGap:Int;
  /** The amount in PDF points (72 per inch) to indent each paragraph of text */
  public var ?indent:Int;
  /** the amount of space between each paragraph of text */
  public var ?paragraphGap:Int;
  /** the amount of space between each line of text */
  public var ?lineGap:Int;
  /** the amount of space between each word in the text */
  public var ?wordSpacing:Int;
  /** the amount of space between each character in the text */
  public var ?characterSpacing:Int;
  /** whether to fill the text (true by default) */
  public var ?fill:Bool;
  /**  whether to stroke the text */
  public var ?stroke:Bool;
  /** A URL to link this text to (shortcut to create an annotation) */
  public var ?link:String;
  /** whether to underline the text */
  public var ?underline:Bool;
  /** whether to strike out the text */
  public var ?strike:Bool;
  /** whether the text segment will be followed immediately by another segment. Useful for changing styling in the middle of a paragraph. */
  public var ?continued:Bool;
  /** whether to slant the text (angle in degrees or true) */
  public var ?oblique:EitherType<Bool, Int>;
  /** the alignment of the text (center, justify, left, right) */
  //TODO check this
  // public var ?align: 'center' | 'justify' | 'left' | 'right' | string;
  public var ?align:String;
  /** the vertical alignment of the text with respect to its insertion point */
  // public var ?baseline:Int | 'svg-middle' | 'middle' | 'svg-central' | 'bottom' | 'ideographic' | 'alphabetic' | 'mathematical' | 'hanging' | 'top';
  public var ?baseline:EitherType<Int, String>;
  /** an array of OpenType feature tags to apply. If not provided, a set of defaults is used. */
  // public var ?features: OpenTypeFeatures[];
  public var ?features:Array<String>;
}

typedef PdfFontSource = EitherType<String, EitherType<Buffer, ArrayBuffer>>;

typedef PdfColorValue = EitherType<String, EitherType<PdfGradient, Array<Int>>>; 

typedef PdfGradient =  {
  // public function new(document:Dynamic):Void;
  public function stop(pos:Int, ?color:String, ?opacity:Int):PdfGradient;
  public function embed():Void;
  public function apply():Void;
}

typedef PdfLinearGradient = PdfGradient & {
  // new (document: any, x1:Int, y1:Int, x2:Int, y2:Int): PDFLinearGradient;
  public function shader(fn:()->Dynamic):Dynamic;
  public function opacityGradient():PdfLinearGradient;
}

typedef PdfRadialGradient = PdfGradient & {
  // new (document: any, x1:Int, y1:Int, x2:Int, y2:Int): PDFRadialGradient;
  public function shader(fn:()->Dynamic):Dynamic;
  public function opacityGradient():PdfRadialGradient;
} 

typedef PdfImageOption = {
  public var ?width:Int;
  public var ?height:Int;
  /** Scale percentage */
  public var ?scale:Int;
  /** Two elements array specifying dimensions(w,h)  */
  public var ?fit:Array<Int>;
  public var ?cover:Array<Int>;
  public var ?align:String;
  public var ?valign:String;
  // public var ?link:AnnotationOption;
  // public var ?goTo:AnnotationOption;
  public var ?link:Dynamic;
  public var ?goTo:Dynamic;
  public var ?destination:String;
}

@:jsRequire('pdfkit')
@:native('PDFDocument')
extern class PdfDocument implements IReadable {
  public var version:Int;
  public var compress:Bool;
  public var info:PdfDocumentInfo;
  public var options:PdfDocumentOptions;
  public var page:PdfPage;
  public var x:Int;
  public var y:Int;

  public function new(options:PdfDocumentOptions):Void;
  public function addPage(?options:PdfDocumentOptions):PdfDocument;
  public function bufferedPageRange():{ start:Int, count:Int };
  public function switchToPage(?n:Int):PdfPage;
  public function flushPages():Void;
  public function ref(data:{}):PdfKitReference;
  public function addContent(data:Dynamic):PdfDocument;
  public function output(fn:Dynamic):Void;
  public function end():Void;
  public function toString():String;

  // PDFText:
  public function lineGap(lineGap:Int):PdfDocument;
  public function moveDown(?line:Int):PdfDocument;
  public function moveUp(?line:Int):PdfDocument;
  public overload function text(text:String, ?x:Int, ?y:Int, ?options:PdfTextOptions):PdfDocument;
  public overload function text(text:String, ?options:PdfTextOptions):PdfDocument;
  public function widthOfString(text:String, ?options:PdfTextOptions):Int;
  public function heightOfString(text:String, ?options:PdfTextOptions):Int;
  public overload function list(list: Array<EitherType<String, Dynamic>>, ?x:Int, ?y:Int, ?options:PdfTextOptions):PdfDocument;
  public overload function list(list: Array<EitherType<String, Dynamic>>, ?options:PdfTextOptions):PdfDocument;

  //PDFFont
  public overload function font(buffer:Buffer):PdfDocument;
  public overload function font(src:String, ?family:String, ?size:Int):PdfDocument;
  public function fontSize(size:Int):PdfDocument;
  public function currentLineHeight(?includeGap:Bool):Int;
  public function registerFont(name:String, ?src:PdfFontSource, ?family:String):PdfDocument;

  //PDFColor
  public function fillColor(color:PdfColorValue, ?opacity:Int):PdfDocument;
  public function strokeColor(color:PdfColorValue, ?opacity:Int):PdfDocument;
  public function opacity(opacity:Int):PdfDocument;
  public function fillOpacity(opacity:Int):PdfDocument;
  public function strokeOpacity(opacity:Int):PdfDocument;
  public function linearGradient(x1:Int, y1:Int, x2:Int, y2:Int):PdfLinearGradient;
  public function radialGradient(x1:Int, y1:Int, r1:Int, x2:Int, y2:Int, r2:Int):PdfRadialGradient;

  //PDFImage
  public overload function image(src:Dynamic, ?x:Int, ?y:Int, ?options:PdfImageOption):PdfDocument;
  public overload function image(src:Dynamic, ?options:PdfImageOption):PdfDocument;

  // IReadable
	public function destroy(?error:Error):IReadable;
	public var destroyed(default, null):Bool;
	public function isPaused():Bool;
	public function pause():IReadable;
	public function pipe<T:IWritable>(destination:T, ?options:{?end:Bool}):T;
	public function read(?size:Int):Null<Dynamic>;
	public var readable(default, null):Bool;
	public var readableEncoding(default, null):Null<String>;
	public var readableEnded(default, null):Bool;
	public var readableHighWaterMark(default, null):Int;
	public var readableLength(default, null):Int;
	public var readableObjectMode(default, null):Bool;
	public function resume():IReadable;
	public function setEncoding(encoding:String):IReadable;
	public function unpipe(?destination:IWritable):IReadable;
	public function unshift(chunk:Null<Dynamic>, ?encoding:String):Void;
	public function wrap(stream:Dynamic):IReadable;
  public function addListener<T:Function>(eventName:Event<T>, listener:T):IEventEmitter;
  public function emit<T:Function>(eventName:Event<T>, args:Rest<Dynamic>):Bool;
  public function eventNames():Array<EitherType<String, Symbol>>;
  public function getMaxListeners():Int;
  public function listenerCount<T:Function>(eventName:Event<T>):Int;
  public function listeners<T:Function>(eventName:Event<T>):Array<T>;
  public function off<T:Function>(eventName:Event<T>, listener:T):IEventEmitter;
  public function on<T:Function>(eventName:Event<T>, listener:T):IEventEmitter;
  public function once<T:Function>(eventName:Event<T>, listener:T):IEventEmitter;
  public function prependListener<T:Function>(eventName:Event<T>, listener:T):IEventEmitter;
  public function prependOnceListener<T:Function>(eventName:Event<T>, listener:T):IEventEmitter;
  public function removeAllListeners<T:Function>(?eventName:Event<T>):IEventEmitter;
  public function removeListener<T:Function>(eventName:Event<T>, listener:T):IEventEmitter;
  public function setMaxListeners(n:Int):Void;
  public function rawListeners<T:Function>(eventName:Event<T>):Array<T>;
}

@:jsRequire('pdfkit/js/reference')
@:native('PDFKitReference')
extern class PdfKitReference {
  public var id:Int;
  public var gen:Int;
  public var deflate:Dynamic;
  public var compress:Bool;
  public var uncompressedLength:Int;
  public var chunks:Array<Dynamic>;
  public var data: { ?Font:Dynamic, ?XObject:Dynamic, ?ExtGState:Dynamic, Pattern:Dynamic, Annots:Dynamic };
  public var document:PdfDocument;

  public function new(document:PdfDocument, id:Int, data: {});
  public function initDeflate():Void;
  public function write(chunk:Dynamic):Void;
  public function end(chunk:Dynamic):Void;
  public function finalize():Void;
  public function toString():String;
}

@:jsRequire('pdfkit/js/page')
@:native('PDFPage')
extern class PdfPage {
  public var size:String;
  public var layout:String;
  public var margins: { top:Int, left:Int, bottom:Int, right:Int };
  public var width:Int;
  public var height:Int;
  public var document:PdfDocument;
  public var content:PdfKitReference;
  public var dictionary:PdfKitReference;
  public var fonts:Dynamic;
  public var xobjects:Dynamic;
  public var ext_gstates:Dynamic;
  public var patterns:Dynamic;
  public var annotations:Dynamic;
  public function maxY():Int;
  public function write(chunk:Dynamic):Void;
  public function end():Void;
}
