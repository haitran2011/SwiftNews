class ArticleApiClient : ArticleService {
    
    private let articleUrlRequest: ArticleUrlRequest
    private let networkCommunicator: NetworkCommunicator
    private let articleBuilder: AbstractArticleBuilder
    private var completionHandler: (([Article]?, NSError?) -> Void)?
    
    init(articleUrlRequest: ArticleUrlRequest,
        networkCommunicator: NetworkCommunicator,
        articleBuilder: AbstractArticleBuilder)
    {
        self.articleUrlRequest = articleUrlRequest
        self.networkCommunicator = networkCommunicator
        self.articleBuilder = articleBuilder
    }
    
    func downloadArticlesWithCompletionHandler(completionHandler: ([Article]?, NSError?) -> Void) {
        self.completionHandler = completionHandler
        
        if let request = articleUrlRequest.urlRequestForFetchingArticles() {
            self.performRequest(request)
        }
    }
    
    private func performRequest(request: NSURLRequest) {
        networkCommunicator.performRequest(request) { (data, error) -> Void in
            if let error = error {
                self.notifyCallerWithError(error)
            }
            else if let data = data {
                self.buildArticlesFromFeedData(data)
            }
        }
    }
    
    private func notifyCallerWithError(error: NSError) {
        if let handler = completionHandler {
            handler(nil, error)
        }
    }
    
    private func buildArticlesFromFeedData(feedData: NSData) {
        var error: NSError?
        
        if let articles = articleBuilder.buildArticlesFromRssData(feedData, errorPointer: &error) {
            notifyCallerWithArticles(articles)
        }
        else if let error = error {
            notifyCallerWithError(error)
        }
    }
    
    private func notifyCallerWithArticles(articles: [Article]) {
        if let handler = completionHandler {
            handler(articles, nil)
        }
    }
}
