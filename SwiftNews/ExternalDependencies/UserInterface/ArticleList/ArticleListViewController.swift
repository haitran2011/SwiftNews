import UIKit
import CoreData

class ArticleListViewController: UIViewController, FetchArticlesUseCaseOutput, NSFetchedResultsControllerDelegate, SSPullToRefreshViewDelegate {
    var fetchArticlesUseCaseInput: FetchArticlesUseCaseInput!
    var dataSource: ArticleListTableDataSource!
    var coreDataStack: CoreDataStack!
    var pullToRefreshView: SSPullToRefreshView!
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Managing view lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Google News", comment:"")
        configureTableView()
        fetchArticles()
    }
    
    override func viewDidLayoutSubviews() {
        if pullToRefreshView == nil {
            pullToRefreshView = SSPullToRefreshView(scrollView: tableView, delegate: self)
            pullToRefreshView.contentView = GNPullToRefreshView()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        pullToRefreshView.startLoadingAndExpand(true, animated: true)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "didSelectArticleNotification:",
            name: DidSelectArticleNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "fetchArticles",
            name: RefreshArticleListNotification,
            object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: DidSelectArticleNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: RefreshArticleListNotification,
            object: nil)
    }
    
    private func configureTableView() {
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        dataSource.fetchedResultsController = fetchedResultsController
    }
    
    // MARK: - Handling notifications
    
    func didSelectArticleNotification(notification: NSNotification) {
        let article = notification.object as! Article
        
        if let sourceUrl = article.sourceUrl {
            let webViewController = PBWebViewController()
            webViewController.URL = NSURL(string: sourceUrl)
            navigationController?.pushViewController(webViewController, animated: true)
        }
    }
    
    // MARK: - Pull to refresh delegate methods
    
    func pullToRefreshViewDidStartLoading(view: SSPullToRefreshView!) {
        fetchArticles()
    }
    
    // MARK: - Fetching articles
    
    private func fetchArticles() {
        dataSource.shouldShowArticleLoadingError = false
        fetchArticlesUseCaseInput.fetchArticles()
        showArticlesSavedLocally()
    }
    
    private func showArticlesSavedLocally() {
        var error: NSError?
        let successfullyFetchedArticlesFromDatabase = fetchedResultsController.performFetch(&error)
        
        if successfullyFetchedArticlesFromDatabase == false {
            println("Error occurred while fetching articles from database: \(error?.localizedDescription)")
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Handling fetch articles usecase output
    
    func didReceiveArticles(articles: [Article]) {
        println("Received \(count(articles)) articles.")
        pullToRefreshView.finishLoading()
        dataSource.shouldShowArticleLoadingError = false
        tableView.reloadData()
    }
    
    func fetchingArticlesFailedWithError(error: NSError) {
        println("Error occurred while fetching articles: \(error.localizedDescription)")
        pullToRefreshView.finishLoading()
        
        if fetchedResultsController.fetchedObjects?.count == 0 {
            dataSource.shouldShowArticleLoadingError = true
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Creating a fetched results controller
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "ManagedArticle")
        let sortByPublishedDate = NSSortDescriptor(key: "publishedDate", ascending: false)
        fetchRequest.sortDescriptors = [sortByPublishedDate]
        fetchRequest.fetchBatchSize = 10
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.coreDataStack.mainQueueContext!,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    // MARK: - NSFetchedResultController delegate methods
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController,
        didChangeObject anObject: AnyObject,
        atIndexPath indexPath: NSIndexPath?,
        forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath?)
    {
        switch type {
            case .Insert:
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Top)
            
            case .Delete:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            
            case .Update:
                if let newIndexPath = newIndexPath {
                    tableView.reloadRowsAtIndexPaths([newIndexPath], withRowAnimation: .None)
                }
                else {
                    tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .None)
                    tableView.insertRowsAtIndexPaths([indexPath!], withRowAnimation: .None)
                }
                
            case .Move:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            
            default:
                break
        }
    }
    
    func controller(controller: NSFetchedResultsController,
        didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
        atIndex sectionIndex: Int,
        forChangeType type: NSFetchedResultsChangeType)
    {
        switch type {
            case .Insert:
                tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            
            case .Delete:
                tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            
            default:
                break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
}
