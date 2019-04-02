//
//  BestillingViewController.swift
//  Restaurant-AKK
//
//  Created by Henrik Gregersen on 15/01/2019.
//  Copyright © 2019 bidblog. All rights reserved.
//

import UIKit
import UserNotifications

class BestillingViewController: UIViewController {

    // Vi har brug for en model
    var minutter : Int?
    
    @IBOutlet weak var serverSvarLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        /*
        if let antalMinutter = minutter {
            serverSvarLabel.text = "\(antalMinutter) minutter"
        }
        */
        
        guard let antalMinutter = minutter else {return}
        
        serverSvarLabel.text = "\(antalMinutter) minutter"
        
        // Vi definerer hvor lang tid der skal gå før vi vil se en notifikation
        let minutterTilNotifikation = 1
        
        // Vi vil vise restttiden, det er ikke raketvidenskab....
        let restTidTilMadErKlar = antalMinutter - minutterTilNotifikation
        
        // Vi skal have visningstiden i sekunder
        let sekunderTilNotifikation = TimeInterval(20)//TimeInterval(minutterTilNotifikation * 60)
        
        visNotifikationEfter(sekunder: sekunderTilNotifikation, minutterTilMad: restTidTilMadErKlar)
        
    }
    
    // En funktion der bestiller en notifikation.
    func visNotifikationEfter(sekunder : TimeInterval, minutterTilMad minutter : Int) {
        
        // Vi undersøger om vi må sende notifikationer.
        UNUserNotificationCenter.current().getNotificationSettings { (notifikationsIndstillinger) in
            
            // Først kontrollere jeg lige om notifikationer er slået til
            guard notifikationsIndstillinger.authorizationStatus == .authorized else {return}
            
            // Så kontrollerer jeg om vi må vise alerts som notifikationer
            guard notifikationsIndstillinger.alertSetting == .enabled else {return}
            
            // Så vi bygger et content objekt. Vores indhold i notifikationen
            let indhold = UNMutableNotificationContent()
            indhold.title = "Er du sulten?"
            indhold.subtitle = "Din mad er klar"
            indhold.body = "Om \(minutter) minutter"
        
            
            // Hvis vi må spille en lyd så spiller vi en lyd
            if notifikationsIndstillinger.soundSetting == .enabled {
                indhold.sound = UNNotificationSound.default
            }
            
            // Vi skal have noget der udløser vores notifikation
            let udloeser = UNTimeIntervalNotificationTrigger(timeInterval: sekunder, repeats: false)
            
            // Så skal vi samle det hele i et request objekt.
            
            // Jeg laver en Id til vores notifikation.
            let notifikationsId = "dk.eat.just.kopi" + String(Date().timeIntervalSince1970)
            
            print ("NotifikationsID : \(notifikationsId)")
            
            let request = UNNotificationRequest(identifier: notifikationsId, content: indhold, trigger: udloeser)
            
            // Så tilføjer requestet til notifikationscenteret.
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                if let fejl = error {
                    print ("Fejl ved tilføjelse til notifikationscenter \(fejl.localizedDescription)")
                } else {
                    print ("Notifikation Bestilt")
                }
                
            })
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
