import UIKit

class ArticleCell: UITableViewCell {
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    lazy private var timeIntervalFormatter: TTTTimeIntervalFormatter? = {
        let formatter = TTTTimeIntervalFormatter()
        formatter.leastSignificantUnit = .SecondCalendarUnit
        return formatter
    }()
    
    // MARK: - Configuring cell
    
    class func reuseIdentifier() -> String {
        return "ArticleCell"
    }
    
    class func nibName() -> String {
        return "ArticleCell"
    }
    
    class func height() -> CGFloat {
        return 115.0
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        addBordersToContainerView()
    }
    
    private func addBordersToContainerView() {
        containerView.layer.cornerRadius = 3.0
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor.darkGrayColor().CGColor
    }
    
    private func makeTitleTextMultiLine() {
        titleButton.titleLabel?.numberOfLines = 0
    }
    
    // MARK: Updating cell content
    
    func setArticle(article: Article) {
        publisherLabel.text = article.publisher
        publishedDateLabel.text = timeIntervalFormatter?.stringForTimeIntervalFromDate(NSDate(), toDate: article.publishedDate)
        titleButton.setTitle(article.title, forState: UIControlState.Normal)
        updateImageViewFromArticle(article)
    }
    
    private func updateImageViewFromArticle(article: Article) {
        if let imageUrl = article.imageUrl {
            let placeholderImage = UIImage(named: "articlePlaceholderImage")
            articleImageView.sd_setImageWithURL(NSURL(string: imageUrl), placeholderImage: placeholderImage)
        }
    }
}
