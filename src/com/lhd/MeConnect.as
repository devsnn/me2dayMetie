package com.lhd
{
	import com.lhd.events.MeConnectEvent;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLVariables;
	
	import header.DBConnecter;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import util.AppSetting;
	import util.Base64;
	import util.UserSetting;
	
	/**
	 * 코멘트를 정상적으로 등록하였을때
 	 * @eventType com.lhd.events.Me2dayEvent
 	 */
	[Event(name='createcommentresult', type='com.lhd.events.Me2dayEvent')]
	/**
	 * 포스트를 정상적으로 등록하였을때
 	 * @eventType com.lhd.events.Me2dayEvent
 	 */
	[Event(name='createpostresult', type='com.lhd.events.Me2dayEvent')]
	/**
	 * 코멘트를 정상적으로 삭제하였을때
 	 * @eventType com.lhd.events.Me2dayEvent
 	 */
	[Event(name='deletecommentresult', type='com.lhd.events.Me2dayEvent')]
	/**
	 * 코멘트 정보를 정상적으로 수신하였을때
 	 * @eventType com.lhd.events.Me2dayEvent
 	 */
	[Event(name='getcommentsresult', type='com.lhd.events.Me2dayEvent')]
	/**
	 * 친구 정보를 정상적으로 수신하였을때
 	 * @eventType com.lhd.events.Me2dayEvent
 	 */
	[Event(name='getfriendsresult', type='com.lhd.events.Me2dayEvent')]
	/**
	 * 최근등록 포스트 정보를  정상적으로 수신하였을때
 	 * @eventType com.lhd.events.Me2dayEvent
 	 */
	[Event(name='getlatestsresult', type='com.lhd.events.Me2dayEvent')]
	/**
	 * 미투한 사용자 목록 정보를  정상적으로 수신하였을때
 	 * @eventType com.lhd.events.Me2dayEvent
 	 */
	[Event(name='getmetoosresult', type='com.lhd.events.Me2dayEvent')]
	/**
	 * 미투데이 가입자 정보를 정상적으로 수신하였을때
 	 * @eventType com.lhd.events.Me2dayEvent
 	 */
	[Event(name='getpersonresult', type='com.lhd.events.Me2dayEvent')]
	/**
	 * 포스트 정보를 정상적으로 수신하였을때
 	 * @eventType com.lhd.events.Me2dayEvent
 	 */
	[Event(name='getpostsresult', type='com.lhd.events.Me2dayEvent')]
	/**
	 * 환경설정 정보를 정상적으로 수신하였을때
 	 * @eventType com.lhd.events.Me2dayEvent
 	 */
	[Event(name='getsettingsresult', type='com.lhd.events.Me2dayEvent')]
	/**
	 * 태그목록 정보를 정상적으로 수신하였을때
 	 * @eventType com.lhd.events.Me2dayEvent
 	 */
	[Event(name='gettagsresult', type='com.lhd.events.Me2dayEvent')]
	/**
	 * 정상적으로 미투하였을때
 	 * @eventType com.lhd.events.Me2dayEvent
 	 */
	[Event(name='metooresult', type='com.lhd.events.Me2dayEvent')]
	/**
	 * 서버와의 통신에 성공하였을때
 	 * @eventType com.lhd.events.Me2dayEvent
 	 */
	[Event(name='noopresult', type='com.lhd.events.Me2dayEvent')]
	/**
	 * 코멘트 정보를 정상적으로 수신하였을때
 	 * @eventType com.lhd.events.Me2dayEvent
 	 */
	[Event(name='trackcommentsresult', type='com.lhd.events.Me2dayEvent')]
	/**
	 * 통신상태가 정상적이지 않거나, 에러가 발생하였을때
 	 * @eventType com.lhd.events.Me2dayEvent
 	 */
	[Event(name='onfault', type='com.lhd.events.Me2dayEvent')]
	
	/**
	 * 미투데이 API 라이브러리
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author 이희덕
	 */
	public class MeConnect extends EventDispatcher
	{
		private static const ME2DAY_URL:String = 'http://me2day.net/api/';
		private var createcommentloader:DBConnecter;
		private var createpostloader:DBConnecter;
		private var deletecommentloader:DBConnecter;
		private var getcommentsloader:DBConnecter;
		private var getfriendsloader:DBConnecter;		
		private var getlatestsloader:DBConnecter;
		private var getmetoosloader:DBConnecter;
		private var getpersonloader:DBConnecter;
		private var getpostsloader:DBConnecter;
		private var getsettingsloader:DBConnecter;
		private var gettagsloader:DBConnecter;
		private var metooloader:DBConnecter;
		private var nooploader:DBConnecter;
		private var trackcommentsloader:DBConnecter;
		private var acceptfriendloader:DBConnecter;
		private var authstat:Boolean = true;
		private var _userid:String,_userkey:String;
		private var evt:MeConnectEvent;
		
		/**
		 * Me2day API 객체를 생성한다.
		 */		 
		public function MeConnect()
		{
			
		}
		
		
		public function destory():void{
			createcommentloader = null;
			createpostloader = null;
			deletecommentloader = null;
			getcommentsloader = null;
			getfriendsloader = null;		
			getlatestsloader = null;
			getmetoosloader = null;
			getpersonloader = null;
			getpostsloader = null;
			getsettingsloader = null;
			gettagsloader = null;
			metooloader = null;
			nooploader = null;
			trackcommentsloader = null;
			acceptfriendloader = null;
		}
		
		/**
		 * 사용자의 인증정보를 저장한다
		 * @param userid 사용자 ID
		 * @param userkey APIKEY
		 */
		public function SetAuth(userid:String, userkey:String):void
		{
			_userid = userid;
			_userkey = userkey;
			authstat = true;
		}
		
		
		public function accept_friend(friendship_request_id:String, message:String):void{
			if(!acceptfriendloader){
				acceptfriendloader = new DBConnecter();
				acceptfriendloader.addEventListener(FaultEvent.FAULT, fault_qeuryHandler);
				acceptfriendloader.addEventListener(ResultEvent.RESULT, acceptfri_resultHandler);
			}
			
			if(!authstat){
				evt = new MeConnectEvent(MeConnectEvent.ON_FAULT);
				dispatchEvent(evt);
			}
			else{
				var vars:URLVariables = new URLVariables();
				
				var url:String = ME2DAY_URL+'accept_friendship_request.xml';
				url = ME2DAY_URL+'get_friendship_requests.xml';
				
				trace("id:", friendship_request_id, message);
				
				vars["friendship_request_id"] = friendship_request_id;
				vars["message"] = message;
				vars.akey = AppSetting.APP_KEY;
				
				var ur:URLRequest = new URLRequest(url);
				ur.data = vars;
				ur.method="POST";
				
				acceptfriendloader.queryURLRequest(ur, true);
			}
		}
		
		/**
		 * 코멘트를 등록한다.
		 * @param postid 댓글을 작성할 글 아이디
		 * @param body 댓글본문
		 * @see http://codian.springnote.com/pages/309649
		 */
		public function createcomment(postid:String, body:String):void
		{
			if(createcommentloader == null){
				createcommentloader = new DBConnecter();
				createcommentloader.addEventListener(ResultEvent.RESULT, result_createCommentHandler);
				createcommentloader.addEventListener(IOErrorEvent.IO_ERROR, failedIo);
				createcommentloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, failedSecurity);
			}
			if(!authstat)
			{
				evt = new MeConnectEvent(MeConnectEvent.ON_FAULT);
				dispatchEvent(evt);
			}else{
				var vars:URLVariables = new URLVariables();

				var url:String = ME2DAY_URL+'create_comment.xml';
				
				vars["post_id"] = postid;
				vars["body"] = body;
				vars.akey = AppSetting.APP_KEY;
				
				var ur:URLRequest = new URLRequest(url);
				ur.data = vars;
				ur.method="POST";
				
				createcommentloader.queryURLRequest(ur, true);
			}
		}
		
		/**
		 * 포스트를 작성한다.
		 * @param body 글 본문
		 * @param tags 태그
		 * @param icon 아이콘번호
		 * @param kind 글 종류
		 * @param content_type 컨텐츠 종류		 
		 * @param callback_url 아이콘을 클릭했을때 말풍선으로 표시될 HTML 마크업을 제공하는 URL
		 * @param icon_url 글 아이콘으로 사용할 이미지 URL
		 * @param receive_sms SMS댓글 수신 여부
		 * @param longitude 경도 정보
		 * @param latitude 위도 정보
		 * @see http://codian.springnote.com/pages/164476
		 */
		public function createpost(body:String, tags:String=null, icon:uint=1, kind:uint=1, content_type:String='metie', callback_url:String=null, icon_url:String=null, receive_sms:Boolean=false, longitude:Number=0, latitude:Number=0, attachment:FileReference=null):void
		{
			
			if(createpostloader == null){
				createpostloader = new DBConnecter();
				createpostloader.addEventListener(ResultEvent.RESULT, result_createPostHandler);
				createpostloader.addEventListener(FaultEvent.FAULT, fault_qeuryHandler);
				createpostloader.addEventListener(IOErrorEvent.IO_ERROR, failedIo);
				createpostloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, failedSecurity);
			}
			
			if(!authstat)
			{
				evt = new MeConnectEvent(MeConnectEvent.ON_FAULT);
				dispatchEvent(evt);
			}else{
				var vars:URLVariables = new URLVariables();
				var url:String = ME2DAY_URL+'create_post/'+UserSetting.user_id+'.xml';
				
				var ur:URLRequest = new URLRequest(url);
					
				vars["post[body]"] = body;
				if(tags != null)
					vars["post[tags]"] = tags;
				vars["post[icon]"] = icon;
				//vars["post[kind]"] = kind;
				vars["receive_sms"] = receive_sms;
				if(icon_url != null)
					vars["icon_url"] = icon_url;
					
				if(callback_url != null)
					vars["callback_url"] = callback_url;
					
				vars["content_type"] = content_type;
					
				if(longitude > 0)
					vars["longitude"] = longitude;
					
				if(latitude > 0)
					vars["latitude"] = latitude;
					
				vars.akey = AppSetting.APP_KEY;
				//vars["callback_url"] = callback_url;
				
				if(attachment){
					var user_key:String = UserSetting.full_auth_token;
					var pass:String = "full_auth_token "+user_key;
					
					ur.requestHeaders = [new URLRequestHeader('Authorization',"Basic " + Base64.encode(UserSetting.user_id+":"+pass))]
					ur.contentType = 'application/x-www-form-urlencoded;';
					
					ur.data = vars;
					attachment.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, upload_completeHandler);
					attachment.upload(ur,'attachment');
					return;
				}
				ur.data = vars;
				
				createpostloader.queryURLRequest(ur, true);
			}
		}
		
		
		private function result_createPostHandler(e:ResultEvent):void{
			evt = new MeConnectEvent(MeConnectEvent.CREATEPOST_RESULT);
			evt.data = e.result;
			dispatchEvent(evt);
		}
		
		
		private function upload_completeHandler(e:DataEvent):void{
			evt = new MeConnectEvent(MeConnectEvent.CREATEPOST_RESULT);
			evt.data = e.data;
			dispatchEvent(evt);
		}
		
		
		/**
		 * 코멘트를 삭제한다
		 * @param comment_id 코멘트ID
		 * @see http://codian.springnote.com/pages/1084382
		 */
		public function deletecomment(comment_id:String):void
		{
			/*if(!authstat)
			{
				evt = new MeConnectEvent(MeConnectEvent.ON_FAULT);
				dispatchEvent(evt);
			}else{
				var nonce:String = "ABCDEFGH";
				var pass:String = nonce + MD5.encrypt(nonce + _userkey);
				var url:String = ME2DAY_URL+'delete_comment.xml';
				var ur:URLRequest = new URLRequest(url);
				var vars:URLVariables = new URLVariables();
				vars["uid"] = _userid;
				vars["ukey"] = pass;
				vars["comment_id"] = comment_id;
				ur.data = vars;
				ur.method="POST";
				deletecommentloader.queryURLRequest(ur);
			}*/
		}
		
		/**
		 * 지정한글의 댓글 목록을 가져온다.
		 * @param post_id 포스트ID
		 * @see http://codian.springnote.com/pages/309650
		 */
		public function getcomments(post_id:String):void
		{
			if(!getcommentsloader){
				getcommentsloader = new DBConnecter();
				getcommentsloader.addEventListener(ResultEvent.RESULT, result_getCommnetsHandler);
				getcommentsloader.addEventListener(FaultEvent.FAULT, fault_qeuryHandler);
				getcommentsloader.addEventListener(IOErrorEvent.IO_ERROR, failedIo);
				getcommentsloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, failedSecurity);
			}
			var url:String = ME2DAY_URL+'get_comments.xml?post_id='+post_id;
			var ur:URLRequest = new URLRequest(url);
			ur.method="POST";
			getcommentsloader.queryURLRequest(ur);
		}
		
		/**
		 * 사용자의 친구정보를 가져온다.
		 * @param userid 사용자ID
		 * @param scope 친구그룹
		 * @param user_of 어플리케이션 키
		 * @see http://codian.springnote.com/pages/164488
		 */ 
		public function getfriends(userid:String, scope:String='all', user_of:String=null):void
		{
			if(!getfriendsloader){
				getfriendsloader = new DBConnecter();
				getfriendsloader.addEventListener(Event.COMPLETE, getfriendsHandler);
				getfriendsloader.addEventListener(IOErrorEvent.IO_ERROR, failedIo);
				getfriendsloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, failedSecurity);
			}
			/*var url:String = ME2DAY_URL+'get_friends/'+_userid+'.xml';
			var vars:URLVariables = new URLVariables();
			if(scope.substr(0,5) == 'mytag')
			{
				if(authstat)
				{
					var nonce:String = "ABCDEFGH";
					var pass:String = nonce + MD5.encrypt(nonce + _userkey);
					vars["uid"] = _userid;
					vars["ukey"] = pass;
				}else{
					scope = 'all';
				}
			}
		
			vars["scope"] = scope;
			if(user_of != '')
				vars["user_of"] = user_of;
				
			var ur:URLRequest = new URLRequest(url);
			ur.data = vars;
			ur.method="POST";
			getfriendsloader.queryURLRequest(ur);*/
		}
		
		/**
		 * 사용자의 최근 작성 포스트를 가져온다.
		 * @param userid 사용자ID
		 * @see http://codian.springnote.com/pages/164484
		 */
		public function getlatests(userid:String):void
		{
			var url:String = ME2DAY_URL+'get_latests/'+userid+'.xml';
				
			var ur:URLRequest = new URLRequest(url);			
			getlatestsloader.queryURLRequest(ur);
		}
		
		/**
		 * 지정한 포스트의 미투한 사람의 목록을 가져온다.
		 * @param post_id 포스트ID
		 * @see http://codian.springnote.com/pages/1411386
		 */
		public function getmetoos(post_id:String):void
		{
			if(!getmetoosloader){
				getmetoosloader = new DBConnecter();
				getmetoosloader.addEventListener(ResultEvent.RESULT, result_getMetooHandler);
				getmetoosloader.addEventListener(IOErrorEvent.IO_ERROR, failedIo);
				getmetoosloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, failedSecurity);
			}
			var url:String = ME2DAY_URL+'get_metoos.xml?post_id='+post_id;
			var ur:URLRequest = new URLRequest(url);
			getmetoosloader.queryURLRequest(ur);
		}
		
		/**
		 * 사용자 정보를 가져온다
		 * @param userid 사용자ID
		 * @see http://codian.springnote.com/pages/164485
		 */ 
		public function getperson(userid:String):void
		{
			if(!getpersonloader){
				getpersonloader = new DBConnecter();
				getpersonloader.addEventListener(ResultEvent.RESULT, result_getPsersonHandler);
				getpersonloader.addEventListener(IOErrorEvent.IO_ERROR, failedIo);
				getpersonloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, failedSecurity);
			}
			var url:String = ME2DAY_URL+'get_person/'+userid+'.xml';				
			var ur:URLRequest = new URLRequest(url);
			getpersonloader.queryURLRequest(ur);			
		}
		
		/**
		 * 지정한 사용자의 글 목록을 가져온다
		 * @param userid 사용자ID
		 * @param from 작성일(시작)
		 * @param to 작성일(끝)
		 * $param tag 태그
		 * @see http://codian.springnote.com/pages/386176
		 */
		public static const POST_MY:String = "postMy";
		public static const POST_FRIENDS:String = "postFriends"; 
		public static const POST_MENTIONED:String = "postMentioned";
		public static const POST_BEST:String = "postBest";
		public static const POST_TOUSER:String = "postTouser";
		public static const POST_STREAM:String = "postStream";
		public static const POST_ID:String = "postId";
		
		public function getposts(type:String, count:Number=20, offset:Number=0, toPostUserId:String="", post_id:String="", from:String="", to:String=""):void
		{
			if(!getpostsloader){
				getpostsloader = new DBConnecter();
				getpostsloader.addEventListener(ResultEvent.RESULT, result_getPostsHandler);
				getpostsloader.addEventListener(IOErrorEvent.IO_ERROR, failedIo);
				getpostsloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, failedSecurity);
			}

			var uid:String = UserSetting.user_id;;
			if(type == POST_TOUSER && toPostUserId){
				uid = toPostUserId;
			}
			
			
			var url:String = ME2DAY_URL+'get_posts/'+uid+'.xml';
			var vars:URLVariables = new URLVariables();
			
			switch(type)
			{
				case POST_MY:
					vars.scope = "all";
					break;
				
				case POST_FRIENDS:
					vars.scope = "friend[all]";
					break;
				
				case POST_MENTIONED:
					vars.scope = "mentioned";
					break;
				
				case POST_BEST:
					vars.scope = "friend[best]";
					break;
				
				case POST_TOUSER:
					vars.scope = "all";
					break;
				
				case POST_STREAM:
					url = ME2DAY_URL+"stream.xml?scope=post|friend|mailet|comment&before=";
					break;
				case POST_ID:
					url = ME2DAY_URL+"get_posts.xml?post_id="+post_id;
					break;
			}
			
			if(from){
				vars.from = from;
			}
			if(to){
				vars.to = to;
			}
			
			vars.count = count.toString();
			vars.offset = offset.toString();
			
			trace("count:", count, " offset:", offset);
			vars.akey = AppSetting.APP_KEY;
			
			
			var ur:URLRequest = new URLRequest(url);
			ur.data = vars;
			ur.method="POST";
			
			
			getpostsloader.queryURLRequest(ur, true);
		}
		
		
		/**
		 * 사용자 설정을 가져온다
		 * @see http://codian.springnote.com/pages/317321
		 */
		public function getsettings():void
		{
			if(!getsettingsloader){
				getsettingsloader = new DBConnecter();
				getsettingsloader.addEventListener(Event.COMPLETE, getsettingsHandler);
				getsettingsloader.addEventListener(IOErrorEvent.IO_ERROR, failedIo);
				getsettingsloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, failedSecurity);
			}
			/*if(!authstat)
			{
				evt = new MeConnectEvent(MeConnectEvent.ON_FAULT);
				dispatchEvent(evt);
			}else{
				var nonce:String = "ABCDEFGH";
				var pass:String = nonce + MD5.encrypt(nonce + _userkey);
				var url:String = ME2DAY_URL+'get_settings.xml';				
				var ur:URLRequest = new URLRequest(url);
				var vars:URLVariables = new URLVariables();
				vars["uid"] = _userid;
				vars["ukey"] = pass;
				ur.data = vars;
				ur.method="POST";
				getsettingsloader.queryURLRequest(ur);
			}*/
		}
		
		/**
		 * 사용자가 사용한 태그정보를 가져온다.
		 * @param userid 사용자ID
		 * @param count 가져올 태그 개수
		 * @see http://codian.springnote.com/pages/408599
		 */
		public function gettags(userid:String, count:uint):void
		{
			if(!gettagsloader){
				gettagsloader = new DBConnecter();
				gettagsloader.addEventListener(ResultEvent.RESULT, result_getTagsHandler);
				//gettagsloader.addEventListener(Event.COMPLETE, gettagsHandler);
				gettagsloader.addEventListener(IOErrorEvent.IO_ERROR, failedIo);
				gettagsloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, failedSecurity);
			}
			var url:String = ME2DAY_URL+'get_tags.xml?user_id='+userid+'&count='+count;										
			var ur:URLRequest = new URLRequest(url);
			gettagsloader.queryURLRequest(ur);
		}
		
		/**
		 * 지정한 글에 미투한다.
		 * @post_id 포스트ID
		 * @see http://codian.springnote.com/pages/1411388
		 */
		public function metoo(post_id:String):void
		{
			if(!metooloader){
				metooloader = new DBConnecter();
				metooloader.addEventListener(FaultEvent.FAULT, fault_metooHandler);
				metooloader.addEventListener(ResultEvent.RESULT, result_metooHandler);
				//metooloader.addEventListener(Event.COMPLETE, metooHandler);
				metooloader.addEventListener(IOErrorEvent.IO_ERROR, failedIo);
				metooloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, failedSecurity);
			}
			
			if(!authstat)
			{
				evt = new MeConnectEvent(MeConnectEvent.ON_FAULT);
				dispatchEvent(evt);
			}else{
				var url:String = ME2DAY_URL+'metoo.xml?post_id='+post_id;
				var ur:URLRequest = new URLRequest(url);
				var vars:URLVariables = new URLVariables();
				vars.akey = AppSetting.APP_KEY;
				ur.data = vars;
				ur.method="POST";				
				metooloader.queryURLRequest(ur, true);			
			}			
		}
		
		/**
		 * 서버와 교신한다
		 * @see http://codian.springnote.com/pages/309651
		 */
		public function noop():void
		{
			if(!nooploader){
				nooploader = new DBConnecter();
				nooploader.addEventListener(FaultEvent.FAULT, noop_faultHandler);
				nooploader.addEventListener(ResultEvent.RESULT, noop_resultHandler);
				nooploader.addEventListener(IOErrorEvent.IO_ERROR, failedIo);
				nooploader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, failedSecurity);
			}
			
			var url:String = ME2DAY_URL+'noop.xml';			
					
			/*var nonce:String = "ABCDEFGH";
			var pass:String = nonce + MD5.encrypt(nonce + UserSetting.full_auth_token);
			url += '?uid='+UserSetting.user_id+'&ukey='+pass;				
				
			var ur:URLRequest = new URLRequest(url);*/			
			
			var vars:URLVariables = new URLVariables();
			vars.akey = AppSetting.APP_KEY;
			
			var ur:URLRequest = new URLRequest(url);
			ur.data = vars;
			ur.method="POST";
			
			nooploader.queryURLRequest(ur, true);
		}
		
		/**
		 * 사용자가 주고받은 코멘트 정보를 가져온다.
		 * @param userid 사용자ID
		 * @see http://codian.springnote.com/pages/404723
		 */
		public function trackcomments(userid:String, scope:String="to_me", count:Number=20):void
		{
			if(!trackcommentsloader){
				trackcommentsloader = new DBConnecter();
				trackcommentsloader.addEventListener(ResultEvent.RESULT, result_trackcommnetsHandler);
				trackcommentsloader.addEventListener(FaultEvent.FAULT, fault_qeuryHandler);
				trackcommentsloader.addEventListener(IOErrorEvent.IO_ERROR, failedIo);
				trackcommentsloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, failedSecurity);
			}
			
			var url:String = 'http://me2day.net/api/track_comments/'+userid+'.xml';
			
			var vars:URLVariables = new URLVariables();
			
			vars.scope = scope;
			vars.count = count.toString();
			var ur:URLRequest = new URLRequest(url);
			ur.data = vars;
			ur.method="POST";
			
			trackcommentsloader.queryURLRequest(ur);
		}
		
		private function failedIo(e:IOErrorEvent=null):void{
			evt = new MeConnectEvent(MeConnectEvent.ON_FAULT);
			dispatchEvent(evt);
		}
		private function failedSecurity(e:SecurityErrorEvent=null):void{
			evt = new MeConnectEvent(MeConnectEvent.ON_FAULT);
			dispatchEvent(evt);
		}
		
		
		private function result_createCommentHandler(e:ResultEvent):void{
			evt = new MeConnectEvent(MeConnectEvent.CREATECOMMENT_RESULT);
			evt.data = e.result;
			dispatchEvent(evt);
		}
		
		
		private function createcommentHandler(event:Event):void
		{
			var xml:XML = new XML(event.target.data);
			
			if(xml.code == 0)
			{
				evt = new MeConnectEvent(MeConnectEvent.CREATECOMMENT_RESULT);
				dispatchEvent(evt);	
			}else{
				evt = new MeConnectEvent(MeConnectEvent.ON_FAULT);
				evt.code = xml.code.toString();
				evt.description = xml.description.toString();
				evt.message = xml.message.toString();
				dispatchEvent(evt);
			}
		}
		
		
		private function createpostHandler(event:Event):void
		{
			var xml:XML = new XML(event.target.data);
			
			if(xml.code.toString() != "")
			{
				evt = new MeConnectEvent(MeConnectEvent.ON_FAULT);
				evt.code = xml.code.toString();
				evt.description = xml.description.toString();
				evt.message = xml.message.toString();
				dispatchEvent(evt);
			}else{
				var obj:Object = new Object();
				obj["permalink"] = xml.permalink.toString();
				obj["body"] = xml.body.toString();
				obj["kind"] = xml.kind.toString();
				obj["icon"] = xml.icon.toString();
				var i:uint = 0;
				var temparr:Array = new Array();
				for(i=0; i<xml.tags.tag.length(); i++)
				{
					var tempobj:Object = new Object();
					tempobj["name"]	= xml.tags.tag[i].name.toString();
					tempobj["url"] = xml.tags.tag[i].url.toString();
					temparr.push(tempobj);								
				}
				obj["tags"] = temparr;
				obj["me2dayPage"] = xml.me2dayPage.toString();
				obj["pubDate"] = xml.pubDate.toString();
				obj["commentsCount"] = xml.commentsCount.toString();
				obj["metooCount"] = xml.metooCount.toString();
				var obj2:Object = new Object();
				obj2["id"] = xml.author.id.toString();
				obj2["nickname"] = xml.author.nickname.toString();
				obj2["face"] = xml.author.face.toString();
				obj2["homepage"] = xml.author.homepage.toString();
				obj2["me2dayHome"] = xml.author.me2dayHome.toString();
				obj["author"] = obj2;
				obj2 = new Object();
				obj2["longitude"] = xml.location.longitude.toString();
				obj2["latitiude"] = xml.location.latitiude.toString();
				obj["location"] = obj2;	
				evt = new MeConnectEvent(MeConnectEvent.CREATEPOST_RESULT);
				evt.data = obj;
				dispatchEvent(evt);	
			}
		}
		
		
		private function deletecommentHandler(event:Event):void
		{
			var xml:XML = new XML(event.target.data);
		
			if(xml.code == 0)
			{
				evt = new MeConnectEvent(MeConnectEvent.DELETECOMMENT_RESULT);
				dispatchEvent(evt);	
			}else{
				evt = new MeConnectEvent(MeConnectEvent.ON_FAULT);
				evt.code = xml.code.toString();
				evt.description = xml.description.toString();
				evt.message = xml.message.toString();
				dispatchEvent(evt);
			}	
		}
		
		
		private function result_getCommnetsHandler(e:ResultEvent):void{
			evt = new MeConnectEvent(MeConnectEvent.GETCOMMENTS_RESULT);
			evt.data = e.result;
			dispatchEvent(evt);
		}
		
		private function getcommentsHandler(event:Event):void
		{
			var xml:XML = new XML(event.target.data);
			
			if(xml.code.toString() != "")
			{
				evt = new MeConnectEvent(MeConnectEvent.ON_FAULT);
				evt.code = xml.code.toString();
				evt.description = xml.description.toString();
				evt.message = xml.message.toString();
				dispatchEvent(evt);
			}else{
				var arr:Array = new Array();
				var i:uint = 0;
				evt = new MeConnectEvent(MeConnectEvent.GETCOMMENTS_RESULT);
				var tmpobj:Object,tmpobj2:Object;
				for(i=0; i<xml.comment.length(); i++)
				{
					tmpobj = new Object();
					tmpobj2 = new Object();
					tmpobj["commentId"] = xml.comment[i].commentId.toString(); 					
					tmpobj["body"] = xml.comment[i].body.toString();
					tmpobj["pubDate"] = xml.comment[i].pubDate.toString();
					tmpobj2["id"] = xml.comment[i].author.id.toString();
					tmpobj2["nickname"] = xml.comment[i].author.nickname.toString();
					tmpobj2["face"] = xml.comment[i].author.face.toString();
					tmpobj2["me2dayHome"] = xml.comment[i].author.me2dayHome.toString();
					tmpobj["author"] = tmpobj2;
					arr.push(tmpobj);
				}
				
				evt.data = arr;
				dispatchEvent(evt);
			}
		}
		
		private function getfriendsHandler(event:Event):void
		{
			var xml:XML = new XML(event.target.data);
			
			if(xml.code.toString() != "")
			{
				evt = new MeConnectEvent(MeConnectEvent.ON_FAULT);
				evt.code = xml.code.toString();
				evt.description = xml.description.toString();
				evt.message = xml.message.toString();
				dispatchEvent(evt);
			}else{
				var arr:Array = new Array();
				var i:uint = 0;
				evt = new MeConnectEvent(MeConnectEvent.GETFRIENDS_RESULT);
				var tmpobj:Object;
				for(i=0; i<xml.person.length(); i++)
				{
					tmpobj = new Object();
					tmpobj["id"] = xml.person[i].id.toString(); 					
					tmpobj["openid"] = xml.person[i].openid.toString();
					tmpobj["nickname"] = xml.person[i].nickname.toString();
					tmpobj["face"] = xml.person[i].face.toString();					
					tmpobj["description"] = xml.person[i].description.toString();
					tmpobj["homepage"] = xml.person[i].homepage.toString();
					tmpobj["me2dayHome"] = xml.person[i].me2dayHome.toString();
					tmpobj["rssDaily"] = xml.person[i].rssDaily.toString();
					tmpobj["invitedBy"] = xml.person[i].invitedBy.toString();
					tmpobj["friendsCount"] = xml.person[i].friendsCount.toString();
					tmpobj["updated"] = xml.person[i].updated.toString();
					arr.push(tmpobj);
				}
				
				evt.data = arr;
				dispatchEvent(evt);
			}	
		}
		
		
		
		private function result_getLatestsHandler(e:ResultEvent):void{
			evt = new MeConnectEvent(MeConnectEvent.GETLATESTS_RESULT);
			evt.data = e.result;
			dispatchEvent(evt);
		}
		
		
		
		private function getlatestsHandler(event:Event):void
		{
			var xml:XML = new XML(event.target.data);
			
			if(xml.code.toString() != "")
			{
				evt = new MeConnectEvent(MeConnectEvent.ON_FAULT);
				evt.code = xml.code.toString();
				evt.description = xml.description.toString();
				evt.message = xml.message.toString();
				dispatchEvent(evt);
			}else{
				var arr:Array,arr2:Array;
				var i:uint,j:uint = 0;
				evt = new MeConnectEvent(MeConnectEvent.GETLATESTS_RESULT);
				var tmpobj:Object,tmpobj2:Object;
				arr = new Array();
				for(i=0; i<xml.post.length(); i++)
				{
					tmpobj = new Object();
					tmpobj["post_id"] = xml.post[i].post_id.toString(); 					
					tmpobj["permalink"] = xml.post[i].permalink.toString();
					tmpobj["body"] = xml.post[i].body.toString();
					tmpobj["kind"] = xml.post[i].kind.toString();
					tmpobj["icon"] = xml.post[i].icon.toString();
					arr2 = new Array();
					for(j=0; j<xml.post[i].tags.tag.length(); j++)
					{
						var obj2:Object = new Object();
						obj2["name"] = xml.post[i].tags.tag[j].name.toString();
						obj2["url"] = xml.post[i].tags.tag[j].url.toString();
						arr2.push(obj2);
					}
					tmpobj["tags"] = arr2;
					tmpobj["me2dayPage"] = xml.post[i].me2dayPage.toString();
					tmpobj["pubDate"] = xml.post[i].pubDate.toString();
					tmpobj["commentsCount"] = xml.post[i].commentsCount.toString();
					tmpobj["metooCount"] = xml.post[i].metooCount.toString();
					tmpobj["contentType"] = xml.post[i].contentType.toString();
					tmpobj["iconUrl"] = xml.post[i].iconUrl.toString();
					tmpobj["callbackUrl"] = xml.post[i].callbackUrl.toString();
					tmpobj2 = new Object();
					tmpobj2["id"] = xml.post[i].author.id.toString();
					tmpobj2["nickname"] = xml.post[i].author.nickname.toString();
					tmpobj2["face"] = xml.post[i].author.face.toString();
					tmpobj2["homepage"] = xml.post[i].author.homepage.toString();
					tmpobj2["me2dayHome"] = xml.post[i].author.me2dayHome.toString();
					tmpobj["author"] = tmpobj2;
					tmpobj2 = new Object();
					tmpobj2["name"] = xml.post[i].location.name.toString();
					tmpobj2["longitude"] = xml.post[i].location.longitude.toString();
					tmpobj2["latitude"] = xml.post[i].location.latitude.toString();
					tmpobj["location"] = tmpobj2;
					tmpobj["media"] = xml.post[i].media.toString();
					arr.push(tmpobj);
				}
				
				evt.data = arr;
				dispatchEvent(evt);
			}
		}
		
		
		private function fault_qeuryHandler(e:FaultEvent):void{
			evt = new MeConnectEvent(MeConnectEvent.ON_FAULT);
			evt.data = e.message.body;
			dispatchEvent(evt);
		}
		
		
		private function fault_metooHandler(e:FaultEvent):void{
			evt = new MeConnectEvent(MeConnectEvent.ON_FAULT);
			evt.data = e.message.body;
			dispatchEvent(evt);
		}
		
		private function result_metooHandler(e:ResultEvent):void{
			evt = new MeConnectEvent(MeConnectEvent.METOO_RESULT);
			evt.data = e.result.body;
			dispatchEvent(evt);
		}
		
		private function result_getMetooHandler(e:ResultEvent):void{
			evt = new MeConnectEvent(MeConnectEvent.GETMETOOS_RESULT);
			evt.data = e.result;
			dispatchEvent(evt);
		}
		
		private function getmetoosHandler(event:Event):void
		{
			var xml:XML = new XML(event.target.data);
			
			if(xml.code.toString() != "")
			{
				evt = new MeConnectEvent(MeConnectEvent.ON_FAULT);
				evt.code = xml.code.toString();
				evt.description = xml.description.toString();
				evt.message = xml.message.toString();
				dispatchEvent(evt);
			}else{
				var arr:Array;
				var i:uint,j:uint = 0;
				evt = new MeConnectEvent(MeConnectEvent.GETMETOOS_RESULT);
				var tmpobj:Object,tmpobj2:Object;
				arr = new Array();
				for(i=0; i<xml.metoo.length(); i++)
				{
					tmpobj = new Object();
					tmpobj["pubDate"] = xml.metoo[i].pubDate.toString();
					tmpobj2 = new Object();
					tmpobj2["id"] = xml.metoo[i].author.id.toString();
					tmpobj2["nickname"] = xml.metoo[i].author.nickname.toString();
					tmpobj2["face"] = xml.metoo[i].author.face.toString();
					tmpobj2["homepage"] = xml.metoo[i].author.homepage.toString();
					tmpobj2["me2dayHome"] = xml.metoo[i].author.me2dayHome.toString();
					tmpobj["author"] = tmpobj2;
					arr.push(tmpobj);
				}
				
				evt.data = arr;
				dispatchEvent(evt);
			}
		}
		
		
		private function result_getPsersonHandler(e:ResultEvent):void{
			evt = new MeConnectEvent(MeConnectEvent.GETPERSON_RESULT);
			evt.data = e.result;
			dispatchEvent(evt);
		}
		
		
		
		private function getpersonHandler(event:Event):void
		{
			var xml:XML = new XML(event.target.data);
			
			if(xml.code.toString() != "")
			{
				evt = new MeConnectEvent(MeConnectEvent.ON_FAULT);
				evt.code = xml.code.toString();
				evt.description = xml.description.toString();
				evt.message = xml.message.toString();
				dispatchEvent(evt);
			}else{
				var arr:Array;
				var i:uint,j:uint = 0;
				evt = new MeConnectEvent(MeConnectEvent.GETPERSON_RESULT);
				var tmpobj:Object,tmpobj2:Object;
				arr = new Array();		
				tmpobj = new Object();
				tmpobj["id"] = xml.id.toString();
				tmpobj["openid"] = xml.openid.toString();
				tmpobj["nickname"] = xml.nickname.toString();
				tmpobj["face"] = xml.face.toString();
				tmpobj["description"] = xml.description.toString();
				tmpobj["homepage"] = xml.homepage.toString();
				tmpobj["email"] = xml.email.toString();
				tmpobj["cellphone"] = xml.cellphone.toString();
				tmpobj["messenger"] = xml.messenger.toString();
				tmpobj["rssDaily"] = xml.rssDaily.toString();
				tmpobj["invitedBy"] = xml.invitedBy.toString();
				tmpobj["friendsCount"] = xml.friendsCount.toString();
				tmpobj["updated"] = xml.updated.toString();
				for(j=0; j<xml.postIcons.postIcon.length(); j++)
				{
					tmpobj2 = new Object();
					tmpobj2["iconIndex"] = xml.postIcons.postIcon[j].iconIndex.toString();
					tmpobj2["iconType"] = xml.postIcons.postIcon[j].iconType.toString();
					tmpobj2["url"] = xml.postIcons.postIcon[j].url.toString();
					tmpobj2["description"] = xml.postIcons.postIcon[j].description.toString();
					tmpobj2["default"] = xml.postIcons.postIcon[j].default.toString();
					arr.push(tmpobj2)
				}
				tmpobj["postIcons"] = arr;
				tmpobj["flickr"] = xml.flickr.nsid.toString();
				
				evt.data = tmpobj;
				dispatchEvent(evt);
			}	
		}
		
		
		private function fault_getPostsHandler(e:FaultEvent):void{
		}
		
		
		private function result_getPostsHandler(e:ResultEvent):void{
			evt = new MeConnectEvent(MeConnectEvent.GETPOSTS_RESULT);
			evt.data = e.result;
			dispatchEvent(evt);
		}
		
		
		
		private function acceptfri_resultHandler(e:ResultEvent):void{
			evt = new MeConnectEvent(MeConnectEvent.ACCEPT_FRIEND);
			evt.data = e.result;
			dispatchEvent(evt);
		}
		
		
		
		private function getpostsHandler(event:Event):void
		{
			var xml:XML = new XML(event.target.data);
			
			if(xml.code.toString() != "")
			{
				evt = new MeConnectEvent(MeConnectEvent.ON_FAULT);
				evt.code = xml.code.toString();
				evt.description = xml.description.toString();
				evt.message = xml.message.toString();
				dispatchEvent(evt);
			}else{
				var arr:Array,arr2:Array;
				var i:uint,j:uint = 0;
				evt = new MeConnectEvent(MeConnectEvent.GETPOSTS_RESULT);
				var tmpobj:Object,tmpobj2:Object;
				arr = new Array();
				for(i=0; i<xml.post.length(); i++)
				{
					tmpobj = new Object();
					tmpobj["post_id"] = xml.post[i].post_id.toString(); 					
					tmpobj["permalink"] = xml.post[i].permalink.toString();
					tmpobj["body"] = xml.post[i].body.toString();
					tmpobj["kind"] = xml.post[i].kind.toString();
					tmpobj["icon"] = xml.post[i].icon.toString();
					arr2 = new Array();
					for(j=0; j<xml.post[i].tags.tag.length(); j++)
					{
						var obj2:Object = new Object();
						obj2["name"] = xml.post[i].tags.tag[j].name.toString();
						obj2["url"] = xml.post[i].tags.tag[j].url.toString();
						arr2.push(obj2);
					}
					tmpobj["tags"] = arr2;
					tmpobj["me2dayPage"] = xml.post[i].me2dayPage.toString();
					tmpobj["pubDate"] = xml.post[i].pubDate.toString();
					tmpobj["commentsCount"] = xml.post[i].commentsCount.toString();
					tmpobj["metooCount"] = xml.post[i].metooCount.toString();
					tmpobj["contentType"] = xml.post[i].contentType.toString();
					tmpobj["iconUrl"] = xml.post[i].iconUrl.toString();
					tmpobj["callbackUrl"] = xml.post[i].callbackUrl.toString();
					tmpobj2 = new Object();
					tmpobj2["id"] = xml.post[i].author.id.toString();
					tmpobj2["nickname"] = xml.post[i].author.nickname.toString();
					tmpobj2["face"] = xml.post[i].author.face.toString();
					tmpobj2["homepage"] = xml.post[i].author.homepage.toString();
					tmpobj2["me2dayHome"] = xml.post[i].author.me2dayHome.toString();
					tmpobj["author"] = tmpobj2;
					tmpobj2 = new Object();
					tmpobj2["name"] = xml.post[i].location.name.toString();
					tmpobj2["longitude"] = xml.post[i].location.longitude.toString();
					tmpobj2["latitude"] = xml.post[i].location.latitude.toString();
					tmpobj["location"] = tmpobj2;
					tmpobj["media"] = xml.post[i].media.toString();
					arr.push(tmpobj);
				}
				
				evt.data = arr;
				dispatchEvent(evt);
			}
		}
		
		private function getsettingsHandler(event:Event):void
		{
			var xml:XML = new XML(event.target.data);
			
			if(xml.code.toString() != "")
			{
				evt = new MeConnectEvent(MeConnectEvent.ON_FAULT);
				evt.code = xml.code.toString();
				evt.description = xml.description.toString();
				evt.message = xml.message.toString();
				dispatchEvent(evt);
			}else{
				
				evt = new MeConnectEvent(MeConnectEvent.GETSETTINGS_RESULT);
				var obj:Object = new Object();
				obj["mytags"] = xml.mytags.toString();
				obj["mytagsInTab"] = xml.mytagsInTab.toString();
				obj["description"] = xml.description.toString();
				evt.data = obj;
				dispatchEvent(evt);				
			}
		}
		
		
		private function result_getTagsHandler(e:ResultEvent):void{
			evt = new MeConnectEvent(MeConnectEvent.GETTAGS_RESULT);
			evt.data = e.result;
			dispatchEvent(evt);
		}
		
		
		
		private function gettagsHandler(event:Event):void
		{
			var xml:XML = new XML(event.target.data);
			
			if(xml.code.toString() != "")
			{
				evt = new MeConnectEvent(MeConnectEvent.ON_FAULT);
				evt.code = xml.code.toString();
				evt.description = xml.description.toString();
				evt.message = xml.message.toString();
				dispatchEvent(evt);
			}else{
				var i:uint=0;
				var arr:Array = new Array();
				var tempobj:Object;
				evt = new MeConnectEvent(MeConnectEvent.GETTAGS_RESULT);				
				
				for(i=0; i<xml.tag.length(); i++)
				{
					tempobj = new Object();
					tempobj["name"] = xml.tag[i].name.toString();
					tempobj["url"] = xml.tag[i].url.toString();
					tempobj["count"] = xml.tag[i].count.toString();
					arr.push(tempobj);
				}
				evt.data = arr;
				dispatchEvent(evt);
				
			}
		}
		
		private function metooHandler(event:Event):void
		{
			var xml:XML = new XML(event.target.data);
			
			if(xml.code == 0)
			{
				evt = new MeConnectEvent(MeConnectEvent.METOO_RESULT);
				dispatchEvent(evt);	
			}else{
				evt = new MeConnectEvent(MeConnectEvent.ON_FAULT);
				evt.code = xml.code.toString();
				evt.description = xml.description.toString();
				evt.message = xml.message.toString();
				dispatchEvent(evt);
			}
		}
		
		
		private function noop_faultHandler(e:FaultEvent):void{
			evt = new MeConnectEvent(MeConnectEvent.ON_FAULT);
			evt.data = e.message;
			dispatchEvent(evt);
		}
		
		private function noop_resultHandler(e:ResultEvent):void{
			evt = new MeConnectEvent(MeConnectEvent.NOOP_RESULT);
			evt.data = e.result;
			dispatchEvent(evt);
		}
		
		private function noopHandler(event:Event):void
		{
			var xml:XML = new XML(event.target.data);
			evt = new MeConnectEvent(MeConnectEvent.NOOP_RESULT);
			dispatchEvent(evt);
		}
		
		
		private function result_trackcommnetsHandler(e:ResultEvent):void{
			evt = new MeConnectEvent(MeConnectEvent.TRACKCOMMENTS_RESULT);
			evt.data = e.result;
			dispatchEvent(evt);
		}
		
		private function trackcommentsHandler(event:Event):void
		{
			var xml:XML = new XML(event.target.data);
			
			if(xml.code.toString() != "")
			{
				evt = new MeConnectEvent(MeConnectEvent.ON_FAULT);
				evt.code = xml.code.toString();
				evt.description = xml.description.toString();
				evt.message = xml.message.toString();
				dispatchEvent(evt);
			}else{
				
				var i:uint = 0;
				var obj:Object = new Object();
				var obj2:Object,obj3:Object,obj4:Object;
				var arr:Array = new Array();
				
				for(i=0; i<xml.commentByMe.length(); i++)
				{
					obj2 = new Object();
					obj3 = new Object();
					obj4 = new Object();
					obj3["post_id"] = xml.commentByMe[i].post.post_id.toString();
					obj3["permalink"] = xml.commentByMe[i].post.permalink.toString();
					obj3["body"] = xml.commentByMe[i].post.body.toString();
					obj3["me2dayPage"] = xml.commentByMe[i].post.me2dayPage.toString();
					obj4["id"] = xml.commentByMe[i].post.author.id.toString();
					obj4["nickname"] = xml.commentByMe[i].post.author.nickname.toString();
					obj4["me2dayHome"] = xml.commentByMe[i].post.author.me2dayHome.toString();
					obj3["pubDate"] = xml.commentByMe[i].post.pubDate.toString();
					obj3["author"] = obj4;					
					obj2["post"] = obj3;
					obj3 = new Object();
					obj3["body"] = xml.commentByMe[i].comment.body.toString();
					obj3["pubDate"] = xml.commentByMe[i].comment.pubDate.toString();
					obj2["comment"] = obj3;
					arr.push(obj2);
				}
				obj["commentByMe"] = arr;
				arr = new Array();
				for(i=0; i<xml.commentToMe.length(); i++)
				{
					obj2 = new Object();
					obj3 = new Object();
					
					obj3["post_id"] = xml.commentToMe[i].post.post_id.toString();
					obj3["permalink"] = xml.commentToMe[i].post.permalink.toString();
					obj3["body"] = xml.commentToMe[i].post.body.toString();
					obj3["me2dayPage"] = xml.commentToMe[i].post.me2dayPage.toString();
					obj3["pubDate"] = xml.commentToMe[i].post.pubDate.toString();
					
					obj2["post"] = obj3;
					obj3 = new Object();
					obj4 = new Object();
					obj3["body"] = xml.commentToMe[i].comment.body.toString();
					obj3["pubDate"] = xml.commentToMe[i].comment.pubDate.toString();
					obj4["id"] = xml.commentToMe[i].comment.author.id.toString();
					obj4["nickname"] = xml.commentToMe[i].comment.author.nickname.toString();
					obj4["me2dayHome"] = xml.commentToMe[i].comment.author.me2dayHome.toString();
					obj3["author"] = obj4;
					obj2["comment"] = obj3;
					arr.push(obj2);
				}
				obj["commentToMe"] = arr;
				
				evt = new MeConnectEvent(MeConnectEvent.TRACKCOMMENTS_RESULT);
				evt.data = obj;
				dispatchEvent(evt);								
			}
		}		
	}
}