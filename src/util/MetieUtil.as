package util
{
	public class MetieUtil
	{
		public function MetieUtil()
		{
		}
		
		
		public static function getPermalink(user_id:String, pubDate:String):String{
			var re:String = "http://me2day.net/"+user_id+"/";
			
			var times:Array = pubDate.split("T");
			var days:Array;
			if(times && times.length >= 2){
				days = String(times[0]).split("-");
			}
			
			var hours:String = times[1];
			hours = hours.substring(0, hours.lastIndexOf("+"));
			
			re += days[0]+"/"+days[1]+"/"+days[2]+"#"+hours;
			
			return re;
		}
		
		
		public static function getPostid(linktext:String):String{
			return linktext.substring(linktext.indexOf("post_id:")+8, linktext.lastIndexOf(":post_id"));
		}
		
		
		public static function ahrefLinkReplace(text:String):String{
			var re_text:String = text;
			if(text){
				re_text = re_text.replace(new RegExp("<a href='", "g"), "<font color='#3577BB'><b><a href='event:");
				re_text = re_text.replace(new RegExp("</a>", "g"), "</a></b></font>");
			}
			return re_text;
		}
		
		public static function getDateAgo(pubDate:String):String{
			// 2010-02-11T21:46:52+0900
			//trace("date:", pubDate);
			var day:String = pubDate.substring(0, pubDate.indexOf("T"));
			var time:String;
			var day_arr:Array = day.split("-");
			
			var gmt_time:String;
			var isPlus:Boolean = false;
			
			if(pubDate.indexOf("+") != -1){
				time = pubDate.substring(pubDate.indexOf("T")+1, pubDate.lastIndexOf("+"));
				gmt_time = pubDate.substring(pubDate.lastIndexOf("+")+1, pubDate.length);
				isPlus = true;
			}
			else{
				time = pubDate.substring(pubDate.indexOf("T")+1, pubDate.lastIndexOf("-"));
				gmt_time = pubDate.substring(pubDate.lastIndexOf("-")+1, pubDate.length);
			}
			
			var time_arr:Array = time.split(":");
			
			
			
			var gmt_kor:String = "";
			
			if(gmt_time != "0900"){
				var gmt_time_number:Number = Number(gmt_time); 
				
				var balance:String;
				if(gmt_time_number > 0900){
					balance = (gmt_time_number - 0900).toString();
				}
				else{
					balance = (0900 - gmt_time_number).toString();
				}
				
				/*if(isPlus){
					trace("time[0] 1", time_arr[0], Math.floor(Number(balance)));
					time_arr[0] = (Number(time_arr[0]) + Number(balance.substr(0, 1))).toString();
				}
				else{
					time_arr[0] = (Number(time_arr[0]) - Number(balance.substr(0, 1))).toString();
				}*/
				gmt_kor = "";
				
				//return gmt_kor+time+" "+gmt_time;
				return pubDate.substring(pubDate.lastIndexOf("T")+1, pubDate.length);
			}
			
			
			
			var now_date:Date = new Date();
			var date:Date = new Date(day_arr[0], day_arr[1], day_arr[2], time_arr[0], time_arr[1], time_arr[2]);
			
			
			return gmt_kor + checkDate(now_date, date);
			/*if(now_date.fullYear - date.fullYear > 0){
				if(now_date.fullYear - date.fullYear == 1 && (12 - date.month) + now_date.month < 12){
					if((12-date.month) + now_date.month == 1 && (31 - date.date) + now_date.date < 31){
						return ((31 - date.date) + now_date.date).toString() + "일전";
					}
					return ((12 - date.month) + now_date.month).toString() + "달전";
				}
				return (now_date.fullYear - date.fullYear).toString() + "년전";
			}
			else if((now_date.month+1) - date.month > 0){
				if((now_date.month+1) - date.month == 1 && (31 - date.date) + now_date.date < 31){
					if((31-date.date) + now_date.date == 1 && (24-date.hours) + now_date.hours < 12){
						return ((24 - date.hours) + now_date.hours).toString() + "시간전";
					}
					return ((31 - date.date) + now_date.date).toString() + "일전";
				}
				return ((now_date.month+1) - date.month).toString() + "달전";
			}
			else if(now_date.date - date.date > 0){
				if(now_date.date - date.date == 1 && (24-date.hours) + now_date.hours < 12){
					if((24-date.hours) + now_date.hours == 1 && (60-date.minutes) + now_date.minutes < 60){
						return ((60 - date.minutes) + now_date.minutes).toString() + "분전";
					}
					return ((24 - date.hours) + now_date.hours).toString() + "시간전";
				}
				return (now_date.date - date.date).toString() + "일전";
			}
			else if(now_date.hours - date.hours > 0){
				if(now_date.hours - date.hours  == 1 && (60-date.minutes) + now_date.minutes < 60){
					return ((60 - date.minutes) + now_date.minutes).toString() + "분전";
				}
				return (now_date.hours - date.hours).toString() + "시간전";
			}
			else if(now_date.minutes - date.minutes > 0){
				return (now_date.minutes - date.minutes).toString() + "분전";
			}
			else{
				return "지금막";
			}
			
			return "";*/
		}
		
		
		private static function checkDate(now_date:Date, write_date:Date):String{
			if(now_date.fullYear - write_date.fullYear == 1 && (12-write_date.fullYear) + now_date.fullYear <= 12){
				return ((12-write_date.fullYear) + now_date.fullYear).toString() + "달전";
			}
			else if(now_date.fullYear - write_date.fullYear == 0){
				return checkMonth(now_date, write_date);
			}
			
			return (now_date.fullYear - write_date.fullYear).toString() + "년전";
		}
		
		
		private static function checkMonth(now_date:Date, write_date:Date):String{
			if((now_date.month+1) - write_date.month  == 1 && (31-write_date.date) + now_date.date <= 31){
				return ((31-write_date.date) + now_date.date).toString() + "일전";
			}
			else if((now_date.month+1) - write_date.month == 0){
				return checkDay(now_date, write_date);
			}
			
			return ((now_date.month+1) - write_date.month).toString() + "달전";
		}
		
		
		private static function checkDay(now_date:Date, write_date:Date):String{
			if(now_date.date - write_date.date == 1 && (24-write_date.hours) + now_date.hours <= 24){
				return ((24-write_date.hours) + now_date.hours).toString() + "시간전";
			}
			else if(now_date.date - write_date.date == 0){
				return checkHousrs(now_date, write_date);
			}
			return (now_date.date - write_date.date).toString() + "일전";
		}
		
		
		private static function checkHousrs(now_date:Date, write_date:Date):String{
			if(now_date.hours - write_date.hours  == 1 && (60-write_date.minutes) + now_date.minutes <= 60){
				return ((60-write_date.minutes) + now_date.minutes).toString() + "분전";
			}
			else if(now_date.hours - write_date.hours == 0){
				return checkMin(now_date, write_date);
			}
			return (now_date.hours - write_date.hours).toString() + "시간전";
		}
		
		
		private static function checkMin(now_date:Date, write_date:Date):String{
			if(now_date.minutes - write_date.minutes > 1){
				return (now_date.minutes - write_date.minutes).toString() + "분전";
			}
			
			return "지금막";
		}
	}
}