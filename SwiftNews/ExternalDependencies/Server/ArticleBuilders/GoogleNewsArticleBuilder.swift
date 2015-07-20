class GoogleNewsArticleBuilder : AbstractArticleBuilder {
    
    // MARK: - Creating articles
    
    override func createArticleFromRssEntry(rssEntry: RssEntry) -> Article {
        let article = Article()
        article.uniqueId = rssEntry.guid
        
        return article
    }
    
    // MARK: - Extracting title
    
    private func extractRealTitleFromTitle(title: String) -> String {
        if let separatorRange = title.rangeOfString(" - ") {
            return title.substringToIndex(separatorRange.startIndex)
        }
        
        return title
    }
    
    // MARK: - Extracting publisher
    
    private func extractPublisherFromTitle(title: String) -> String? {
        if let separatorRange = title.rangeOfString(" - ") {
            return title.substringFromIndex(separatorRange.startIndex)
        }
        
        return nil
    }
    
    // MARK: - Extracting source url
    
    private func sourceUrlFromRssLink(rssLink: String) -> String? {
        if let urlComponents = NSURLComponents(string: rssLink),
            queryItems = urlComponents.queryItems
        {
            return extractUrlFromQueryItems(queryItems)
        }
        
        return nil
    }
    
    private func extractUrlFromQueryItems(queryItems: [AnyObject]) -> String? {
        for queryItem in queryItems as! [NSURLQueryItem] {
            if queryItem.name == "url" {
                return queryItem.value!
            }
        }
        
        return nil
    }
    
    // MARK: - Extracting image url
    
    private func imageUrlFromSummary(summary: String) -> String? {
        let document = GDataXMLDocument(HTMLString: summary, error: nil)
        let imageNodes = document.nodesForXPath("//img", error: nil)
        
        for imageNode in imageNodes as! [GDataXMLNode] {
            return buildImageUrlFromImageNode(imageNode)
        }
        
        return nil
    }
    
    private func buildImageUrlFromImageNode(imageNode: GDataXMLNode) -> String? {
        if let xmlElement = imageNode as? GDataXMLElement,
            imageSourceAttribute = xmlElement.attributeForName("src")
        {
            return "http:".stringByAppendingString(imageSourceAttribute.stringValue())
        }
        
        return nil
    }
}
