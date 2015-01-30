package comp.alertwindow
{
	import comp.TodayTileListItemRenderer;
	
	import flash.system.System;
	
	import mx.collections.XMLListCollection;
	import mx.containers.VBox;
	
	import response.Comment;
	import response.Post;
	
	public class NewItemBox extends VBox
	{
		
		public var newItemXMLListCol:XMLListCollection;
		
		private var itemR:TodayTileListItemRenderer;
		
		public function NewItemBox()
		{
			super();
			this.percentWidth = 100;
		}
		
		
		public function addComment(value:Object):void{
			if(newItemXMLListCol == null){
				newItemXMLListCol = new XMLListCollection();
			}
			
			// 계속 늘어남을 방지...
			if(newItemXMLListCol.length > 20){
				newItemXMLListCol.removeItemAt(newItemXMLListCol.length-1);
				this.removeChildAt(newItemXMLListCol.length-1);
			}
			newItemXMLListCol.addItemAt(value, 0);
			
			itemR = new TodayTileListItemRenderer();
			itemR.comment = new Comment(value);
			
			this.addChildAt(itemR, 0);
		}
		
		public function addPost(value:Object):void{
			if(newItemXMLListCol == null){
				newItemXMLListCol = new XMLListCollection();
			}
			
			// 계속 늘어남을 방지...
			if(newItemXMLListCol.length > 20){
				newItemXMLListCol.removeItemAt(newItemXMLListCol.length-1);
				this.removeChildAt(newItemXMLListCol.length-1);
			}
			newItemXMLListCol.addItemAt(value, 0);
			
			itemR = new TodayTileListItemRenderer();
			itemR.post = new Post(value);
			
			this.addChildAt(itemR, 0);
		}
		
		
		public function reset():void{
			this.removeAllChildren();
			newItemXMLListCol = null;
		}
			
	}
}