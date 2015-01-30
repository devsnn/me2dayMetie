package util.messageservice
{

	
	import flash.events.EventDispatcher;
	
	import org.codehaus.stomp.Stomp;
	import org.codehaus.stomp.event.ConnectedEvent;
	import org.codehaus.stomp.event.MessageEvent;
	import org.codehaus.stomp.event.ReceiptEvent;
	import org.codehaus.stomp.event.STOMPErrorEvent;
	import org.codehaus.stomp.frame.MessageFrame;
	import org.codehaus.stomp.headers.ConnectHeaders;
	
	
	[Event(name="connected", type="ConnectedEvent")]
	[Event(name="message", type="MessageEvent")]
	[Event(name="receipt", type="ReceiptEvent")]
	[Event(name="error", type="STOMPErrorEvent")]
	public class Me2MessageService extends EventDispatcher
	{
				
		public var connectHeaders:ConnectHeaders = new ConnectHeaders();
		public var stomp:Stomp = new Stomp();
		
		private var _lastMessage:MessageFrame;
		private var _lastMessageBodyXML:XML;
		private var _lastMessageHeaders:Me2MessageHeader;
			
		
		static private var me2MessageService:Me2MessageService;
		
		static public function getMessageService():Me2MessageService {
			if(me2MessageService){
				return me2MessageService;
			}else {
				try{
					me2MessageService = new Me2MessageService();
				}
				catch(e:Error){
					trace("error Me2MessageService");
				}
				
				return me2MessageService;
			}
		}
		
		
		static public function addEventListener(type:String, listener:Function, useCapture:Boolean=false,priority:int=0,useWeakReference:Boolean=false):void {
			Me2MessageService.getMessageService().stomp.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		
		static public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			Me2MessageService.getMessageService().stomp.removeEventListener(type,listener,useCapture);
		}
		
		static public function get lastMessage():MessageFrame {
			return Me2MessageService.getMessageService().lastMessage;
		}
		
		static public function get lastMessageHeaders():Me2MessageHeader {
			return Me2MessageService.getMessageService().lastMessageHeaders;
		}
				
		static public function get lastMessageBodyXML():XML {
			return Me2MessageService.getMessageService().lastMessageBodyXML;
		}
		
		static public function auth(user_id:String, app_key:String, full_auth_token:String):void{
			try{
				var service:Me2MessageService = Me2MessageService.getMessageService();
				
				service.connectHeaders.login = user_id+'@'+app_key;
				service.connectHeaders.passcode = full_auth_token;
				
				service.stomp.autoReconnect = true;
				service.stomp.connect("nc.me2day.net", 10001, service.connectHeaders);
				service.stomp.subscribe( '/queue/me2day/nc/'+user_id ); 	
			}
			catch(e:Error){
				trace("error : Me2MessageService");
			}
			
		}
		
		public function Me2MessageService():void {
			
			stomp.addEventListener(ConnectedEvent.CONNECTED, connectedHandler);
			stomp.addEventListener(MessageEvent.MESSAGE, messageHandler);
			stomp.addEventListener(ReceiptEvent.RECEIPT, receiptHandler);
			stomp.addEventListener(STOMPErrorEvent.ERROR, faultHandler);
			
		}
		
		public function stop():void{
			Me2MessageService.getMessageService().stomp.disconnect();
		}
		
		public function get lastMessage():MessageFrame {
			return _lastMessage;
		}
		
		public function get lastMessageHeaders():Me2MessageHeader {
			return _lastMessageHeaders;	
		}
		
		public function get lastMessageBodyXML():XML {
			return _lastMessageBodyXML;
		}
		
		private function connectedHandler(event:ConnectedEvent):void {
		}
		
		private function messageHandler(event:MessageEvent):void {
			
			_lastMessage = event.message;			
			
			_lastMessageHeaders = new Me2MessageHeader(event.message.headers);
			
			try{
			
				_lastMessageBodyXML = new XML(lastMessage.body.readMultiByte(lastMessage.body.length,'utf-8'));
			
			}catch(e:Error){
				_lastMessageBodyXML = new XML('');		
			}			
		}
		
		private function receiptHandler(event:ReceiptEvent):void {
		}
		
		private function faultHandler(event:STOMPErrorEvent):void {
		}
	}
}