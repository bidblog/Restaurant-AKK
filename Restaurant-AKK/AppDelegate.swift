//
//  AppDelegate.swift
//  Restaurant-AKK
//
//  Created by Henrik Gregersen on 15/01/2019.
//  Copyright © 2019 bidblog. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Læse filen ordresedlen ind
        RestaurantController.shared.loadStateData()
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Først laver vi en pegepind til appens temp bibliotek.
        let tempDirectory = NSTemporaryDirectory()
        
        // Vi definere et URL Cache objekt med ca 25 MB i hukommelsen og ca 50MB på disk.
        let urlCache = URLCache(memoryCapacity: 25_000_000, diskCapacity: 50_000_000, diskPath: tempDirectory)
        
        // Så vi fortæller URLCache.shared hvor meget memory den må bruge via vores objekt, og URLSession.shared læser URLCache.shared når denne bruges første gang.
        
        URLCache.shared = urlCache
    
        // Vi fortæller notifikationscenteret at vi vil være delegate
        UNUserNotificationCenter.current().delegate = self
        
        // Vi kalder vores funktion der spørger om vi må sende notifikationer
        tilladNotifikationer()
    
        // Kald badge opdaterings funktion når ordresedlen ændrer sig
        MainTabBarController.shared.tilmeldObserver()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        // Save vores ordreseddel
        RestaurantController.shared.saveStateData()
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

    // Ja tak vi vil styre restore af state
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    // Ja tak vi vil styre save state. 
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }

}

extension AppDelegate : UNUserNotificationCenterDelegate {
    // Her laver jeg en funktin der spørger om lov til at forstyrre brugeren med en notifikation
    func tilladNotifikationer() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound ]) { (ok, error) in
            if ok {
                print ("Vi må sende notifikationer")
            } else {
                if let fejl = error {
                    print (fejl.localizedDescription)
                }
            }
        }
    }
    
    // Vi skal implementerer funktionen der tillader at vi viser notifikationer i forgrunden.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    
    }
    
    /*
    // Hvis vi skal sende notifikationen et bestemt sted hen...
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // reager på notifikationens request id hvis du vil styre hvad der skal ske når brugeren åbner appen. 
        response.notification.request.identifier = ""
    }
    */
    
}
