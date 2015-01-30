package util
{
	import com.lhd.MeConnect;
	import com.lhd.events.MeConnectEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import header.PostRequester;
	
	import mx.core.Application;
	import mx.managers.PopUpManager;
	
	import panel.LoadingPanel;
	
	import response.Comment;
	import response.Post;

	public class FindCommentByPost extends EventDispatcher
	{
		
		
		private var comment_id:String;
		private var _comment:Comment;
		
		public var result_post:Post;
		private var result_post_id:String;
		private var resultXMLList:XMLList;
		
		private var connect:MeConnect = new MeConnect();
		
		public function FindCommentByPost()
		{
		}
		
		public function get comment():Comment
		{
			return _comment;
		}

		public function set comment(value:Comment):void
		{
			_comment = value;
			getCommentByPost();
		}
		
		private var loadingPanel:LoadingPanel;
		
		private function addLoadingPopup():void{
			if(loadingPanel == null){
				loadingPanel = new LoadingPanel();
				PopUpManager.addPopUp(loadingPanel, Application.application.document as DisplayObject);
				PopUpManager.centerPopUp(loadingPanel);
			}
		}
		
		
		private function removeLoadingPopup():void{
			var timer:Timer = new Timer(500, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, loading_timerCompleteHandler);
			timer.start();
		}
		
		private function loading_timerCompleteHandler(e:TimerEvent):void{
			var timer:Timer = e.target as Timer;
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, loading_timerCompleteHandler);
			
			if(loadingPanel){
				PopUpManager.removePopUp(loadingPanel);
				loadingPanel = null;
			}
		}
		
		
		private function getCommentByPost():void{
			
			comment_id = comment.comment_id;
			var permalink:String = MetieUtil.getPermalink(comment.author.id, comment.pubDate);
			
			var postReq:PostRequester;
			
			if(comment.post_id){
				// 포스트 아이디로 가져옵니다..(형식이 올바른 녀석을 가져오기 위해..)
				postReq = new PostRequester(comment.post_id);
			}
			else{
				// 작성자의 포스트중에서 오리지널 포스트를 찾습니다..
				postReq = new PostRequester(null, null, permalink, 20);
			}
			
			postReq.addEventListener(Event.COMPLETE, post_resultHandler);
			addLoadingPopup();
		}
		
		
		private function post_resultHandler(e:Event):void{
			var postReq:PostRequester = e.target as PostRequester;
			
			resultXMLList = postReq.resultXMLList;
			
			if(resultXMLList){
				findComment();
			}
			else{
				removeLoadingPopup();
				this.dispatchEvent(new Event("notfind_comment"));
			}
		}
		
		
		private function findComment():void{
			if(resultXMLList && resultXMLList.length() > 0){
				getComment(resultXMLList[0].post_id);
			}
			else{
				if(!isMyPost){
					trace("나의 포스트중에서 찾습니다.");
					findMypost();
					return;
				}
				removeLoadingPopup();
				this.dispatchEvent(new Event("notfind_comment"));
			}
		}
		
		
		
		private function getComment(post_id:String):void{
			connect.addEventListener(MeConnectEvent.ON_FAULT, comment_faultHandler);
			connect.addEventListener(MeConnectEvent.GETCOMMENTS_RESULT, comment_resultHandler);
			connect.getcomments(post_id);
		}
		
		
		private function comment_faultHandler(e:MeConnectEvent):void{
			connect.removeEventListener(MeConnectEvent.ON_FAULT, comment_faultHandler);
			delete resultXMLList[0];
			findComment();
		}
		
		private var comments:XMLList;
		
		private function comment_resultHandler(e:MeConnectEvent):void{
			connect.removeEventListener(MeConnectEvent.GETCOMMENTS_RESULT, comment_resultHandler);
			
			comments = new XMLList(e.data.comment);
			var findit:Boolean = false;
			if(comments){
				for(var i:int=0; i<comments.length(); i++){
					if(comment_id == comments[i].commentId){
						findit = true;
						result_post = new Post(resultXMLList[0]);
						removeLoadingPopup();
						this.dispatchEvent(new Event("find_comment"));
						return;
					}
				}
			}
			
			if(comment.post_id){
				removeLoadingPopup();
				this.dispatchEvent(new Event("notfind_comment"));
				return;
			}
			
			delete resultXMLList[0];
			findComment();
		}
		
		
		// 나의 포스트중에서 오리지널 포스트를 찾습니다.
		private function findMypost():void{
			connect = new MeConnect();
			connect.addEventListener(MeConnectEvent.GETPOSTS_RESULT, mypost_resultHandler);
			connect.getposts(MeConnect.POST_MY, 20);
		}
		
		
		private var isMyPost:Boolean = false;
		
		private function mypost_resultHandler(e:MeConnectEvent):void{
			isMyPost = true;
			resultXMLList = new XMLList(e.data.post);
			findComment();
		}
		
	}
}