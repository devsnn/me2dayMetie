package com.lhd.events
{
	import flash.events.Event;

	/**
	 * Me2day API 이벤트
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author 이희덕
	 */
	public class MeConnectEvent extends Event
	{
		/**
		 * 코멘트를 정상적으로 등록하였을때
		 */
		public static const CREATECOMMENT_RESULT:String = "createcommentresult";
		/**
		 * 포스트를 정상적으로 등록하였을때
		 */
		public static const CREATEPOST_RESULT:String = "createpostresult";
		/**
		 * 코멘트를 정상적으로 삭제하였을때
		 */
		public static const DELETECOMMENT_RESULT:String = "deletecommentresult";
		/**
		 * 코멘트 정보를 정상적으로 수신하였을때
		 */
		public static const GETCOMMENTS_RESULT:String = "getcommentsresult";
		/**
		 * 친구 정보를 정상적으로 수신하였을때
		 */
		public static const GETFRIENDS_RESULT:String = "getfriendsresult";
		/**
		 * 최근등록 포스트 정보를  정상적으로 수신하였을때
		 */
		public static const GETLATESTS_RESULT:String = "getlatestsresult";
		/**
		 * 미투한 사용자 목록 정보를  정상적으로 수신하였을때
		 */
		public static const GETMETOOS_RESULT:String = "getmetoosresult";
		/**
		 * 미투데이 가입자 정보를 정상적으로 수신하였을때
		 */
		public static const GETPERSON_RESULT:String = "getpersonresult";
		/**
		 * 포스트 정보를 정상적으로 수신하였을때
		 */
		public static const GETPOSTS_RESULT:String = "getpostsresult";
		/**
		 * 환경설정 정보를 정상적으로 수신하였을때
		 */
		public static const GETSETTINGS_RESULT:String = "getsettingsresult";
		/**
		 * 태그목록 정보를 정상적으로 수신하였을때
		 */
		public static const GETTAGS_RESULT:String = "gettagsresult";
		/**
		 * 정상적으로 미투하였을때
		 */
		public static const METOO_RESULT:String = "metooresult";
		/**
		 * 서버와의 통신에 성공하였을때
		 */
		public static const NOOP_RESULT:String = "noopresult";
		/**
		 * 코멘트 정보를 정상적으로 수신하였을때
		 */
		public static const TRACKCOMMENTS_RESULT:String = "trackcommentsresult";
		/**
		 * 통신상태가 정상적이지 않거나, 에러가 발생하였을때
		 */
		public static const ON_FAULT:String = "onfault";				
		
		public static const ACCEPT_FRIEND:String = "acceptfriendresult";
		
		/**
		 * 데이터
		 */
		public var data:*;
		/**
		 * 에러코드
		 */
		public var code:uint;
		/**
		 * 에러메세지
		 */
		public var message:String;
		/**
		 * 에러설명
		 */
		public var description:String;
		
		public function MeConnectEvent(type:String)
		{
			super(type);
		}
		
	}
}