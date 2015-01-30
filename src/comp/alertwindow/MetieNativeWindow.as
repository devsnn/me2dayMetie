package comp.alertwindow
{
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.events.Event;
	
	import mx.containers.Canvas;
	import mx.events.FlexEvent;
	import mx.managers.WindowedSystemManager;
	
	[Event(name="creationComplete", type="mx.events.FlexEvent")] 
	
	public class MetieNativeWindow extends NativeWindow
	{
		private var systemManager:WindowedSystemManager;
		
		private var windowFlexContainer:Canvas;
		
		private var childrenCreated:Boolean = false;
		
		public function MetieNativeWindow(initOptions:NativeWindowInitOptions = null)
		{
			// 미티를 위해 투명..
			var options:NativeWindowInitOptions;
			if(initOptions == null){
				options = new NativeWindowInitOptions();
				options.systemChrome = NativeWindowSystemChrome.NONE;
				options.type = NativeWindowType.LIGHTWEIGHT;
				options.transparent = true;
			}
			else{
				options = initOptions;
			}
			
			//initOptions == null ? options = new NativeWindowInitOptions() : options = initOptions;
			
			super(options);
			
			addEventListener(Event.ACTIVATE, windowActivateHandler);
		}
		
		private function windowActivateHandler(event:Event):void {
			event.preventDefault();
			event.stopImmediatePropagation();
			removeEventListener(Event.ACTIVATE, windowActivateHandler);
			if(stage) {
				createChildren();
				stage.addEventListener(Event.RESIZE, windowResizeHandler);
			}
		}
		
		private function createChildren():void {
			if(!windowFlexContainer) {
				windowFlexContainer = new Canvas();
			}
			
			if(!systemManager) {
				systemManager = new WindowedSystemManager(windowFlexContainer);
			}
			
			stage.addChild(systemManager);
			
			windowFlexContainer.width = stage.stageWidth;
			windowFlexContainer.height = stage.stageHeight;
			
			stage.addChild(windowFlexContainer);
			
			childrenCreated = true;
			
			dispatchEvent(new FlexEvent(FlexEvent.CREATION_COMPLETE));
		}
		
		private function windowResizeHandler(event:Event):void {
			windowFlexContainer.width = stage.stageWidth;
			windowFlexContainer.height = stage.stageHeight;
		}
		
		public function get container():Canvas {
			return windowFlexContainer;
		}
		
		public function destroy():void {
			removeEventListener(Event.RESIZE, windowResizeHandler);
			windowFlexContainer.removeAllChildren();
			stage.removeChild(windowFlexContainer);
			stage.removeChild(systemManager);
			windowFlexContainer = null;
			systemManager = null;
		}
	}
}