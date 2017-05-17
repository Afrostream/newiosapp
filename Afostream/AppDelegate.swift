//
//  AppDelegate.swift
//  Afostream
//
//  Created by Bahri on 04/05/2017.
//  Copyright © 2017 Bahri. All rights reserved.
//

import UIKit
import AlamofireNetworkActivityIndicator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
         NetworkActivityIndicatorManager.shared.isEnabled = true
        NetworkActivityIndicatorManager.shared.startDelay = 0.1
    }
   


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UINavigationBar.appearance().barTintColor=GlobalVar.StaticVar.Violet
        UINavigationBar.appearance().tintColor=UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
       
        
        if (GlobalVar.StaticVar.DevMode)
        {
            GlobalVar.StaticVar.BaseUrl = "https://afr-back-end-staging.herokuapp.com" // dev
            
            GlobalVar.StaticVar.drmLicenseUrl = "https://lic.staging.drmtoday.com/license-proxy-widevine/cenc/?specConform=true" //dev
            GlobalVar.StaticVar.StripeKey = "pk_test_s9YFHvFFIjo2gdAL5x4k2ISh" //dev
        }else
        {
            GlobalVar.StaticVar.BaseUrl = "https://legacy-api.afrostream.tv" // prod cdn
            // StaticVar.BaseUrl="https://afrostream-backend.herokuapp.com" // prod sans cdn
            GlobalVar.StaticVar.drmLicenseUrl = "https://lic.drmtoday.com/license-proxy-widevine/cenc/?specConform=true" //prod
            GlobalVar.StaticVar.StripeKey = "pk_live_Qyu5litLIYwE3ks66iBIFbQk" //prod
            
        }
        
        
        return true
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

