package request
{
	import flash.net.URLVariables;
	
	import comp.Request;
	
	import util.UserSetting;
	
	public class RequestPosts extends Request
	{
		
		public static const FRIEND_ALL:String = "friendAll";
		
		private var type:String;
		private var count:String;
		
		public function RequestPosts(_type:String="", _count:String="10")
		{
			type = _type;
			count = _count;
		}
		
		override public function getMethod():String{
			return "get_posts/"+UserSetting.user_id+".xml";
		}
		
		
		override public function toObject():Object{
			var obj:URLVariables = new URLVariables();
			
			obj.scope = "friend[all]";
			obj.count = "3";
			return obj;
		}
	}
}