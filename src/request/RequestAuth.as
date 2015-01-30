package request
{
	import request.Request;
	
	import util.AppSetting;
	
	public class RequestAuth extends Request
	{
		
		public function RequestAuth()
		{
		}
		
		override public function getMethod():String{
			return "get_auth_url.xml?akey="+AppSetting.APP_KEY;
		}
		
		
		override public function toObject():Object{
			var obj:Object = new Object();
			return obj;
		}
	}
}