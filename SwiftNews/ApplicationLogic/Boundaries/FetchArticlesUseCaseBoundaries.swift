import Foundation

protocol FetchArticlesUseCaseOutput: class {
    func didReceiveArticles(articles: [Article])
    func fetchingArticlesFailedWithError(error: NSError)
}

protocol FetchArticlesUseCaseInput {
    weak var output: FetchArticlesUseCaseOutput? { get set }
    func fetchArticles()
}
