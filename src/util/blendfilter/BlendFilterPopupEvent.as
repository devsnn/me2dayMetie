package util.blendfilter
{
	import flash.display.Bitmap;
	import flash.events.Event;

	public class BlendFilterPopupEvent extends Event
	{
		public static const SELECTED_FILTER:String = "selectedFilter";
		
		public var bitmap:Bitmap;
		public var filterString:String;
		
		public function BlendFilterPopupEvent(type:String, _bitmap:Bitmap, _filterString:String)
		{
			super(type);
			bitmap = _bitmap;
			filterString = _filterString;
		}
		
	}
}