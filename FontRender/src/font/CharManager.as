package font
{
	import com.adobe.images.PNGEncoder;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	import nochump.util.zip.ZipEntry;
	import nochump.util.zip.ZipOutput;

	public final class CharManager
	{
		public static const kExtXML:int = 0;
		
		public static const kCharOnly:String = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
		public static const kASCII:String = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþ";
		public static const kNEHE:String = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
		
		public var characterSet:String = kCharOnly;
		public var textFormat:TextFormat;
		
		public var fileName:String = "arial";
		
		private var _bitmapChar:Vector.<BitChar>;
		
		public function CharManager()
		{
			textFormat = new TextFormat();
		}
		
		public function set bitmapChar(v:Vector.<BitChar>):void
		{
			if(_bitmapChar != v)
			{
				if(_bitmapChar)
				{
					for each(var c:BitChar in _bitmapChar)c.dispose();
				}
				_bitmapChar = v;
			}
		}
		
		public function get bitmapChar():Vector.<BitChar>
		{
			return _bitmapChar;
		}
		
		public function exportXML(layout:CharLayout):XML
		{
			var base:BitmapFontInfo = new BitmapFontInfo();
			base.fromLayout(layout);
			var ret:XML = base.toXML();
			var chars:XML = new XML("<chars/>");
			chars.@count = _bitmapChar.length;
			for each(var c:BitChar in _bitmapChar)
			{
				chars.appendChild(c.toXML());
			}
			ret.appendChild(chars);
			return ret;
		}
		
		public function exportLayout(src:CharLayout):ByteArray
		{
			var data:BitmapData = new BitmapData(src.width, src.height, true, 0x00000000);
			src.background.visible = false;
			data.draw(src, new Matrix());
			src.background.visible = true;
			var ret:ByteArray = PNGEncoder.encode(data);
			data.dispose();
			return ret;
		}
		
		public function exportZip(layout:CharLayout, type:int = 0):ByteArray
		{
			var string:String = exportXML(layout).toXMLString();
			var byte:ByteArray = new ByteArray();
			byte.writeUTFBytes(string);
			
			var texture:ByteArray = exportLayout(layout);
			
			var zip:ZipOutput = new ZipOutput();
			var stringEntry:ZipEntry = new ZipEntry(CharManager.getInstance().configName);
			zip.putNextEntry(stringEntry);
			zip.write(byte);
			
			var pngEntry:ZipEntry = new ZipEntry(CharManager.getInstance().textureName);
			zip.putNextEntry(pngEntry);
			zip.write(texture);
			
			zip.closeEntry();
			zip.finish();
			
			return zip.byteArray;
		}
		
		public function get textureName():String
		{
			return fileName + ".png";
		}
		
		public function get configName():String
		{
			return fileName + ".fnt"
		}
		
		private static var _instance:CharManager;
		public static function getInstance():CharManager
		{
			if(!_instance)_instance = new CharManager();
			return _instance;
		}
	}
}