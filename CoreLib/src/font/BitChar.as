package font
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	public final class BitChar
	{
		public var gypthRect:Rectangle;
		public var charRect:Rectangle;
		
		public var bitmap:BitmapData;
		public var filteredBitmap:BitmapData;
		
		public var char:String;
		
		public var textureRect:Rectangle;
		
		public var isEmpty:Boolean;
		
		public function BitChar(char:String, bmd:BitmapData, gypthRect:Rectangle, charRect:Rectangle)
		{
			this.char = char;
			this.bitmap = bmd;
			this.gypthRect = gypthRect;
			this.charRect = charRect;
			this.isEmpty = char == " ";
		}
		
		public function dispose():void
		{
			if(this.bitmap)
			{
				this.bitmap.dispose();
				this.bitmap = null;
			}
			if(filteredBitmap)
			{
				filteredBitmap.dispose();
				filteredBitmap = null;
			}
			this.gypthRect = null;
			this.charRect = null;
		}
		
		public function get width():int
		{
			if(isEmpty)return 0;
			var bmd:BitmapData = filteredBitmap ? filteredBitmap : bitmap;
			return bmd.width;
		}
		
		public function get height():int
		{
			if(isEmpty)return 0;
			var bmd:BitmapData = filteredBitmap ? filteredBitmap : bitmap;
			return bmd.height;
		}
		
		public function get displayBitmapData():BitmapData
		{
			return filteredBitmap ? filteredBitmap : bitmap;
		}
		
		public function toString():String
		{
			return "[" + char + " g=" + gypthRect.toString() + ", c=" + charRect.toString() + " ]";
		}
		
		public function toXML():XML
		{
			//<char id="32" x="0" y="0" width="0" height="0" xoffset="0" yoffset="58" xadvance="18" page="0" chnl="0" letter="space"/>
			var charCode:int = char.charCodeAt();
			var charId:String = charCode + "";
			var letter:String =  char;
			var ret:XML = <char id={charId} x={textureRect.x} y={textureRect.y} width={textureRect.width} height={textureRect.height} xoffset={gypthRect.x} yoffset={gypthRect.y} xadvance={charRect.width} page="0" chnl="0" letter={letter}/>;
			return ret;
		}
	}
}