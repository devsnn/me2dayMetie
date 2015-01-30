package comp.alertwindow
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.Capabilities;
	
	import org.codehaus.stomp.event.MessageEvent;
	
	import response.Comment;
	import response.Person;
	import response.Post;
	
	import util.AppSetting;
	import util.UserSetting;
	import util.messageservice.Me2MessageService;

	public class Messenger extends EventDispatcher
	{
		
		private var itemWindow:MetieMessageWindow;
		
		private static var _instance:Messenger;
		
		public function Messenger()
		{
			
		}
		
		
		public static function get getInstance():Messenger{
			if(_instance == null){
				_instance = new Messenger();
			}
			return _instance;
		}

		public function start():void{
			Me2MessageService.auth(UserSetting.user_id, AppSetting.APP_KEY, UserSetting.full_auth_token);
			Me2MessageService.addEventListener(MessageEvent.MESSAGE, new_messageHandler);
		}
		
		
		public function stop():void{
			Me2MessageService.removeEventListener(MessageEvent.MESSAGE, new_messageHandler);
			Me2MessageService.getMessageService().stop();
		}
		
		private var comment:Comment;
		private var post:Post;
		private var from_person:Person;
		private var to_person:Person;
		
		private var old_friends_post_id:String;
		
		private function new_messageHandler(e:MessageEvent):void{
			//trace(Me2MessageService.lastMessageBodyXML.toXMLString());
			trace("scope:", Me2MessageService.lastMessageHeaders.scope);
			if(Me2MessageService.lastMessageHeaders.scope == null){
				return;
			}
			
			itemWindow = new MetieMessageWindow();
			
			var scope:String = Me2MessageService.lastMessageHeaders.scope;
			
			switch(scope){
				case Me2MessageService.lastMessageHeaders.SCOPE_COMMENT_TO_ME:
					comment = new Comment(Me2MessageService.lastMessageBodyXML.comment);
					comment.post_id = Me2MessageService.lastMessageBodyXML.@post_id;
					comment.postPermalink = Me2MessageService.lastMessageBodyXML.@postPermalink;
					itemWindow.comment = comment;
					dispatchEvent(new AlertWindowEvent(AlertWindowEvent.ITEM_INSERT, true, false, AlertWindowEvent.ADD_STREAM_TYPE, Me2MessageService.lastMessageBodyXML.comment, "comment"));
					break;
				
				case Me2MessageService.lastMessageHeaders.SCOPE_COMMENTS_ON_BY_ME:
					// 다른 사람에게 보내는 코멘트가 옴... 리턴 처리..
					itemWindow = null;
					return;
					
					comment = new Comment(Me2MessageService.lastMessageBodyXML.comment);
					comment.post_id = Me2MessageService.lastMessageBodyXML.@post_id;
					comment.postPermalink = Me2MessageService.lastMessageBodyXML.@postPermalink;
					itemWindow.comment = comment;
					dispatchEvent(new AlertWindowEvent(AlertWindowEvent.ITEM_INSERT, true, false, AlertWindowEvent.ADD_STREAM_TYPE, Me2MessageService.lastMessageBodyXML.comment));
					break;
				
				case Me2MessageService.lastMessageHeaders.SCOPE_FRIENDS_POST:
					post = new Post(Me2MessageService.lastMessageBodyXML);
					// sms 보낼시 중복요청되므로 처리..
					if(old_friends_post_id == post.post_id){
						itemWindow = null;
						return;
					}
					old_friends_post_id = post.post_id;
					itemWindow.post = post;
					dispatchEvent(new AlertWindowEvent(AlertWindowEvent.ITEM_INSERT, true, false, AlertWindowEvent.ADD_STREAM_TYPE, Me2MessageService.lastMessageBodyXML, "post"));
					
					break;
				
				case Me2MessageService.lastMessageHeaders.SCOPE_SMS_FRIENDS_POST:
					post = new Post(Me2MessageService.lastMessageBodyXML);
					if(old_friends_post_id == post.post_id){
						itemWindow = null;
						return;
					}
					old_friends_post_id = post.post_id;
					itemWindow.post = post;
					break;
				
				case Me2MessageService.lastMessageHeaders.SCOPE_METOOED_ME:
					var meTooXML:XMLList = Me2MessageService.lastMessageBodyXML.metoo;
					itemWindow.message(meTooXML[0].author.nickname, meTooXML[0].author.face, UserSetting.user_id+'님의 글에 미투했습니다!');
					break;
				
				case Me2MessageService.lastMessageHeaders.SCOPE_FRIEND_REQUEST_ACCEPTED:
					from_person = new Person(Me2MessageService.lastMessageBodyXML.request.person);
					to_person = new Person(Me2MessageService.lastMessageBodyXML.accept.person);
					
					itemWindow.message(to_person.nickname, to_person.face, to_person.description);
					break;
				
				case Me2MessageService.lastMessageHeaders.SCOPE_FRIEND_REQUEST:
					from_person = new Person(Me2MessageService.lastMessageBodyXML.from.person);
					to_person = new Person(Me2MessageService.lastMessageBodyXML.to.person);
					itemWindow.message(from_person.nickname, from_person.face, to_person.nickname+"님에게 친구를 신청합니다.");
					
					/*var friendWindow:FriendAcceptWindow = new FriendAcceptWindow();
					friendWindow.from_user_id = from_person.user_id;
					friendWindow.labelText = from_person.nickname+"님이 친구신청을 하셨습니다.";
					friendWindow.open();
					friendWindow.width = 300;
					friendWindow.height = 200;
					friendWindow.nativeWindow.x = Capabilities.screenResolutionX-310;
					friendWindow.nativeWindow.y = 10;*/
					break;
				
				case Me2MessageService.lastMessageHeaders.SCOPE_TOKEN_GIFT:
					from_person = new Person(Me2MessageService.lastMessageBodyXML.from.person);
					to_person = new Person(Me2MessageService.lastMessageBodyXML.to.person);
					itemWindow.message(from_person.nickname, from_person.face, to_person.nickname+"님에게 "+Me2MessageService.lastMessageBodyXML.amount+"개의 토큰을 선물합니다.");
					break;
				
				case Me2MessageService.lastMessageHeaders.SCOPE_MOBILE_BUDDY:
					from_person = new Person(Me2MessageService.lastMessageBodyXML.from.person);
					to_person = new Person(Me2MessageService.lastMessageBodyXML.to.person);
					itemWindow.message(from_person.nickname, from_person.face, to_person.nickname+"님에게 "+Me2MessageService.lastMessageBodyXML.message);
					break;
				
				case Me2MessageService.lastMessageHeaders.SCOPE_MENTIONED_USER:
					post = new Post(Me2MessageService.lastMessageBodyXML.post);
					dispatchEvent(new AlertWindowEvent(AlertWindowEvent.ITEM_INSERT, true, false, AlertWindowEvent.ADD_STREAM_TYPE, Me2MessageService.lastMessageBodyXML.post));
					itemWindow.post = post;
					break;
				
				case Me2MessageService.lastMessageHeaders.SCOPE_BAND_POST:
					post = new Post(Me2MessageService.lastMessageBodyXML.post);
					itemWindow.post = post;
					break;
			}
			
			itemWindow.addEventListener("alert_close", close_deactiveHandler);
			
			// open() 이후에 추가및 속성변경이 이뤄져야합니다..
			itemWindow.open(false);
			itemWindow.addSimpleAlert();
			
			// 현재 오픈된 창..
			var window_y:int = (NativeApplication.nativeApplication.openedWindows.length * 100)+10;
			
			itemWindow.nativeWindow.x = Capabilities.screenResolutionX-310;
			itemWindow.nativeWindow.y = Capabilities.screenResolutionY-window_y;
			
			itemWindow.width = 310;
			itemWindow.height = 100;
			
			// 해줘야 최상위로 나옵니다..
			itemWindow.nativeWindow.alwaysInFront = true;
			
		}
		
		
		
		
		private function close_deactiveHandler(e:Event):void{
			var itemWindow:MetieMessageWindow = e.target as MetieMessageWindow;
			itemWindow.close();
			itemWindow.destory();
			itemWindow = null;
		}
		
		
		
	}
}