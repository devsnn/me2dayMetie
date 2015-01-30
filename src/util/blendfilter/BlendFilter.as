package util.blendfilter
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	
	import mx.controls.Image;
	
	public class BlendFilter
	{
		
		private static var _instance:BlendFilter;
		
		private var softBitmap:Bitmap;
		private var screenBitmap:Bitmap;
		private var contrastBitmap:Bitmap;
		private var lightBitmap:Bitmap;
		
		private static const BLUR_MATRIX:Array = [0, 1, 2, 1, 0,
								 	1, 2, 4, 2, 1,
									2, 4, 8, 4, 2,
									0, 2, 4, 2, 1,
									0, 1, 2, 1, 0];
									
		
		public function BlendFilter()
		{
		}
		
		public static function getInstance():BlendFilter{
			if(_instance == null){
				_instance = new BlendFilter();
			}
			return _instance;
		}
		
		
		// filter 스트링으로 blendImageItem을 가져옵니다.
		/*
		public function getBlendImageItemFromFilterString(filterStr:String, image:Image, width:int, height:int, itemWidth:int, itemHeight:int):BlendImageItem{
			var blends:Array = BlendFilterPaser.toBlendArray(filterStr);
			var item:BlendImageItem = getBlendImageItem(image, blends, width, height);
			
			item.text = BlendName.getName(filterStr);
			
			item.width = itemWidth;
			item.height = itemHeight;
			
			return item;
		}
		*/
		
		public function getBlendImageItemFromFilterString(filterStr:String, bitmap:Bitmap):BlendImageItem{
			var blends:Array = BlendFilterPaser.toBlendArray(filterStr);
			var item:BlendImageItem = getBlendImageItem(bitmap, blends);
			
			item.text = BlendName.getName(filterStr);
			
			//item.width = itemWidth;
			//item.height = itemHeight;
			
			return item;
		}
		
		
		
		// filter string으로 bitmap을 가져옵니다..
		public function getBlendBitmapFromFilterString(filterStr:String, bitmap:Bitmap):Bitmap{
			var blends:Array = BlendFilterPaser.toBlendArray(filterStr);
			//var image:Image = new Image();
			//image.source = bitmap;

			var bitmap:Bitmap = getBlendBitmap(bitmap.bitmapData, blends, bitmap.width, bitmap.height);
		//	image = null;
			return bitmap;
		}
		
		
		
		
		private function imgSizeInit(img:Image, width:int, height:int):void{
			img.width = width;
			img.height = height;
			img.validateDisplayList();
		}
		
		/*
		private function getBlendImageItem(img:Image, blendModeArr:Array, width:int, height:int):BlendImageItem{
			var item:BlendImageItem = new BlendImageItem();
			item.imageSource = getBlendBitmap((img.source as Bitmap).bitmapData, blendModeArr, width, height);
			item.blendArr = blendModeArr;
			return item;
		}
		*/
		private function getBlendImageItem(bitmap:Bitmap, blendModeArr:Array):BlendImageItem{
			var item:BlendImageItem = new BlendImageItem();
			item.imageSource = getBlendBitmap(bitmap.bitmapData, blendModeArr, bitmap.width, bitmap.height);
			item.blendArr = blendModeArr;
			return item;
		}
		
		
		
		private var bitmap:Bitmap;
		
		public function getBlendBitmap(bitmapData:BitmapData, blendModeArr:Array, width:int, height:int):Bitmap{
			
			//var temp_imgW:int = img.width;
			//var temp_imgH:int = img.height;
			
			//imgSizeInit(img, width, height);
			
			
			bitmap = new Bitmap(getBitmapData(bitmapData, blendModeArr, width, height));
			
			//img.width = temp_imgW;
			//img.height = temp_imgH;
			
			
			return bitmap;
		}
		
		/*
		public function getBlendBitmap(img:Image, blendModeArr:Array, width:int, height:int):Bitmap{
			
			var temp_imgW:int = img.width;
			var temp_imgH:int = img.height;
			
			imgSizeInit(img, width, height);
			
			
			bitmap = new Bitmap(getBitmapData(img, blendModeArr, width, height));
			
			img.width = temp_imgW;
			img.height = temp_imgH;
			
			
			return bitmap;
		}
		*/
		
		
		private var bitmapData:BitmapData;
		private var blurBitmapData:BitmapData;
		private var fogBitmap:Bitmap;
		private var blurBitmap:Bitmap;
		
		private function getBitmapData(bitmapData:BitmapData, blendModeArr:Array, width:int, height:int):BitmapData{
			bitmapData = bitmapData.clone();
		
			
			
			var tempBitmapData:BitmapData = new BitmapData(width, height, false, 0xffffff);
			
			tempBitmapData.draw(bitmapData);
			
		
			
			var n:int = blendModeArr.length;
		
			var blurX:Number = 3;
			var blurY:Number = 3;
			var blurFilter:BlurFilter;
			
			for(var i:int=0; i<n; i++){
				// blur
				
				if(blendModeArr[i][0] == BlendModeAdv.FOG){
					try{
						blurX = blendModeArr[i][1];
						blurY = blendModeArr[i][2];
					}
					catch(e:Error){
						trace("error:", e.message);
					}
					
					blurFilter = new BlurFilter(blurX, blurY, 3);
					
					
					blurBitmapData = new BitmapData(width, height, true, 0xffffff);
					blurBitmapData.draw(bitmapData);
					blurBitmapData.draw(bitmapData, null, null, BlendMode.SCREEN);
					
					fogBitmap = new Bitmap(blurBitmapData);
					var cl:ColorMatrixFilter = new ColorMatrixFilter(BLUR_MATRIX);
					fogBitmap.filters = [blurFilter];
					
					bitmapData.draw(fogBitmap, null, null, BlendMode.SCREEN);
					blurBitmapData.dispose();
					fogBitmap.bitmapData.dispose();
					continue;
				}
				
				if(blendModeArr[i][0] == BlendModeAdv.BLUR){
					try{
						blurX = blendModeArr[i][1];
						blurY = blendModeArr[i][2];
					}
					catch(e:Error){
						trace("error:", e.message);
					}
					blurFilter = new BlurFilter(blurX, blurY, 3);
					
					blurBitmapData = new BitmapData(width, height, true, 0xffffff);
					blurBitmapData.draw(bitmapData);					
					
					blurBitmap = new Bitmap(blurBitmapData);
					
					blurBitmap.filters = [blurFilter];
					bitmapData.draw(blurBitmap);
					blurBitmap.bitmapData.dispose();
					continue;
					
				}
				
				// blendmode 효과적용..                                                             
				try{
							
					bitmapData.draw(tempBitmapData, null, null, blendModeArr[i][0], null, true);
					
				}
				catch(e:Error){
					trace("error:", e.message);
				}
			}
		
			
			//img.source = null;
			//img = null;
			tempBitmapData.dispose();
			
			//dispose();
			return bitmapData;
		}
		
		/*
		private function getBitmapData(img:Image, blendModeArr:Array, width:int, height:int):BitmapData{
			
			bitmapData = new BitmapData(width, height, false, 0xffffff);
			
			bitmapData.lock();
			
			var n:int = blendModeArr.length;
			bitmapData.draw(img);
			
			var blurX:Number = 3;
			var blurY:Number = 3;
			var blurFilter:BlurFilter;
			
			for(var i:int=0; i<n; i++){
				// blur
				
				if(blendModeArr[i][0] == BlendModeAdv.FOG){
					try{
						blurX = blendModeArr[i][1];
						blurY = blendModeArr[i][2];
					}
					catch(e:Error){
						trace("error:", e.message);
					}
					
					blurFilter = new BlurFilter(blurX, blurY, 3);
					
					
					blurBitmapData = new BitmapData(width, height, true, 0xffffff);
					blurBitmapData.draw(img);
					blurBitmapData.draw(img, null, null, BlendMode.SCREEN);
					
					fogBitmap = new Bitmap(blurBitmapData);
					var cl:ColorMatrixFilter = new ColorMatrixFilter(BLUR_MATRIX);
					fogBitmap.filters = [blurFilter];
					
					bitmapData.draw(fogBitmap, null, null, BlendMode.SCREEN);
					blurBitmapData.dispose();
					fogBitmap.bitmapData.dispose();
					continue;
				}
				
				if(blendModeArr[i][0] == BlendModeAdv.BLUR){
					try{
						blurX = blendModeArr[i][1];
						blurY = blendModeArr[i][2];
					}
					catch(e:Error){
						trace("error:", e.message);
					}
					blurFilter = new BlurFilter(blurX, blurY, 3);
				
				
					blurBitmap = new Bitmap(bitmapData);
	
					blurBitmap.filters = [blurFilter];
					bitmapData.draw(blurBitmap);
					blurBitmap.bitmapData.dispose();
					continue;
					
				}
				
				// blendmode 효과적용..                                                             
				try{
					bitmapData.draw(img, null, null, blendModeArr[i][0], null, true);
				}
				catch(e:Error){
					trace("error:", e.message);
				}
			}
			
			bitmapData.unlock();
			
			img.source = null;
			img = null;
			
			return bitmapData;
		}
		*/
		
		public static function dispose():void {
			BlendFilter.getInstance().dispose();
		}
		
		
		public function dispose():void {
			
			
			if(softBitmap != null && softBitmap.bitmapData != null){			
				softBitmap.bitmapData.dispose();		
				softBitmap.bitmapData = null;
				softBitmap = null;				
			}
			
			if(screenBitmap != null && screenBitmap.bitmapData != null){			
				screenBitmap.bitmapData.dispose();		
				screenBitmap.bitmapData = null;
				screenBitmap = null;				
			}
			
			if(contrastBitmap != null && contrastBitmap.bitmapData != null){			
				contrastBitmap.bitmapData.dispose();		
				contrastBitmap.bitmapData = null;
				contrastBitmap = null;				
			}
			
			if(lightBitmap != null && lightBitmap.bitmapData != null){			
				lightBitmap.bitmapData.dispose();		
				lightBitmap.bitmapData = null;
				lightBitmap = null;				
			}
			
			
			if(bitmapData != null){			
				bitmapData.dispose();		
				bitmapData = null;	
			}
			
			if(blurBitmapData != null){			
				blurBitmapData.dispose();		
				blurBitmapData = null;	
			}
			
			
			if(fogBitmap != null && fogBitmap.bitmapData != null){			
				fogBitmap.bitmapData.dispose();		
				fogBitmap.bitmapData = null;
				fogBitmap = null;				
			}
			
			
			if(blurBitmap != null && blurBitmap.bitmapData != null){			
				blurBitmap.bitmapData.dispose();		
				blurBitmap.bitmapData = null;
				blurBitmap = null;				
			}
			
		//	System.gc();
		}				

	}
}