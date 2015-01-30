package comp
{
	import mx.controls.TextArea;
	import mx.core.IUITextField;
	import mx.events.FlexEvent;
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	
	[Event(name="bindUpdate")]
	
	public class NovTextArea extends TextArea
	{
		public static const BIND_UPDATE:String = "bindUpdate";
		
		private var _bindModel:Object;		
		private var _bindProperty:String;
		
		private var _bindUpdateEvent:String = FlexEvent.VALUE_COMMIT;
		
		public function NovTextArea():void {
			super();
			this.addEventListener(bindUpdateEvent, valueCommitHandler);
			this.addEventListener(FlexEvent.REMOVE, removeEventHandler);
		}
		
		
		override protected function createChildren():void{
			super.createChildren();
			getTextField().alwaysShowSelection = true;
		}
		
		
		[Bindable]
		public function get bindUpdateEvent():String {
			return _bindUpdateEvent;
		}
		
		
		public function set bindUpdateEvent(eventType:String):void {
			this.removeEventListener(_bindUpdateEvent, valueCommitHandler);
			
			_bindUpdateEvent = eventType;
			this.addEventListener(eventType, valueCommitHandler);
		}
		
		
		[Bindable]
		public function get bindModel():Object {
			return _bindModel;
		}
		
		
		public function set bindModel(object:Object):void {
			_bindModel = object;
			if(bindProperty != null){
				text = _bindModel.hasOwnProperty(bindProperty)?_bindModel[bindProperty]:"";
			}
			
		}
		
		
		[Bindable]
		public function get bindProperty():String {
			return _bindProperty;
		}
		
		public function set bindProperty(property:String):void {			
			_bindProperty = property;
			
			
			if(bindModel != null){
				text = bindModel.hasOwnProperty(property)?bindModel[property]:"";
			}
		}
		
		
		private function valueCommitHandler(e:Event):void {
			
			if(bindModel != null && bindProperty != null){
				if(bindModel.hasOwnProperty(bindProperty)){
					bindModel[bindProperty] = text
					dispatchEvent(new Event(BIND_UPDATE));
				}
			}
		}
		
		private function removeEventHandler(e:FlexEvent):void {
			removeEventListener(FlexEvent.REMOVE, removeEventHandler);
			removeEventListener(bindUpdateEvent, valueCommitHandler);
			_bindModel = null;
			_bindProperty = null;
			
		}
		
		
		public function getTextField():IUITextField {
			return textField;
		}
	}
}