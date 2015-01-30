package util.blendfilter
{
	import flash.display.BlendMode;
	
	public class BlendName
	{
		public static const SOFTLIGHT:String = "softlight";
		public static const SCREEN:String = "screen";
		public static const CONTRAST:String = "contrast";
		public static const LIGHT:String = "light";
		public static const BLUR_OVERLAY:String = "blurOverlay";
		public static const NORMAL:String = "normal";
		
		
		public static function getName(filterString:String):String{
			
			if(filterString.indexOf(BlendMode.MULTIPLY) != -1 && filterString.indexOf(BlendMode.SCREEN) != -1){
				return "조금밝게";
			}
			else if(filterString.indexOf(BlendMode.OVERLAY) != -1 && filterString.indexOf(BlendMode.SCREEN) != -1){
				return "밝게";
			}
			else if(filterString.indexOf(BlendMode.OVERLAY) != -1 && filterString.indexOf(BlendMode.DARKEN) != -1){
				return "어둡게";
			}
			else if(filterString.indexOf(BlendMode.NORMAL) != -1 && filterString.indexOf(BlendMode.ADD) != -1){
				return "아주밝게";
			}
			else if(filterString.indexOf(BlendModeAdv.FOG) != -1 && filterString.indexOf(BlendMode.OVERLAY) != -1){
				return "뽀샤시";
			}
			else if(filterString.indexOf(BlendMode.NORMAL) != -1){
				return "원본";
			}
			return "";
		}

	}
}