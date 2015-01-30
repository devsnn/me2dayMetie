package request
{
	import comp.Request;
	
	import util.AppSetting;
	import util.UserSetting;
	
	public class RequestNoop extends Request
	{
		
		public var ukey:String;
		
		public function RequestNoop(_ukey:String)
		{
			ukey = _ukey;
		}
		
		override public function getMethod():String{
			return "noop?uid="+UserSetting.user_id+"&ukey="+ukey+"&akey="+AppSetting.APP_KEY;
		}
		
		
		override public function toObject():Object{
			var obj:Object = new Object();
			return obj;
		}
	}
}