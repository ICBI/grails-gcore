import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

class FeedService{
	
	def getFeed(){
		def feedMap = [:]
		def feedURL = ""
		try{
			feedURL = CH.config.grails.feedURL
			if(feedURL){
		    	def xmlFeed = new XmlParser().parse(feedURL);
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
			}
		}catch (Exception e){
			log.debug "error parsing URL $feedURL, possible that URL is down - $e"
		}
	   return feedMap
	}
	
}