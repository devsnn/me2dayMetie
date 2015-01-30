package tools.listtool
{
	import com.lhd.MeConnect;
	import com.lhd.events.MeConnectEvent;
	
	import comp.*;
	import comp.alertwindow.*;
	
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.collections.XMLListCollection;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.List;
	import mx.core.ClassFactory;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import panel.LoadingPanel;
	
	import util.UserSetting;
	
	public class ItemListVbox extends VBox implements IItemList
	{
		
		private var posts:XMLListCollection;
		
		private var _post_type:String;
		private var post_count:Number = 20;
		private var offset:Number = 0;
		private var _isCreate:Boolean = false;
		
		private var isRequest:Boolean = false;
		
		private var connect:MeConnect;
		
		private var wid:Number;
		private var hei:Number;
		
		public var to_user_id:String;
		
		private var list:List;
		
		public function ItemListVbox(_wid:Number=398, _hei:Number=595)
		{
			super();
			wid = _wid;
			hei = _hei;
			this.addEventListener(FlexEvent.CREATION_COMPLETE, create);
		}

		public function get post_type():String
		{
			return _post_type;
		}

		public function set post_type(value:String):void
		{
			_post_type = value;
			
			post_count = 20;
			
			if(value == MeConnect.POST_TOUSER || value == MeConnect.POST_MENTIONED){
				post_count = 10;
			}
			
			request();
			
		}
		
		private function create(e:FlexEvent):void{
			_isCreate = true;
			resizeInit();
		}
		
		public function resize(_wid:Number, _hei:Number):void{
			wid = _wid;
			hei = _hei;
			resizeInit();
		}
		
		
		private function resizeInit():void{
			this.height = hei;
			this.width = wid;
		}
		
		
		public function refresh():void{
			request(true);
		}
		
		
		private function request(_refresh:Boolean=false, _offset:Number=0):void{
			if(isRequest){
				trace("이미 request중..");
				return;
			}
			isRequest = true;
			if(_isCreate){
				addLoadingPopup();
			}
			
			if(connect == null){
				connect = new MeConnect();
			}
			connect.addEventListener(MeConnectEvent.GETPOSTS_RESULT, result_postsHandler);
			
			if(MeConnect.POST_TOUSER == post_type){
				connect.getposts(post_type, post_count, _offset, to_user_id);
			}
			else{
				connect.getposts(post_type, post_count, _offset);
			}
			
			
		}
		
		
		private var postXMLList:XMLList;
		private var commentXMLList:XMLList;
		
		private var pubDateSort:Sort;
		
		
		private function result_postsHandler(e:MeConnectEvent):void{
			if(!connect){
				return;
			}
			connect.removeEventListener(MeConnectEvent.GETPOSTS_RESULT, result_postsHandler);
			
			
			postXMLList = (e.data.post as XMLList);
			commentXMLList = (e.data.comment as XMLList);
			
			if(pubDateSort == null){
				pubDateSort = new Sort();
				pubDateSort.fields = [new SortField("pubDate", false, true)];
				
			}
			
			var resultList:XMLListCollection = new XMLListCollection((postXMLList + commentXMLList) as XMLList); 
			resultList.sort = pubDateSort;
			resultList.refresh();
			
			posts = resultList; 
			
			createItem();
			
			isRequest = false;
		}
		
		
		
		// 더보기 클릭..
		private function more_clickHandler():void{
			//post_count += 20;
			//offset += post_count;
			//request(true, offset);
			Alert.show("미투데이 사이트로 연결하시겠습니까?", "알림", Alert.OK+Alert.CANCEL, this, more_closeHandler);
		}
		
		
		private function more_closeHandler(e:CloseEvent):void{
			if(e.detail == Alert.OK){
				navigateToURL(new URLRequest("http://me2day.net/"+UserSetting.user_id+"/stream"), "_blank");
			}
		}
		
		
		
		
		private var loadingPanel:LoadingPanel;
		
		private function addLoadingPopup():void{
			/*if(loadingPanel == null){
				loadingPanel = new LoadingPanel();
			}
			PopUpManager.addPopUp(loadingPanel, this);
			PopUpManager.centerPopUp(loadingPanel);*/
		}
		
		
		private function removeLoadingPopup():void{
			/*var timer:Timer = new Timer(500, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, loading_timerCompleteHandler);
			timer.start();*/
		}
		
		private function loading_timerCompleteHandler(e:TimerEvent):void{
			var timer:Timer = e.target as Timer;
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, loading_timerCompleteHandler);
			timer = null;
			
			if(loadingPanel){
				PopUpManager.removePopUp(loadingPanel);
			}
		}
		
		
		private function write_completeHandler():void{
			var timer:Timer = new Timer(1000, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, write_timerCompleteHandler);
			timer.start();
		}
		
		
		private function write_timerCompleteHandler(e:TimerEvent):void{
			var timer:Timer = e.target as Timer;
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, write_completeHandler);
			timer = null;
			
			refresh();
		}
		
		
		// 아이템을 삭제..
		public function destory():void{
			if(this.getChildren().length > 2){ 
				for(var i:int=getChildren().length-1; i>0; i--){
					var dis:TodayTileListItemRenderer = (getChildAt(i) as TodayTileListItemRenderer);
					if(dis){
						dis.destory();
						dis = null;
					}
				}
			}
			connect.destory();
			connect = null;
			posts = null;
			loadingPanel = null;
			
			this.removeAllChildren();
		}
		
		
		public function refreshCehck():void{
			refresh();
		}
		
		
		// 아이템을 생성합니다...
		private function createItem():void{
			if(list == null){
				list = new List();
				list.percentHeight = 100;
				list.percentWidth = 100;
				list.itemRenderer = new ClassFactory(TodayTileListItemRenderer);
				list.variableRowHeight = true;
				this.addChild(list);
			}
			
			list.dataProvider = posts;
			
			/*var itemR:TodayTileListItemRenderer;
			
			for(var i:int=0; i<posts.length; i++){
				itemR = new TodayTileListItemRenderer();
				itemR.itemObj = posts[i];
				this.addChild(itemR);
			}
			
			removeLoadingPopup();*/
		}
		

	}
}