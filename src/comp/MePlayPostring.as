package comp
{
	import com.lhd.MeConnect;
	import com.lhd.events.MeConnectEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import response.Person;
	
	[Event(name="play_complete",type="flash.events.Event")]
	
	public class MePlayPostring extends EventDispatcher
	{
		
		private var user_id:String;
		private var play_value:String;
		private var play_msg:String;
		public var play_total_msg:String;
		
		public function MePlayPostring(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function start(_user_id:String):void{
			user_id = _user_id;
			
			getPersonInfo();
		}
		
		private var connect:MeConnect = new MeConnect();
		
		private function getPersonInfo():void{
			connect.addEventListener(MeConnectEvent.GETPERSON_RESULT, person_resultHandler);
			connect.getperson(user_id);
		}
		
		public function destory():void{
			connect = null;
		}
		
		private var person:Person;
		
		private function person_resultHandler(e:MeConnectEvent):void{
			connect.removeEventListener(MeConnectEvent.GETPERSON_RESULT, person_resultHandler);
			person = new Person(e.data);
			
			getSearchValue();
		}
		
		private var http:HTTPService;
		
		private function getSearchValue():void{
			if(http == null){
				http = new HTTPService();
			}
			var nickname:String = person.nickname;
			http.url = "http://me2day.net/search?search_at=all&query="+nickname;
			http.addEventListener(ResultEvent.RESULT, http_resultHandler);
			http.useProxy = false;
			http.resultFormat = "text";
			http.method = "GET";
			http.send();
		}
		
		
		private function http_resultHandler(e:ResultEvent):void{
			http.removeEventListener(ResultEvent.RESULT, http_resultHandler);
			//  <div class="s_feedback"><strong>1</strong>건이 검색되었습니다.</div>
			var value:String = new String(e.result);
			
			value = value.substring(value.lastIndexOf('<div class="s_feedback"><strong>')+32, value.lastIndexOf('</strong>건이 검색되었습니다.</div>'));
			
			value = value.replace(new RegExp(",", "g"), "");
			
			var fri_count:Number = Number(person.friendsCount);
			var search_count:Number = Number(Number(value)/4);
			var pin_count:Number = Number(person.pinMeCount);
			var post_count:Number = Number(person.totalPosts);
			
			var returnValue:Number = Math.floor((((fri_count*4)+search_count+(pin_count*4)+post_count)/6)/4);
			
			play_value = returnValue.toString();
			
			// 평가 하기
			if(returnValue < 70){
				if(fri_count < 100){
					play_msg = "친구를 더 만들어봅시다!";
				}
				else if(post_count < 500){
					play_msg = "포스팅을 더 해보는건 어떨까요?";
				}
				play_msg = "좀 더 활발히 움직여볼까요?!";
			}
			else if(returnValue < 140){
				if(fri_count < 200){
					play_msg = "좀 더 친구를 사겨보는건 어떨까요?";
				}
				else if(post_count < 1000){
					play_msg = "포스팅만 좀 더 하시면 좋을꺼같아요!";
				}
				play_msg = "당신은 미투데이의 미드필드!";
			}
			else{
				if(fri_count < 300){
					play_msg = "당신은 주목받고 있습니다!!";
				}
				else if(post_count < 2000){
					play_msg = "당신은 미투데이의 마당발!!";
				}
				play_msg = "미투데이엔 당신의 글이 가득합니다!!";
			}
			
			play_total_msg = '["활동지수":http://me2day.net/me2/app/view/a38 ] 나의 활동지수 평가! 나의 점수는 '+play_value+'점!! '+play_msg;
			this.dispatchEvent(new Event("play_complete"));
			
			value = null;
		}
	}
}