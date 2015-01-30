package comp.alertwindow
{
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.events.Event;
	
	import mx.containers.Canvas;
	import mx.core.Window;
	import mx.events.FlexEvent;
	import mx.managers.WindowedSystemManager;
	
	public class MetieWindow extends Window
	{
		
		
		public function MetieWindow()
		{
			super();
			systemChrome = NativeWindowSystemChrome.NONE;
			type = NativeWindowType.LIGHTWEIGHT;
			transparent = true;
		}
		
		
		
	}
}