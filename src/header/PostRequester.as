package header
{
	import com.lhd.MeConnect;
	import com.lhd.events.MeConnectEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class PostRequester extends EventDispatcher
	{
		
		public var resultXMLList:XMLList;
		
		
		public function PostRequester(post_id:String=null, user_id:String=null, permalink:String=null, count:Number=20, isOneItem:Boolean=false)
		{
			var connect:MeConnect = new MeConnect();
			connect.addEventListener(MeConnectEvent.GETPOSTS_RESULT, post_resultHandler);
			if(post_id){
				connect.getposts(MeConnect.POST_ID, count, 0, null, post_id);
			}
			else if(permalink){
				//trace("permalink:", permalink);
				var find_user_id:String = permalink.substring(permalink.indexOf("http://me2day.net/")+18, permalink.indexOf("/20"));
				var time:String = permalink.substring(permalink.indexOf("/20")+1, permalink.length);
				
				var times:Array = time.split("#");
				
				var days:Array;
				var hours:Array;
				if(times && time.length >= 2){
					days = String(times[0]).split("/");
					hours = times[1].split(":");
				}
				
				// from=2010-02-28T00:00:00+0900
				var from:String = "";
				var to:String = "";
				if(days.length >= 3 && isOneItem){
					// 1초 차이를 두어서 하나의 포스트만을 출력합니다...
					from= days[0]+"-"+days[1]+"-"+days[2]+"T"+hours[0]+":"+hours[1]+":"+hours[2]+"+0900";
					to = days[0]+"-"+days[1]+"-"+days[2]+"T"+hours[0]+":"+hours[1]+":"+(int(hours[2])+1).toString()+"+0900";
				}
				
				//trace("from:", from, ", to:", to);
				
				connect.getposts(MeConnect.POST_TOUSER, count, 0, find_user_id, null, from, to);
			}
			else if(user_id){
				connect.getposts(MeConnect.POST_TOUSER, count, 0, find_user_id);
			}
		}
		
		
		private function post_resultHandler(e:MeConnectEvent):void{
			var connect:MeConnect = e.target as MeConnect;
			connect.removeEventListener(MeConnectEvent.GETPOSTS_RESULT, post_resultHandler);
			connect = null;
			
			resultXMLList = new XMLList(e.data.post);
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}