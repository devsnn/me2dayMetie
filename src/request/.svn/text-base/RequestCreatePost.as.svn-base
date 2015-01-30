package request
{
	import comp.Request;
	
	import util.AppSetting;
	import util.UserSetting;
	
	public class RequestCreatePost extends Request
	{
		public var post_body:String;
		public var post_tags:String;
		public var post_icon:String;
		
		
		public function RequestCreatePost()
		{
		}
		
		override public function getMethod():String{
			return "create_post/"+UserSetting.user_id+".xml?post[body]="+post_body+"&post[tags]="+post_tags+"&akey="+AppSetting.APP_KEY;
		}
		
		
		override public function toObject():Object{
			var obj:Object = new Object();
			return obj;
		}
	}
}