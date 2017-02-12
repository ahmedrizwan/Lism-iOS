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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let AVApplicationID = "Cn9eVkpohxi0u2ki6qXNwujn-gzGzoHsz"
    let AVClientID = "8BB9DoKO0GVCdUq4O8FCxX0j"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let homeViewController = HomeViewController()
        var homeNavigationController = UINavigationController()
        homeNavigationController = UINavigationController(rootViewController: homeViewController)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = homeNavigationController
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        
        let mainViewController = MainViewController()
        homeNavigationController.present(mainViewController, animated: true, completion: nil)
        
        setUpDigits()
        setUpAVCloud()
        
        return true
    }
    
    func setUpDigits() {
        Fabric.with([Digits.self])
    }
    
    func setUpAVCloud() {
        AVOSCloud.setApplicationId(AVApplicationID, clientKey: AVClientID)
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

