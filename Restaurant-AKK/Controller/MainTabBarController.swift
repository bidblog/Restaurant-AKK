//
//  MainTabBarController.swift
//  Restaurant-AKK
//
//  Created by Henrik Gregersen on 23/04/2019.
//  Copyright © 2019 bidblog. All rights reserved.
//

import UIKit

class MainTabBarController {
    
    // Vi laver en variabel som indeholder det faneblad som ordreseddlen ligger på
    public private(set) var ordreTabBarItem : UITabBarItem?
    
    // Initializer hvor jeg sætter værdien af ordreTabBarItem
    init() {
        // Først tager vi fat i AppDelegate
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        
        // Så finder jeg første viewController i vores app, altså den som den første pil peger på.
        // Bemærk at vis første viewController ikke er en UITabBarController så crasher programmet.
        let foersteViewController = appDelegate.window!.rootViewController! as! UITabBarController
        
        // Så sætter vi ordreTabBarItem til at være tab nr 1
        ordreTabBarItem = foersteViewController.viewControllers![1].tabBarItem
    }
    
    @objc func opdaterBadge() {
        // Først finder jeg ud af hvad der skal stå i vores badge. En Badge er en optional streng. Så jeg kan sætte den til nil for at skjule den, eller jeg kan give den en streng værdi.
        let badgeTekst = RestaurantController.shared.aktuelOrdre.madRetter.count > 0 ? "\(RestaurantController.shared.aktuelOrdre.madRetter.count)" : nil
        
        // Vores tabbar ikon ligger navigationController
        ordreTabBarItem?.badgeValue = badgeTekst
    }
    
    //Funktion der tilmelder os til notifikationer på ordresedlen
    public func tilmeldObserver() {
        // Jeg vil have besked når ordresedlen opdateres.
        NotificationCenter.default.addObserver(self, selector: #selector(opdaterBadge), name: RestaurantController.ordreOpdNotifikationsNavn, object: nil)
    }
    
    //MARK: Static
    static let shared = MainTabBarController()
}

