package header
{
	import flash.net.URLRequest;
	
	import request.Request;
	
	import mx.rpc.http.HTTPService;
	
	import util.Base64;
	import util.UserSetting;

	public class DBConnecter extends HTTPService
	{
		
		public static const TEST_URL:String = "http://me2day.net/api/";
		public static const MAIN_URL:String = "http://me2day.net/api/";
		public static const NOV_URL:String = "http://novely.com/db/";
		
		
		public function DBConnecter()
		{
			this.useProxy = false;
			this.resultFormat = "e4x";
			this.method = "POST";
			
		}
		
		private function auth_token():void{
			trace("auth_token!", UserSetting.user_id, UserSetting.full_auth_token);
			var user_key:String = UserSetting.full_auth_token;
			var pass:String = "full_auth_token "+user_key;
			this.headers = {Authorization:"Basic " + Base64.encode(UserSetting.user_id+":"+pass)};    
			this.contentType = "application/x-www-form-urlencoded";
		}
		
		
		
		public function query(req:Request, auth:Boolean=false, nov_server:Boolean=false):void{
			
			// test
			var test:int = 1;
			
			if(test == 0){
				this.url = MAIN_URL + req.getMethod();
			}
			else{
				this.url = TEST_URL + req.getMethod();
				trace("url", url);
			}
			
			if(nov_server){
				this.url = NOV_URL + req.getMethod();
			}
			
			if(auth){
				auth_token();
			}
			
			this.send(req.toObject());
		}
		
		public function queryURLRequest(req:URLRequest, auth:Boolean=false):void{
			trace("queryURLRequest:", req.url);
			
			this.url = req.url;
			
			req.method = "POST";
			
			if(auth){
				auth_token();
			}
			
			this.send(req.data);
		}
		
	}
}