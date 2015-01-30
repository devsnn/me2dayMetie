package comp
{
	import mx.containers.HBox;
	import mx.styles.StyleManager;
	
	public class GradientHBox extends HBox
	{
		override protected function updateDisplayList(w : Number, h : Number) : void
		{
			super.updateDisplayList (w, h);
			
			// retrieves the user-defined styles
			var fillColors : Array = getStyle("fillColors");
			var fillAlphas : Array = getStyle("fillAlphas");
			var cornerRadius : Number = getStyle("cornerRadius");
			
			// converts the fill colors to RGB color values
			StyleManager.getColorNames (fillColors);
			
			// ready to draw!
			graphics.clear();
			
			// draws the gradient
			drawRoundRect (0, 0, w, h, cornerRadius, fillColors, fillAlphas, verticalGradientMatrix (0, 0, w, h));
		}
	}
}