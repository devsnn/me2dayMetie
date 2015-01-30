package response
{
	public class Person
	{
		
		public var user_id:String;
		public var openid:String;
		public var nickname:String;
		public var face:String;
		public var email:String;
		public var cellphone:String;
		public var description:String;
		
		public var postIcons:XMLList;
		
		public var flickr:String;
		
		public var homepage:String;
		public var me2dayHome:String;
		public var rssDaily:String;
		public var invitedBy:String;
		public var friendsCount:String;
		public var pinMeCount:String;
		public var totalPosts:String;
		public var updated:String;
		
		public function Person(item:Object)
		{
			user_id = item.id;
			openid = item.openid;
			nickname = item.nickname;
			face = item.face;
			email = item.email;
			cellphone = item.cellphone;
			description = item.description;
			
			if(item.postIcons){
				postIcons = new XMLList(item.postIcons);
			}
			
			flickr = item.flickr;
			
			homepage = item.homepage;
			me2dayHome = item.me2dayHome;
			rssDaily = item.rssDaily;
			invitedBy = item.invitedBy;
			friendsCount = item.friendsCount;
			pinMeCount = item.pinMeCount;
			totalPosts = item.totalPosts;
			updated = item.updated;
		}
	}
}