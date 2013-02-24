package font
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.text.TextFormat;
	
	public final class CharRoot extends Sprite
	{
		public var layout:CharLayout;
		
		private var queue:BitmapCharQueue;
		
		public function CharRoot()
		{
			layout = new CharLayout();
			this.addChild(layout);
			
			CharManager.getInstance().characterSet = CharManager.kCharOnly;
			CharManager.getInstance().textFormat = new TextFormat("ArialMT", 64, 0xFF0000);
			
			queue = new BitmapCharQueue();
			queue.addEventListener(Event.COMPLETE, onCharQueueComplete);
			
			//test
			queue.start();
		}
		
		public function dispose():void
		{
			if(queue)
			{
				queue.removeEventListener(Event.COMPLETE, onCharQueueComplete);
				queue.dispose();
				queue = null;
			}
			
			if(layout)
			{
				layout.dispose();
				layout = null;
			}
		}
		
		private function onCharQueueComplete(e:Event):void
		{
			var f:Vector.<BitChar> = this.queue.result;
			CharManager.getInstance().bitmapChar = f;
			
			layout.layout(f, new Point(2,2));
			layout.addFilter(new BlurFilter()); 
			layout.addFilter(new DropShadowFilter());
			layout.updateFilter();
		}
	}
}