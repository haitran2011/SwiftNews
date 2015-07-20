import UIKit

extension UIScreen {
    func heightWithoutNavigationBar() -> CGFloat {
        let screenHeight = self.applicationFrame.size.height
        return screenHeight - navigationBarHeight()
    }
    
    private func navigationBarHeight() -> CGFloat {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let navController = appDelegate.window?.rootViewController as! UINavigationController
        return navController.navigationBar.frame.size.height
    }
}
