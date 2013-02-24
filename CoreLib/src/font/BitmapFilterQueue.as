package font
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public final class BitmapFilterQueue extends EventDispatcher
	{
		private var charList:Vector.<BitmapCharacter>;
		private var timer:Timer;
		private var filterList:Array;
		
		private var index:int;
		
		public function BitmapFilterQueue()
		{
			timer = new Timer(10);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		public function dispose():void
		{
			if(timer)
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, onTimer);
				timer = null;
			}
		}
		
		public function start(charList:Vector.<BitmapCharacter>, filterList:Array):void
		{
			this.charList = charList;
			this.filterList = filterList;
			if(timer)
			{
				timer.stop();
			}
			
			index = 0;
			timer.start();
			onTimer(null);
		}
		
		private function onTimer(e:Event):void
		{
			var bc:BitmapCharacter = charList[index];
			bc.updateFilter(filterList);
			
			index++;
			if(index >= charList.length)
			{
				this.dispatchEvent(new Event(Event.COMPLETE));
				this.timer.stop();
			}
		}
	}
}