class FeedService{
	
	def getFeed(){
		def feedMap = [:]
		try{
			def xmlFeed = new XmlParser().parse("http://views.georgetown.edu/?ViewID=1143")
		    //def xmlFeed = new XmlParser().parse("https://informatics.lombardi.georgetown.edu/spaces/createrssfeed.action?types=blogpost&spaces=public&sort=modified&title=public+Recent+News+Items&maxResults=15&publicFeed=true&rssType=rss2");
			feedMap = [:]
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
		}catch (Exception e){
			log.debug "error parsing URL http://views.georgetown.edu/?ViewID=1143, possible that URL is down - $e"
		}
	   return feedMap
	}
	
}