package response
{
	public class Post
	{
		
		public var post_id:String;
		public var permalink:String;
		public var body:String;
		public var kind:String;
		public var icon:String;
		public var tagText:String;
		public var pubDate:String;
		public var commentsCount:String;
		public var commentIndex:String;
		public var metooCount:String;
		public var commentClosed:String;
		public var contentType:String;
		public var callbackUrl:String;
		public var iconUrl:String;
		
		public var author:Author;
		
		public var photoId:String;
		public var photoUrl:String;
		
		public var origin_post:Post;
		
		
		public function Post(item:Object)
		{
			if(item){
				post_id = item.post_id;
				permalink = item.permalink;
				body = item.body;
				kind = item.kind;
				icon = item.icon;
				tagText = item.tagText;
				pubDate = item.pubDate;
				commentsCount = item.commentsCount;
				commentIndex = item.commentIndex;
				metooCount = item.metooCount;
				commentClosed = item.commentClosed;
				contentType = item.contentType;
				callbackUrl = item.callbackUrl;
				iconUrl = item.iconUrl;
				
				author = new Author(item.author);
				
				
				photoId = item.media.me2photo.photoId;
				photoUrl = item.media.me2photo.photoUrl;
				
				if(item.origin_post && String(item.origin_post).length > 0){
					origin_post = new Post(item.origin_post);
				}
			}
			
		}
	}
}