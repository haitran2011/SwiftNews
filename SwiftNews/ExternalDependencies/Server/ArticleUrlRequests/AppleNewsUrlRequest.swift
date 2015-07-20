class AppleNewsUrlRequest : ArticleUrlRequest {    
    func urlRequestForFetchingArticles() -> NSURLRequest? {
        if let url = NSURL(string: "https://www.apple.com/main/rss/hotnews/hotnews.rss") {
            return NSURLRequest(URL: url)
        }
        
        return nil
    }
}
