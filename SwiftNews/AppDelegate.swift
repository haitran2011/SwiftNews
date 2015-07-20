import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?)
        -> Bool
    {
        let articleListVC = ObjectConfigurator.sharedInstance.articleListViewController()
        let articleListNavController = UINavigationController(rootViewController: articleListVC)
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = articleListNavController
        window?.makeKeyAndVisible()
        
        return true
    }
}
