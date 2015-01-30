package request
{
	import comp.Request;
	
	public class RequestTodayList extends Request
	{
		
		public var date:String;
		
		public function RequestTodayList()
		{
		}
		
		override public function getMethod():String{
			return "todayList.php";
		}
		
		
		override public function toObject():Object{
			var obj:Object = new Object();
			obj.date = date;
			return obj;
		}
	}
}