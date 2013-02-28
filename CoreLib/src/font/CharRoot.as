package font
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextFormat;
	
	public final class CharRoot extends Sprite
	{
		public var layout:CharLayout;
		public var rootView:DisplayObjectContainer;
		
		private var queue:BitmapCharQueue;
		
		public function CharRoot()
		{
			layout = new CharLayout();
			layout.addEventListener(Event.RESIZE, onLayoutResize);
			this.addChild(layout);
			
			CharManager.getInstance().characterSet = CharManager.kCharOnly;
			CharManager.getInstance().textFormat = new TextFormat("ArialMT", 64, 0xFF0000);
			
			queue = new BitmapCharQueue();
			queue.addEventListener(Event.COMPLETE, onCharQueueComplete);
			
			//test
			//queue.start();
		}
		
		private static var _instance:CharRoot;
		public static function getInstance():CharRoot
		{
			if(!_instance)_instance = new CharRoot();
			return _instance;
		}
		
		public function load():void
		{
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
				layout.removeEventListener(Event.RESIZE, onLayoutResize);
				layout.dispose();
				layout = null;
			}
		}
		
		private function onCharQueueComplete(e:Event):void
		{
			var f:Vector.<BitChar> = this.queue.result;
			CharManager.getInstance().bitmapChar = f;
			
			layout.layout(f, new Point(2,2));
			//layout.addFilter(new BlurFilter()); 
			//layout.addFilter(new DropShadowFilter());
			//layout.updateFilter();
			
		}
		
		private function onLayoutResize(e:Event):void
		{
			if(this.rootView)
			{
				//this.x = (this.rootView.width - this.width)/2;
				//this.y = (this.rootView.height - this.height)/2;
			}
		}
	}
}