package font
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;

	public final class BitmapFontInfo
	{
		public var face:String;
		public var size:int;
		public var spacing:String;
		public var lineHeight:int;
		public var base:int;
		public var scaleW:int;
		public var scaleH:int;
		
		public var imageName:String;
		
		public function BitmapFontInfo()
		{
		}
		
		public function fromLayout(l:CharLayout):void
		{
			var textFormat:TextFormat = CharManager.getInstance().textFormat;
			
			this.imageName = CharManager.getInstance().textureName;
			
			this.scaleW = l.width;
			this.scaleH = l.height;
			this.face = textFormat.font;
			this.size = int(textFormat.size);
			this.spacing = int(l.padding.x) + "," + int(l.padding.y);
			
			var ht:TextField = new TextField();
			ht.defaultTextFormat = textFormat;
			ht.text = CharManager.kCharOnly;
			ht.autoSize = TextFieldAutoSize.LEFT;
			var lm:TextLineMetrics = ht.getLineMetrics(0);
			this.lineHeight = lm.height;
			this.base = lm.ascent;
		}
		
		public function toXML():XML
		{
			var ret:XML = new XML("<font/>");
			var info:XML = <info face={face} size={size} bold="0" italic="0" chasrset="" unicode="0" stretchH="100" smooth="1" aa="1" padding="0,0,0,0" spacing={spacing}/>
			var common:XML = <common lineHeight={lineHeight} base={base} scaleW={scaleW} scaleH={scaleH} pages="1" packed="0"/>;
			
			var pages:XML = <pages><page id="0" file={imageName}/></pages>
				
			ret.appendChild(info);
			ret.appendChild(common);
			ret.appendChild(pages);
			return ret;
		}
		
	}
}