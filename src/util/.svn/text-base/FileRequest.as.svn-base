package	util
{
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;
	
	
	[Event(name="result", type="FileRequestEvent")]
	[Event(name="falut", type="FileRequestEvent")]
	
	public class FileRequest extends EventDispatcher
	{
		private const CRLF:String = '\r\n';
		
		private var httpService:HTTPService;
		
		private var body:ByteArray;
		
		private var boundary:String;

		private var message:Array = new Array();

		public function FileRequest(url:String):void{
		
			boundary = getBoundary();
			
			httpService = new HTTPService();
			
			httpService.url = url;
			
			//httpService.destination = url;
			httpService.showBusyCursor = true;
			//httpService.showBusyCursor = true;
			
			httpService.method = "POST";
			
			//this.dispatchEvent(evt);
        	httpService.addEventListener(ResultEvent.RESULT,result);
        	httpService.addEventListener(FaultEvent.FAULT,fault);
			
			//httpService.contentType = "multipart/form-data; boundary=" + boundary;
			httpService.contentType = "application/x-www-form-urlencoded; boundary=" + boundary;
		}
		
		public function setHeader(obj:Object):void {
			
			httpService.headers = obj;
		}
		
		public function set request(obj:Object):void {
					
			for(var name:String in obj){
				trace(name);
				if(obj[name] !=null) addString(name,obj[name]);
			}
			
		}
		
		private function getBoundary():String{
			   var uniq:String = String(Math.ceil(Math.random() * 1000000));
			   return '--------FlexMessage' + uniq;
		}
		
		private function Build():void{
			body = new ByteArray();
			var ret:ByteArray = new ByteArray();
			
			ret.writeUTFBytes(boundary+'\r\n');
			ret.writeUTFBytes('--');
			ret.writeUTFBytes(boundary);
			ret.writeUTFBytes(CRLF);
			
			for(var i:Number = 0, cnt:Number = message.length; i < cnt; i ++){
				switch (message[i].type)
				{
					case 'POST': 
						ret.writeBytes(makeByteForString(message[i]));
						break;
					case 'FILE': 
						ret.writeBytes(makeByteForFile(message[i]));
						break;
				}
				
				ret.writeUTFBytes(CRLF);
			    ret.writeUTFBytes('--');
			    ret.writeUTFBytes(boundary);
			    ret.writeUTFBytes(i==cnt?'--':CRLF);
			}
			
			ret.writeUTFBytes(CRLF);
			body.writeBytes(ret);
			httpService.request = body;
		}
		
		private function makeByteForString(obj:Object):ByteArray{
			var data:ByteArray = new ByteArray();;
			data.writeUTFBytes('Content-Disposition: form-data; name="' + obj.name + '"');
			data.writeUTFBytes(CRLF);
			data.writeUTFBytes(CRLF);
			data.writeUTFBytes(obj.value);
		    return data;
		}
		
		private function makeByteForFile(obj:Object):ByteArray{
			var data:ByteArray = new ByteArray();;
			data.writeUTFBytes('Content-Disposition: form-data; name="' + obj.name + '"; filename="' + obj.filename + '"\r\n');
			data.writeUTFBytes('Content-Type: image/jpg');
			data.writeUTFBytes(CRLF);
			data.writeUTFBytes('Content-Transfer-Encoding: binary');
			data.writeUTFBytes(CRLF);
			data.writeUTFBytes(CRLF);
			data.writeBytes(obj.value);			
			return data;
		}
		
		public function addString(name:String, value:String):void{
			var obj:Object = {name:String, value:String, type:String};
			obj.name = name;
			obj.value = value;
			obj.type = "POST";
			
			message.push(obj);			
		}
		
		public function addFiledata(name:String, filename:String, value:ByteArray, value2:String):void{
			var obj:Object = {name:String, filename:String, value:ByteArray, type:String};
			obj.name = name;
			obj.filename = filename;
			obj.value = value;
			obj.type = "FILE";
			
			message.push(obj);
		}
		
		public function send():void{
			Build();
			
//			navigateToURL(httpService,"_self");
			httpService.send();
		}
		
		
		private function result(event:ResultEvent):void
		{
			var evt:FileRequestEvent = new FileRequestEvent("result");
			
			evt.lastResult = event.result;
			this.dispatchEvent(evt);

			//trace(evt.target);
		}
		private function fault(event:FaultEvent):void
		{
			var evt:FileRequestEvent = new FileRequestEvent("fault");
				
			evt.faultMessage = event.fault.toString();
			this.dispatchEvent(evt);
			//trace(evt.fault.faultDetail);
		}
		
		public function test():void{
			trace("test");
		}
	}
}