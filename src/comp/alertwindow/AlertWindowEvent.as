package comp.alertwindow
{
	import flash.events.Event;
	
	public class AlertWindowEvent extends Event
	{
		
		public static const ITEM_INSERT:String = "insertItem";
		
		public static const ADD_STREAM_TYPE:String = "addStream";
		public static const POST_ITEM:String = "postItem";
		public static const COMMENT_ITEM:String = "commentItem";
		
		public var post_type:String;
		public var item_type:String;
		public var item:Object;
		
		public function AlertWindowEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, _post_type:String=null, _item:Object=null, _item_type:String=null)
		{
			super(type, bubbles, cancelable);
			post_type = _post_type;
			item_type = _item_type;
			item = _item;
		}
	}
}