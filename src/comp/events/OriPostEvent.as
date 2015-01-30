package comp.events
{
	import flash.events.Event;
	
	import response.Post;
	
	public class OriPostEvent extends Event
	{
		
		public static const POSTID_CLICK:String = "postId_click";
		public static const POST_CLOSE:String = "post_close";
		
		public var post:Post;
		
		public function OriPostEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, _post:Post=null)
		{
			super(type, bubbles, cancelable);
			post = _post;
		}
	}
}