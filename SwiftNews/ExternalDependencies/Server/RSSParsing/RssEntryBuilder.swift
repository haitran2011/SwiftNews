import Foundation

class RssEntryBuilder {
    func buildRssEntriesFromFeedData(feedData: NSData, errorPointer: NSErrorPointer) -> [RssEntry]? {
        if let document = GDataXMLDocument(data: feedData, encoding: NSUTF8StringEncoding, error: errorPointer) {
            return parseRssEntriesFromXmlDocument(document)
        }
        
        return nil
    }
    
    private func parseRssEntriesFromXmlDocument(xmlDocument: GDataXMLDocument) -> [RssEntry] {
        var allRssEntries = [RssEntry]()
        let rootElement = xmlDocument.rootElement()
        let channels = rootElement.elementsForName("channel")
        
        for channel in channels {
            let entries = parseRssEntriesFromChannel(channel as! GDataXMLElement)
            for entry in entries {
                allRssEntries.append(entry)
            }
        }
        
        return allRssEntries
    }
    
    private func parseRssEntriesFromChannel(channel: GDataXMLElement) -> [RssEntry] {
        var rssEntriesInChannel = [RssEntry]()
        let items = channel.elementsForName("item")
        
        for item in items {
            let rssEntry = createRssEntryFromItem(item as! GDataXMLElement)
            rssEntriesInChannel.append(rssEntry)
        }
        
        return rssEntriesInChannel
    }
    
    private func createRssEntryFromItem(item: GDataXMLElement) -> RssEntry {
        let rssEntry = RssEntry()
        rssEntry.guid = item.valueForChild("guid")
        rssEntry.title = item.valueForChild("title")
        rssEntry.link = item.valueForChild("link")
        rssEntry.summary = item.valueForChild("description")
        rssEntry.pubDate = item.valueForChild("pubDate")
        return rssEntry
    }
}
