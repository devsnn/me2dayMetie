package comp
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.*;
	import flash.net.URLRequest;
	
	import mx.core.FlexSprite;
	
	public class SpriteWithBitmap extends FlexSprite
	{
		//Pass the source path or url here.
		private var url:String = "";
		private var wid:Number;
		private var hei:Number;
		
		public function SpriteWithBitmap(_url:String, _wid:Number=60, _hei:Number=60)
		{
			source = _url;
			wid = _wid;
			hei = _hei;
			
			loadImg();
		}
		
		public function set source(value:String):void{
			url = value;
		}
		
		private var loader:Loader;
		
		private function loadImg():void
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadFailure);
			var request:URLRequest = new URLRequest(url);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			loader.load(request);
			this.addChild(loader);
		}
		
		public function destory():void{
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadFailure);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			if(loader.contentLoaderInfo.content){
				(loader.contentLoaderInfo.content as Bitmap).bitmapData.dispose();
			}
			loader = null;
		}
		
		
		private function loadComplete(e:Event):void{
			this.width = wid;
			this.height = hei;
			
			(loader.contentLoaderInfo.content as Bitmap).smoothing = true;
			//trace("load complete", this.getChildAt(0).width, this.width);
		}
		
		private function loadFailure(event:IOErrorEvent):void
		{
			trace("load false");
			//Alert.show("Can't load :" + url);
		}
	}
	
}
