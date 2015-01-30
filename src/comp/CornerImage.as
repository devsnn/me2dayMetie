package comp
{
	import flash.display.Sprite;
	
	import mx.controls.Image;
	import mx.events.ResizeEvent;

	public class CornerImage extends Image
	{
		[Bindable] public var cornerRadius:uint = 10;

		private var roundedMask:Sprite;
		
		public function CornerImage()
		{
			super();
			
			addEventListener(Event.COMPLETE, redrawMask);
			//addEventListener(ResizeEvent.RESIZE, redrawMask);
			//TODO: Fix image corner rounding with maxHeight/maxWidth
		}
		
		public function redrawMask(event:Event) : void
		{
			removeEventListener(Event.COMPLETE, redrawMask);
			
			if(!roundedMask)
			{
				roundedMask = new Sprite();
				addChild(roundedMask);
			}
		
			var h:Number = Math.min(height, maxHeight, getExplicitOrMeasuredHeight());
			var w:Number = Math.min(width, maxWidth, getExplicitOrMeasuredWidth());
			
			if(content) {
				w = Math.min(w, content.width);
				h = Math.min(h, content.height);
			}
			
			roundedMask.graphics.clear();
			roundedMask.graphics.beginFill(0xFF0000);
			roundedMask.graphics.drawRoundRect(0, 0, w, h,cornerRadius, cornerRadius);
			roundedMask.graphics.endFill();
			
			this.mask = roundedMask;
		}
		
	}
}