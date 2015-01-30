package util.blendfilter
{
	
	public class BlendFilterPaser
	{
		
		// blur|5|5+overlay
		public static function toBlendArray(filter:String):Array{
			
			var blendArray:Array = [];
			var filterArr:Array = filter.split("+");
			
			for(var i:int=0; i<filterArr.length; i++){
				blendArray[i] = new Array();
				var paramArr:Array = String(filterArr[i]).split("|");
				for(var j:int=0; j<paramArr.length; j++){
					blendArray[i][j] = paramArr[j];
				}
				
			}
			return blendArray;
			
		}
		
		
		
		public static function toFilterString(blendArray:Array):String{
			var returnStr:String = "";
			
			for each(var item:Array in blendArray){
				if(returnStr != ""){
					returnStr += "+";
				}
				
				var params:String = "";
				
				for each(var param:String in item){
					if(params != ""){
						params += "|";
					}
					params += param;
				}
				
				returnStr += params;
			}
			
			return returnStr;
		}

	}
}