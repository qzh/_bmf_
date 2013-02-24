package font
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.BitmapFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public final class BitmapCharacter extends Sprite
	{
		public var char:BitChar;
		
		private var container:Bitmap;
		
		public function BitmapCharacter(char:BitChar)
		{
			this.char = char;
			
			if(!char.isEmpty)
			{
				container = new Bitmap(char.displayBitmapData, "auto", true);
				this.addChild(container);
			}
			//this.showRect();
		}
		
		public function showRect():void
		{
			if(!char.isEmpty)
			{
				graphics.clear();
				graphics.lineStyle(1,0,0.8);
				graphics.drawRect(0,0,char.width,char.height);	
			}
		}
		
		public function updateFilter(f:Array):void
		{
			if(char.isEmpty)return;
			
			var src:BitmapData = char.bitmap;
			var temp:Array = [];
			for each(var bf:BitmapFilter in f)
			{
				var sour:Rectangle = new Rectangle(0,0,src.width, src.height);
				var rect:Rectangle = src.generateFilterRect(sour, bf);
				var bmd:BitmapData = new BitmapData(rect.width, rect.height, true, 0);
				bmd.applyFilter(src, rect, new Point(), bf);
				src = bmd;
				temp.push(bmd);
			}
			var result:BitmapData = temp.pop();
			for each(var b:BitmapData in temp)
			{
				b.dispose();
			}
			char.filteredBitmap = result;
			container.bitmapData = result;
		}
	}
}