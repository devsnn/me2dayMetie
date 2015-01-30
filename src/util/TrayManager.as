package util
{
	import auth.MetieVer;
	
	import flash.desktop.DockIcon;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemTrayIcon;
	import flash.display.Bitmap;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.core.Application;
	import mx.core.WindowedApplication;

	
	public class TrayManager
	{
		
		[Embed(source="icons/leaf16.png")]
		public var trayIcon:Class;
		
		private static var _instance:TrayManager;
		
		private var _windowApp:WindowedApplication;
		
		public function TrayManager()
		{
		}
		

		public static function get getInstance():TrayManager
		{
			if(_instance == null){
				_instance = new TrayManager();
			}
			return _instance;
		}


		public function get windowApp():WindowedApplication
		{
			return _windowApp;
		}

		public function set windowApp(value:WindowedApplication):void
		{
			_windowApp = value;
			trayMenuCreate();
		}

		public function trayMenuCreate():void{
			var menu:NativeMenu = new NativeMenu();
			
			var item:NativeMenuItem;
			
			item = new NativeMenuItem("me2DAY 가기");
			item.addEventListener(Event.SELECT, me2day_selectHandler);
			menu.addItem(item);
			
			item = new NativeMenuItem("Metie "+MetieVer.INFO);
			item.addEventListener(Event.SELECT, metie_selectHandler);
			menu.addItem(item);
			
			item = new NativeMenuItem(UserSetting.user_id+"님 마이미투");
			item.addEventListener(Event.SELECT, myme_selectHandler);
			menu.addItem(item);
			
			item = new NativeMenuItem("", true);
			menu.addItem(item);
			
			item = new NativeMenuItem("미티 로그아웃");
			item.addEventListener(Event.SELECT, logout_selectHandler);
			menu.addItem(item);
			
			item = new NativeMenuItem("미티 종료");
			item.addEventListener(Event.SELECT, exit_selectHandler);
			menu.addItem(item);
			
			if(NativeApplication.supportsSystemTrayIcon){
				(NativeApplication.nativeApplication.icon as SystemTrayIcon).menu = menu;
				(NativeApplication.nativeApplication.icon as SystemTrayIcon).addEventListener(MouseEvent.CLICK, trayIcon_clickHandler);
				
				var trayBitmap:Bitmap = new trayIcon();
				NativeApplication.nativeApplication.icon.bitmaps = [trayBitmap.bitmapData];
			}
			else if(NativeApplication.supportsDockIcon){
				(NativeApplication.nativeApplication.icon as DockIcon).menu = menu;
				(NativeApplication.nativeApplication.icon as DockIcon).addEventListener(Event.ACTIVATE, trayIcon_clickHandler);
			}
			windowApp.contextMenu = menu;
		}
		
		
		private function trayIcon_clickHandler(e:Event):void{
			windowActivate();
		}
		
		
		public static function orderToFront():void{
			getInstance.windowActivate();
		}
		
		
		private function windowActivate():void{
			windowApp.stage.frameRate = 24;
			windowApp.stage.nativeWindow.visible = true;
			windowApp.stage.nativeWindow.orderToFront();
		}
		
		
		// 미티 종료 
		private function exit_selectHandler(e:Event):void{
			Application.application.exit();
		}
		
		
		private function logout_selectHandler(e:Event):void{
			var so:SharedObject = SharedObject.getLocal("metie");
			so.data.user_id = null;
			so.data.full_auth_token = null;
			so.flush(10000);
			
			Application.application.exit();
		}
		
		
		private function myme_selectHandler(e:Event):void{
			navigateToURL(new URLRequest("http://me2day.net/"+UserSetting.user_id), "_blank");
		}
		
		private function metie_selectHandler(e:Event):void{
			navigateToURL(new URLRequest("http://novely.com/metie"), "_blank");
		}
		
		private function me2day_selectHandler(e:Event):void{
			navigateToURL(new URLRequest("http://me2day.net"), "_blank");
		}
		
		
		
	}
}