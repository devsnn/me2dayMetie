package comp
{
	import flash.events.Event;
	
	import mx.controls.TextInput;
	import mx.core.IUITextField;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;

	use namespace mx_internal;


	[Event(name="bindUpdate")]
	
	
	public class NovTextInput extends TextInput
	{
		public static const BIND_UPDATE:String = "bindUpdate";
		
		private var _bindModel:Object;		
		private var _bindProperty:String;
		
		private var _bindEventType:String = FlexEvent.VALUE_COMMIT;
		
		
		public function NovTextInput()
		{
			super();
			//this.restrict = "ㄱ-힣A-z0-9!@#$&()_ \\";
			//this.restrict = "^\\:/*?|\\^\\\\";
			this.addEventListener(bindEventType, valueCommitHandler);
			this.addEventListener(FlexEvent.REMOVE, removeEventHandler);
			
		}
		
		override protected function createChildren():void{
			super.createChildren();
			getTextField().alwaysShowSelection = true;
		}
		
		[Bindable]
		public function get bindEventType():String {
			return _bindEventType;
		}
		
		
		public function set bindEventType(eventType:String):void {
			this.removeEventListener(_bindEventType, valueCommitHandler);
			
			_bindEventType = eventType;
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
			removeEventListener(bindEventType, valueCommitHandler);
			_bindModel = null;
			_bindProperty = null;
			
		}
		
		public function getTextField():IUITextField {
			return textField;
		}
		
	}
}