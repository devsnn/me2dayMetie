package auth
{
	import flash.desktop.Updater;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	
	import header.DBConnecter;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.rpc.events.ResultEvent;
	
	import panel.LoadingPanel;
	
	import request.RequestVer;

	public class MetieVerChecker extends LoadingPanel
	{
		public var metie_ver:String;
		
		private var urlStream:URLStream;
		private var fileData:ByteArray;
		private var air_file:File;
		
		public function MetieVerChecker()
		{
			this.addEventListener(FlexEvent.CREATION_COMPLETE, create);
		}
		
		
		private function create(e:FlexEvent):void{
			this.progressBar.indeterminate = false;
			this.textLabel = "버전체크";
		}
		
		public function start():void{
			var dbConnect:DBConnecter = new DBConnecter();
			var req:RequestVer = new RequestVer();
			dbConnect.addEventListener(ResultEvent.RESULT, result_verHandler);
			dbConnect.query(req, false, true);
		}
		
		
		private function result_verHandler(e:ResultEvent):void{
			metie_ver = e.result.toString();
			
			if(MetieVer.INFO != metie_ver){
				trace("로컬버전:", MetieVer.INFO, " new:", metie_ver);
				Alert.show("최신 업데이트가 존재합니다. 업데이트하시겠습니까?", "업데이트", Alert.YES + Alert.NO, Application.application.document, ver_closeHandler);
				return;
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
		private function ver_closeHandler(e:CloseEvent):void{
			if(e.detail == Alert.YES){
				var urlReq:URLRequest = new URLRequest(MetieVer.AIR_FILE);
				urlStream = new URLStream();
				fileData = new ByteArray();
				
				urlStream.addEventListener(Event.COMPLETE, completeHandler);
				urlStream.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				urlStream.addEventListener(ProgressEvent.PROGRESS, streamProgressHandler);
				urlStream.load(urlReq);
			}
			else{
				dispatchEvent(new Event(Event.COMPLETE));
			}

		}
		
		private function completeHandler(e:Event):void{
			urlStream.readBytes(fileData, 0, urlStream.bytesAvailable);
			writeAirFile();
		}
		
		private function streamProgressHandler(e:ProgressEvent):void{
			progressBar.setProgress(e.bytesLoaded, e.bytesTotal);
		}
		
		
		private function ioErrorHandler(e:IOErrorEvent):void{
			Alert.show("업데이트 파일을 찾을 수 없습니다. 파일경로가 올바르지 않을 수 있습니다.", "알림", 4, Application.application.document);
		}
		
		private function writeAirFile():void{
			air_file = File.applicationStorageDirectory.resolvePath("Metie.air");
			var fileStream:FileStream = new FileStream();
			fileStream.addEventListener(Event.CLOSE, fileCloseHandler);
			fileStream.openAsync(air_file, FileMode.WRITE);
			fileStream.writeBytes(fileData, 0, fileData.length);
			fileStream.close();
			
		}
		
		
		private function fileCloseHandler(e:Event):void{
			var updater:Updater = new Updater();
			updater.update(air_file, metie_ver);
		}
	}
}