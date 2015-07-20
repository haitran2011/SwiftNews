import Foundation
import CoreData

class CoreDataStack {
    static let sharedInstance = CoreDataStack(persistentStoreType: NSSQLiteStoreType)
    private let persistentStoreType: String
    
    init(persistentStoreType: String) {
        self.persistentStoreType = persistentStoreType
    }
    
    // MARK: - Saving main queue context
    
    func saveMainQueueContext() {
        mainQueueContext?.saveRecursively()
    }
    
    // MARK: - Setting up Core Data stack
    
    lazy var mainQueueContext: NSManagedObjectContext? = {
        if let parentContext = self.masterSavingContext {
            let mainQueueContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
            mainQueueContext.parentContext = parentContext
            mainQueueContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            return mainQueueContext
        }
        
        return nil
    }()
    
    private lazy var masterSavingContext: NSManagedObjectContext? = {
        if let coordinator = self.persistentStoreCoordinator {
            let masterContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
            masterContext.persistentStoreCoordinator = coordinator
            masterContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            return masterContext
        }
        
        return nil
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("SwiftNews", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SwiftNews.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            
            println("Unresolved error \(error), \(error!.userInfo)")
            exit(1)
        }
        
        return coordinator
    }()
    
    private lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
    }()
}
