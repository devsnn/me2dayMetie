package request
{
	import request.Request;
	
	import util.AppSetting;
	
	public class RequestAuthToken extends Request
	{
		
		public var token:String;
		
		public function RequestAuthToken(_token:String)
		{
			token = _token;
		}
		
		override public function getMethod():String{
			return "get_full_auth_token.xml?token="+token+"&akey="+AppSetting.APP_KEY;
		}
		
		
		override public function toObject():Object{
			var obj:Object = new Object();
			return obj;
		}
	}
}