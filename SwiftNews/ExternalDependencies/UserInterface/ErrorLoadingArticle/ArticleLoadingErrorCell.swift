import UIKit

let RefreshArticleListNotification = "RefreshArticleListNotification"

class ArticleLoadingErrorCell: UITableViewCell {

    // MARK: - Configuring cell
    
    class func reuseIdentifier() -> String {
        return "ArticleLoadingErrorCell"
    }
    
    class func nibName() -> String {
        return "ArticleLoadingErrorCell"
    }
    
    class func height() -> CGFloat {
        return UIScreen.mainScreen().heightWithoutNavigationBar()
    }
    
    @IBAction func refreshViewTapped(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(RefreshArticleListNotification, object: nil)
    }
}
