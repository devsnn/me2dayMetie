package response
{
	public class Comment
	{
		
		public var comment_id:String;
		public var body:String;
		public var pubDate:String;
		
		public var post:Post;
		public var author:Author;

		
		public var post_id:String; // 포스트 아이디가 있을 경우
		public var postPermalink:String; // 링크가 있을 경우..
		
		
		public function Comment(item:Object)
		{
			comment_id = item.commentId;
			body = item.body;
			pubDate = item.pubDate;
			
			if(item.author){
				author = new Author(item.author);
			}
			
			if(item.post){
				post = new Post(item.post);
			}
			
		}
	}
}