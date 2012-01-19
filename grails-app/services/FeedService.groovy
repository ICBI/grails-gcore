
class FeedService{
	
	def getFeed(feedURL){
		def feedMap = [:]
		try{
			if(feedURL){
		    	def xmlFeed = new XmlParser().parse(feedURL);
				if(xmlFeed.entry){
					log.debug "read atom feed"
					if(xmlFeed.entry ){
						int i = 0
						xmlFeed.entry.each{
							if(i < 10){
								def newsItem = it;
								//def date = String.format('%tF', newsItem.pubDate.text)
								feedMap.put(newsItem.title.text(),newsItem.link.@href[0])
								i++;
							}
						}

					 }
				}else if(xmlFeed.channel){
					log.debug "read rss feed"
					if(xmlFeed.channel && xmlFeed.channel.item){
						int i = 0
						xmlFeed.channel.item.each{
							if(i < 10){
								def newsItem = it;
								//def date = String.format('%tF', newsItem.pubDate.text)
								feedMap.put(newsItem.title.text(),newsItem.link.text())
								i++;
							}
						}

					 }
				}
					 
			}
		}catch (Exception e){
			log.debug "error parsing URL $feedURL, possible that URL is down - $e"
		}
	   return feedMap
	}
	
}