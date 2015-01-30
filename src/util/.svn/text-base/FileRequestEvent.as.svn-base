package	util
{
	import flash.events.Event;

	public class FileRequestEvent extends Event{
		public static const RESULT:String = "result";
		public static const FAULT:String = "fault";
		
		public var lastResult:Object;
		public var faultMessage:String;
		
		public function FileRequestEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			return new FileRequestEvent(type);
		}		
	}
}