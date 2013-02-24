package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.text.TextLineMetrics;
	import flash.utils.ByteArray;
	
	import font.CharManager;
	import font.CharRoot;
	
	[SWF(width="800", height="480", frameRate="60", backgroundColor="#FFFFFF")]
	public class FontRender extends Sprite
	{
		private var charRoot:CharRoot;
		
		public function FontRender()
		{
			this.stage.quality = StageQuality.BEST;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			
			charRoot = new CharRoot();
			this.addChild(charRoot);
			
			this.addEventListener(MouseEvent.CLICK, onClick);
			/*var tf:TextField = new TextField();
			tf.defaultTextFormat = 
			tf.text = "Hello Foxg\nWhy use pig";
			tf.width = 400;
			tf.height = 400;
			this.addChild(tf);
			
			this.getCharBoundaries(tf, 0);
			this.getCharBoundaries(tf, 1);
			this.getCharBoundaries(tf, 2);
			this.getCharBoundaries(tf, 3);
			
			var i:int = tf.getLineIndexOfChar(0);
			trace(tf.getLineText(i));
			
			var lm:TextLineMetrics = tf.getLineMetrics(i);
			formatLine(lm);
			
			var ht:TextField = new TextField();
			ht.defaultTextFormat = new TextFormat("ArialMT", 64, 0xFF00FF);
			ht.text = "H";
			//this.addChild(ht);
			
			trace(ht.textWidth, ht.textHeight);
			var rect:Rectangle = getVisibleBounds(ht);
			trace(rect);*/
		}
		
		private function onClick(e:Event):void
		{
			/*var data:BitmapData = new BitmapData(charRoot.layout.width, charRoot.layout.height, true, 0x00000000);
			data.draw(charRoot.layout, new Matrix());
			var bm:Bitmap = new Bitmap(data);
			this.addChild(bm);
			*/
			var ext:ByteArray = CharManager.getInstance().exportZip(charRoot.layout);
			var file:FileReference = new FileReference();
			file.save(ext, "arial.zip");
		}
		
		public function getCharBoundaries(tf:TextField, i:int):void
		{
			var ci:Rectangle = tf.getCharBoundaries(i);
			trace(ci);
			this.graphics.lineStyle(1);
			this.graphics.drawRect(ci.x, ci.y, ci.width, ci.height);
		}
		
		public function formatLine(lm:TextLineMetrics):void
		{
			var arr:Array = [];
			arr.push("x="+ lm.x);
			arr.push("ascent="+ lm.ascent);
			arr.push("descent="+ lm.descent);
			arr.push("width="+ lm.width);
			arr.push("height="+ lm.height);
			arr.push("leading="+ lm.leading);
			trace(arr.join());
		}
	}
}