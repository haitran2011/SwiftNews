class AppleNewsArticleBuilder : AbstractArticleBuilder {
    
    // MARK: - Creating articles
    
    override func createArticleFromRssEntry(rssEntry: RssEntry) -> Article {
        let article = Article()
        
        article.uniqueId = (rssEntry.guid != nil) ? rssEntry.guid : rssEntry.link
        article.title = rssEntry.title;
        article.summary = rssEntry.summary;
        article.sourceUrl = rssEntry.link;
        article.publishedDate = NSDate(fromInternetDateTimeString: rssEntry.pubDate, formatHint: DateFormatHintRFC822)
        
        if let sourceUrl = article.sourceUrl {
            article.publisher = domainNameFromSourceUrl(sourceUrl)
        }

        return article
    }
    
    // MARK: - Extracting publisher info
    
    private func domainNameFromSourceUrl(sourceUrl: String) -> String? {
        if let urlComponents = NSURLComponents(string: sourceUrl),
            host = urlComponents.host
        {
            let hostWithoutWWW = removeWWWFromHost(host)
            return removeDotComFromHost(hostWithoutWWW)
        }
        
        return nil
    }
    
    private func removeWWWFromHost(host: String) -> String {
        let stringToRemove = "www."
        
        if let range = host.rangeOfString(stringToRemove) {
            return host.substringFromIndex(range.endIndex)
        }
        
        return host
    }
    
    private func removeDotComFromHost(host: String) -> String {
        let dotCom = ".com"
        
        if let range = host.rangeOfString(dotCom) {
            return host.substringToIndex(range.startIndex)
        }
        
        return host
    }
}
