package request
{
	import comp.Request;
	
	import util.AppSetting;
	
	public class RequestStream extends Request
	{
		public function RequestStream()
		{
		}
		
		override public function getMethod():String{
			return "stream.xml?scope=post|friend|mailet|comment&count=20&before=";
		}
		
		
		override public function toObject():Object{
			var obj:Object = new Object();
			return obj;
		}
	}
}