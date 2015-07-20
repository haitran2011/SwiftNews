import Foundation
import CoreData

class ManagedArticle: NSManagedObject {

    @NSManaged var imageUrl: String
    @NSManaged var publishedDate: NSDate
    @NSManaged var publisher: String
    @NSManaged var sourceUrl: String
    @NSManaged var summary: String
    @NSManaged var title: String
    @NSManaged var uniqueId: String

}
