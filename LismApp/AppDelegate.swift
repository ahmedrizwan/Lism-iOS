//
//  AppDelegate.swift
//  Lism
//
//  Created by Nofel Mahmood on 04/02/2017.
//  Copyright © 2017 TwinBinary. All rights reserved.
//

import UIKit
import AVOSCloud
import Fabric
import DigitsKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setUpAVCloud()
        Product.registerSubclass()
        Comments.registerSubclass()
        User.registerSubclass()
        NotificationLog.registerSubclass()
        // Override point for customization after application launch.
        
        let navigationController = UINavigationController()
        
        var mainViewController = UIViewController()
        if(AVUser.current() != nil)
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
           mainViewController = storyboard.instantiateViewController(withIdentifier: "ProductViewController")
            
        }
        else{
            mainViewController = MainViewController()

        }
        navigationController.viewControllers = [mainViewController]
        navigationController.navigationBar.barTintColor = UIColor.white
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "logo")
        imageView.image = image
        navigationController.navigationBar.backItem?.title = ""
        
        navigationController.navigationItem.titleView = imageView

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navigationController
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()

        Fabric.with([Digits.self])
        if (launchOptions != nil) {
            // do something else
            AVAnalytics.trackAppOpened(launchOptions: launchOptions)
        }
        
        self.registerForRemoteNotification()
        return true
    }
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)

    }
 
    func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                         willPresent notification: UNNotification,
                                         withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler(UNNotificationPresentationOptions.alert)

    print("recieved notification")
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(center: UNUserNotificationCenter, didReceiveNotificationResponse response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void) {
        
        print("didReceive")
        completionHandler()
    }
    
    // The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from applicationDidFinishLaunching:.
 

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("didReceive")
        completionHandler()
    }
    
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        let currentInstallation = AVInstallation.current()
        currentInstallation.setDeviceTokenFrom(deviceToken)
        currentInstallation.saveInBackground()
        //  Converted with Swiftify v1.0.6341 - https://objectivec2swift.com/
        AVOSCloud.handleRemoteNotifications(withDeviceToken: deviceToken) { (currentInstallation) in
         print( "")
        }
        
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("i am not available in simulator \(error)")
        
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if application.applicationState == .active {
        
        print ("userInfo",userInfo)
        }
            else {
            AVAnalytics.trackAppOpened(withRemoteNotificationPayload: userInfo)
        }
    }

    func setUpAVCloud() {
        let applicationID = "Cn9eVkpohxi0u2ki6qXNwujn-gzGzoHsz"
        let clientKey = "8BB9DoKO0GVCdUq4O8FCxX0j"
        
        AVOSCloud.setApplicationId(applicationID, clientKey: clientKey)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

