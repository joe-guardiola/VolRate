//
//  AppDelegate.swift 
import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 59.0/255.0, green: 89.0/255.0, blue: 152.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        if let barFont = UIFont(name: "Avenir-Light", size: 24.0) {
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor(), NSFontAttributeName:barFont]
        }
        
        // Change the status bar's appearance
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        // Change the tab bar's appearance
        UITabBar.appearance().selectionIndicatorImage = UIImage(named: "tabitem-selected")
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        return true
    }
}

