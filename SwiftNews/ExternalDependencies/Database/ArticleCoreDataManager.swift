import CoreData

class ArticleCoreDataManager : ArticleRepository {
    
    // MARK: - Initializing a data manager
    
    private let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    // MARK: - Saving an article
    
    func saveArticle(article: Article) {
        createManagedArticleFromArticle(article)
        coreDataStack.saveMainQueueContext()
    }
    
    private func createManagedArticleFromArticle(article: Article) -> ManagedArticle {
        let managedArticle = NSEntityDescription.insertNewObjectForEntityForName("ManagedArticle",
            inManagedObjectContext: coreDataStack.mainQueueContext!) as! ManagedArticle
        
        if let uniqueId = article.uniqueId {
            managedArticle.uniqueId = uniqueId
        }
        
        if let title = article.title {
            managedArticle.title = title
        }
        
        if let summary = article.summary {
            managedArticle.summary = summary
        }

        if let sourceUrl = article.sourceUrl {
            managedArticle.sourceUrl = sourceUrl
        }
        
        if let publisher = article.publisher {
            managedArticle.publisher = publisher
        }
        
        if let imageUrl = article.imageUrl {
            managedArticle.imageUrl = imageUrl
        }
        
        if let publishedDate = article.publishedDate {
            managedArticle.publishedDate = publishedDate
        }
        
        return managedArticle
    }
    
    // MARK: - Verifying existence of an article
    
    func doesArticleExist(article: Article) -> Bool {
        let managedArticle = fetchManagedArticleWithUniqueId(article.uniqueId!)
        return managedArticle != nil ? true : false
    }
    
    // MARK: - Retrieving articles
    
    func articleWithUniqueId(uniqueId: String) -> Article? {
        if let managedArticle = fetchManagedArticleWithUniqueId(uniqueId) {
            return createArticleFromManagedArticle(managedArticle)
        }
        
        return nil
    }
    
    func createArticleFromManagedArticle(managedArticle: ManagedArticle) -> Article {
        let article = Article()
        article.uniqueId = managedArticle.uniqueId;
        article.title = managedArticle.title;
        article.summary = managedArticle.summary;
        article.sourceUrl = managedArticle.sourceUrl;
        article.imageUrl = managedArticle.imageUrl;
        article.publisher = managedArticle.publisher;
        article.publishedDate = managedArticle.publishedDate;
        return article;
    }
    
    private func fetchManagedArticleWithUniqueId(uniqueId: String) -> ManagedArticle? {
        let fetchRequest = NSFetchRequest(entityName: "ManagedArticle")
        fetchRequest.predicate = NSPredicate(format: "uniqueId like \(uniqueId)")
        
        var error: NSError?
        
        if let articles = coreDataStack.mainQueueContext?.executeFetchRequest(fetchRequest, error: &error)
            where count(articles) > 0
        {
            return articles.first as? ManagedArticle
        }
        
        println("Error occurred while retrieving an article with unique ID: \(error?.localizedDescription)")
        return nil
    }
}
