package font
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BitmapFilter;
	import flash.filters.ShaderFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class CharLayout extends Sprite
	{
		public var src:Vector.<BitChar>;
		public var padding:Point;
		
		public var background:Shape;
		
		public var charList:Vector.<BitmapCharacter>;
		public var filterList:Array;
		
		private var filterQueue:BitmapFilterQueue;
		
		public function CharLayout()
		{
			this.filterList = [];
			this.filterQueue = new BitmapFilterQueue();
			this.filterQueue.addEventListener(Event.COMPLETE, onFiltrQueue);
			
			background = new Shape();
			this.addChild(background);
		}
		
		public function dispose():void
		{
			if(filterQueue)
			{
				filterQueue.removeEventListener(Event.COMPLETE, onFiltrQueue);
				filterQueue.dispose();
				filterQueue = null;
			}
		}
		
		public function layout(src:Vector.<BitChar>, padding:Point):void
		{
			this.src = src;
			this.padding = padding;
			this.update();
		}
		
		private function computeAverageSize():Point
		{
			var w:int = 0;
			var h:int = 0;
			for each(var bc:BitChar in src)
			{
				w += bc.width;
				h += bc.height;
			}
			return new Point(w/src.length, h/src.length);
		}
		
		public function update():void
		{
			background.graphics.clear();
			this.removeChildren(0);
			this.addChild(background);
			
			this.charList = new Vector.<BitmapCharacter>(BitmapCharacter);
			
			var averageSize:Point = this.computeAverageSize();
			
			var squreSize:int = Math.sqrt(src.length);
			var computedWidth:int = averageSize.x * squreSize;
			var computedHeight:int = averageSize.y * squreSize;
			
			var currWidth:int = this.getNextPowerOfTwo(computedWidth);
			var currHeight:int = 0;
			
			var cursorX:int = 0;
			var cursorY:int = 0;
			var length:int = src.length;
			var lineHeight:int = 0;
			for(var i:int = 0; i < length; i++)
			{
				var curr:BitChar = src[i];
				var render:BitmapCharacter = new BitmapCharacter(curr);
				this.addChild(render);
				charList.push(render);
				lineHeight = Math.max(lineHeight, render.height);
				
				render.x = cursorX;
				render.y = cursorY;
				render.char.textureRect = new Rectangle(cursorX, cursorY, curr.width, curr.height);
				
				cursorX += curr.width + padding.x;
				if(i+1 < length)
				{
					var next:BitChar = src[i+1];
					if(next.width + padding.x + cursorX > currWidth)
					{
						cursorX = 0;
						cursorY += lineHeight + padding.y;
						lineHeight = 0;
					}
				}
			}
			currHeight = cursorY + lineHeight;
			currHeight = this.getNextPowerOfTwo(currHeight);
			background.graphics.beginFill(0, 0.3);
			background.graphics.drawRect(0,0,currWidth,currHeight);
			background.graphics.endFill();
			trace(currWidth, currHeight);
			
			
			this.dispatchEvent(new Event(Event.RESIZE));
		}
		
		public function getNextPowerOfTwo(number:int):int
		{
			if (number > 0 && (number & (number - 1)) == 0) // see: http://goo.gl/D9kPj
				return number;
			else
			{
				var result:int = 1;
				while (result < number) result <<= 1;
				return result;
			}
		}
		
		public function addFilter(f:BitmapFilter):void
		{
			if(filterList.indexOf(f) == -1)
			{
				filterList.push(f);
			}
		}
		
		public function updateFilter():void
		{
			this.filterQueue.start(this.charList, filterList);
		}
		
		private function onFiltrQueue(e:Event):void
		{
			this.update();
		}
	}
}