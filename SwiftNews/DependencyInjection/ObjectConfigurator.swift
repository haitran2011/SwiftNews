class ObjectConfigurator {
    static let sharedInstance = ObjectConfigurator()
    
    // MARK: - Configuring use case objects
    
    func fetchArticlesUseCase() -> FetchArticlesUseCase {
        return FetchArticlesUseCase(articleService: articleApiClient(), articleRepository: articleCoreDataManager())
    }
    
    // MARK: - Configuring server objects
    
    func articleApiClient() -> ArticleApiClient {
        return ArticleApiClient(articleUrlRequest: AppleNewsUrlRequest(),
            networkCommunicator: NetworkCommunicator(),
            articleBuilder: articleBuilder())
    }
    
    func articleBuilder() -> AbstractArticleBuilder {
        return AppleNewsArticleBuilder(rssEntryBuilder: RssEntryBuilder())
    }
    
    // MARK: - Configuring database objects
    
    func articleCoreDataManager() -> ArticleCoreDataManager {
        return ArticleCoreDataManager(coreDataStack: CoreDataStack.sharedInstance)
    }
    
    // MARK: - Configuring view controllers
    
    func articleListViewController() -> ArticleListViewController {
        let articleListVC = ArticleListViewController(nibName: "ArticleListViewController", bundle: nil)
        articleListVC.dataSource = ArticleListTableDataSource()
        articleListVC.coreDataStack = CoreDataStack.sharedInstance
        
        let useCase = fetchArticlesUseCase()
        useCase.output = articleListVC
        articleListVC.fetchArticlesUseCaseInput = useCase
        
        return articleListVC
    }
}

