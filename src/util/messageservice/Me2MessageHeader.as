package util.messageservice
{
	public class Me2MessageHeader
	{
		private var _obj:Object;
		
		public const SCOPE_FRIENDS_POST:String = 'friends_post';
		public const SCOPE_SMS_FRIENDS_POST:String = 'sms_friends_post';
		public const SCOPE_COMMENT_TO_ME:String = 'comment_to_me';
		public const SCOPE_COMMENTS_ON_BY_ME:String = 'comments_on_by_me';
		public const SCOPE_METOOED_ME:String = 'metooed_me';
		public const SCOPE_FRIEND_REQUEST:String = 'friend_request';
		public const SCOPE_FRIEND_REQUEST_ACCEPTED:String = 'friend_request_accepted';
		public const SCOPE_TOKEN_GIFT:String = 'token_gift';
		public const SCOPE_MENTIONED_USER:String = 'mentioned_user';
		public const SCOPE_MOBILE_BUDDY:String = 'mobile_buddy';
		public const SCOPE_BAND_POST:String = 'band_post';
		
		public function Me2MessageHeader(obj:Object)
		{
			_obj = obj;
		}
		
		
		public function get uuid():String {
			if(_obj){
				return _obj['uuid'];
			}
			
			return '';
		}
		
		public function get from():String {
			if(_obj){
				return _obj['from'];
			}
			return '';
		}
		
		public function get scope():String {
			if(_obj){
				return _obj['scope'];
			}
			return '';
		}
		
		public function get timestamp():String {
			if(_obj){
				return _obj['timestamp'];
			}
			return '';
		}
	}
}