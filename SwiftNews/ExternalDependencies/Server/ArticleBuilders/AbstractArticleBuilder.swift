import Foundation

let ArticleBuilderErrorDomain = "ArticleBuilderErrorDomain"

enum ArticleBuilderErrorCode : Int {
    case InvalidFeedFormat
}

class AbstractArticleBuilder {
    private let rssEntryBuilder: RssEntryBuilder
    
    init(rssEntryBuilder: RssEntryBuilder) {
        self.rssEntryBuilder = rssEntryBuilder
    }
    
    func buildArticlesFromRssData(rssData: NSData, errorPointer: NSErrorPointer) -> [Article]? {
        if let rssEntries = rssEntryBuilder.buildRssEntriesFromFeedData(rssData, errorPointer: errorPointer) {
            return createArticlesFromRssEntries(rssEntries)
        }
        
        errorPointer.memory = invalidFeedFormatError()
        return nil
    }
    
    private func invalidFeedFormatError() -> NSError {
        let errorMessage = NSLocalizedString("Failed to parse RSS feed. Please make sure the format is correct.", comment:"")
        let userInfo = [NSLocalizedDescriptionKey : errorMessage]
        return NSError(domain: ArticleBuilderErrorDomain,
            code: ArticleBuilderErrorCode.InvalidFeedFormat.rawValue,
            userInfo: userInfo)
    }
    
    private func createArticlesFromRssEntries(rssEntries: [RssEntry]) -> [Article] {
        var articles = [Article]()
        
        for rssEntry in rssEntries {
            let article = createArticleFromRssEntry(rssEntry)
            articles.append(article)
        }
        
        return articles
    }
    
    func createArticleFromRssEntry(rssEntry: RssEntry) -> Article {
        preconditionFailure("Subclass must override createArticleFromRssEntry method")
    }
}
