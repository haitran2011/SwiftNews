import CoreData

extension NSFetchedResultsController {
    func articleAtIndexPath(indexPath: NSIndexPath) -> Article {
        let managedArticle = self.objectAtIndexPath(indexPath) as! ManagedArticle
        let dataManager = ObjectConfigurator.sharedInstance.articleCoreDataManager()
        return dataManager.createArticleFromManagedArticle(managedArticle)
    }
}
