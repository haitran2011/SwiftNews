import CoreData

let DidSelectArticleNotification = "DidSelectArticleNotification"

class ArticleListTableDataSource : NSObject, UITableViewDataSource, UITableViewDelegate {
    var shouldShowArticleLoadingError: Bool!
    var fetchedResultsController: NSFetchedResultsController?
    private weak var tableView: UITableView!
    
    // MARK: - Configuring table view
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView = tableView
        
        if shouldShowArticleLoadingError == true {
            return 1
        }
        
        let sections = fetchedResultsController?.sections as! [NSFetchedResultsSectionInfo]
        return sections[section].numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if shouldShowArticleLoadingError == true {
            
        }
        
        return articleCellAtIndexPath(indexPath)
    }

    private func articleCellAtIndexPath(indexPath: NSIndexPath) -> ArticleCell {
        let cell = createArticleCell()
        configureArticleCell(cell, indexPath: indexPath)
        return cell
    }
    
    private func createArticleCell() -> ArticleCell {
        let reuseId = ArticleCell.reuseIdentifier()
        var cell: AnyObject? = tableView.dequeueReusableCellWithIdentifier(reuseId)
        
        if cell == nil {
            let nibName = ArticleCell.nibName()
            cell = UIView.loadViewFromNibName(nibName)
        }
        
        return cell as! ArticleCell
    }
    
    private func configureArticleCell(cell: ArticleCell, indexPath: NSIndexPath) {
        if let article = fetchedResultsController?.objectAtIndexPath(indexPath) as? Article {
            cell.setArticle(article)
        }
    }
    
    // MARK: - Computing cell height
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if shouldShowArticleLoadingError == true {
            
        }
        
        return ArticleCell.height()
    }
    
    // MARK: - Handling cell tap
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let article = fetchedResultsController?.articleAtIndexPath(indexPath)
        let notification = NSNotification(name: DidSelectArticleNotification, object: article)
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }
}
