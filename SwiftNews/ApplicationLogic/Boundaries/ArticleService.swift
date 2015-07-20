import Foundation

protocol ArticleService {
    func downloadArticlesWithCompletionHandler(completionHandler: ([Article]?, NSError?) -> Void)
}
