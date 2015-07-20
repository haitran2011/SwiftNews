class GoogleNewsUrlRequest : ArticleUrlRequest {
    func urlRequestForFetchingArticles() -> NSURLRequest? {
        if let url = NSURL(string: "https://news.google.com/?output=rss") {
            return NSURLRequest(URL: url)
        }
        
        return nil
    }
}
