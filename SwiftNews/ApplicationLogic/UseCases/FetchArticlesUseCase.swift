class FetchArticlesUseCase : FetchArticlesUseCaseInput {
    weak var output: FetchArticlesUseCaseOutput?
    private let articleService: ArticleService
    private let articleRepository: ArticleRepository
    
    init(articleService: ArticleService, articleRepository: ArticleRepository) {
        self.articleService = articleService
        self.articleRepository = articleRepository
    }
    
    func fetchArticles() {
        articleService.downloadArticlesWithCompletionHandler { (articles, error) -> Void in
            if let error = error {
                self.output?.fetchingArticlesFailedWithError(error)
            }
            else if let articles = articles {
                self.saveArticles(articles)
            }
        }
    }
    
    private func saveArticles(articles: [Article]) {
        for article in articles {
            saveArticle(article)
        }
    }
    
    private func saveArticle(article: Article) {
        if articleRepository.doesArticleExist(article) {
            articleRepository.saveArticle(article)
        }
    }
}
