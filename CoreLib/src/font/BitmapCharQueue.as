package font
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	public final class BitmapCharQueue extends EventDispatcher
	{
		public var charList:String;
		public var result:Vector.<BitChar>;
		
		private var format:TextFormat;
		
		private var index:int;
		private var timer:Timer;
		
		public function BitmapCharQueue()
		{
			this.timer = new Timer(10);
			this.timer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		public function dispose():void
		{
			if(this.timer)
			{
				this.timer.stop();
				this.timer.removeEventListener(TimerEvent.TIMER, onTimer);
				this.timer = null;
			}
		}
		
		public function stop():void
		{
			this.timer.stop();
			if(this.result)
			{
				for each(var b:BitChar in this.result)
				{
					b.dispose();
				}
			}
			
			this.result = new Vector.<BitChar>();
			this.index = 0;
		}
		
		public function start():void
		{
			this.stop();
			this.charList = CharManager.getInstance().characterSet;
			this.format = CharManager.getInstance().textFormat;
			
			this.timer.start();
			onTimer();
		}
		
		private function onTimer(e:Event = null):void
		{
			var ch:String = charList.charAt(index);
			var bc:BitChar = this.getCharBitmap(ch);
			this.result.push(bc);
			
			this.index++;
			if(this.index >= this.charList.length)
			{
				var evt:Event = new Event(Event.COMPLETE);
				this.dispatchEvent(evt);
				this.timer.stop();
			}
		}
		
		public function getCharBitmap(char:String):BitChar
		{
			var matrix:Matrix = new Matrix();
			var source:TextField = new TextField();
			source.autoSize = TextFieldAutoSize.LEFT;
			source.defaultTextFormat = format;
			source.text = char || "";
			//source.embedFonts = true;
			//source.antiAliasType = AntiAliasType.ADVANCED;
			//source.sharpness = 100;
			//source.thickness = 100;
			
			var ci:Rectangle = source.getCharBoundaries(0);
			
			matrix.tx = -ci.x
			matrix.ty = -ci.y;
			
			var data:BitmapData = new BitmapData(ci.width, ci.height, true, 0x00000000);
			data.draw(source, matrix);
			
			var bounds:Rectangle = data.getColorBoundsRect(0xFFFFFFFF, 0x000000, false);
			
			if(bounds.width > 0 && bounds.height > 0)
			{
				var dst:BitmapData = new BitmapData(bounds.width, bounds.height, true, 0x00000000);
				dst.copyPixels(data, bounds, new Point());
				data.dispose();
			}
			else
			{
				dst = data;
			}
			
			var ret:BitChar = new BitChar(char, dst, bounds, ci);
			return ret;
		}
	}
}