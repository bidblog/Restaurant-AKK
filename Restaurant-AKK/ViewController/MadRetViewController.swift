//
//  MadRetViewController.swift
//  Restaurant-AKK
//
//  Created by Henrik Gregersen on 15/01/2019.
//  Copyright © 2019 bidblog. All rights reserved.
//

import UIKit

class MadRetViewController: UIViewController , MenukortDelegate {
    

    // Parameter til ViewControlleren
    // Fordi vi har Madret laver jeg det som en Force Unwrapped optional
    // Fuldstændig samme princip som fra kategori -> Menukort osv.
    // Vores parameter ER også vores model
    var parmMadRet : MadRet!
    
    //MARK: Outlets
    @IBOutlet weak var bestilKnap: BestilKnap!
    
    @IBOutlet weak var madRetBillede: UIImageView!
    
    @IBOutlet weak var madRetTitel: UILabel!
    
    @IBOutlet weak var madRetPrisLabel: UILabel!
    
    
    @IBOutlet weak var madRetBeskrivelse: UILabel!
    
    //MARK: Actions
    @IBAction func bestilKnapKlikket(_ sender: BestilKnap) {
        sender.klikAnimation()
        
        /*
        // Vi tager fat i vores AppDelegate
        let applikation = UIApplication.shared.delegate as! AppDelegate
        
        // Så kan vi gemme vores valgte madret i vores globale data
        applikation.aktuelBestilling.append(parmMadRet)
        */
        
        
    }
    
    //MARK: Layout
    override func viewDidLoad() {
        super.viewDidLoad()

        // Vi lige starter med at teste om vores parameter virker
        print ("Overført parameter madRet = \(parmMadRet.navn)")

        // Do any additional setup after loading the view.
        
        updateUI()
    }
    
    func updateUI() {
        // Her sætter vi så titel pris og beskrivelse, billedet kommer vi tilbage til.
        madRetTitel.text = parmMadRet.navn
        madRetPrisLabel.text = String(format: "Kr %.2f", parmMadRet.pris)
        madRetBeskrivelse.text = parmMadRet.beskrivelse
        
        // VI henter billedet
        RestaurantController.shared.hentBillede(fraUrl: parmMadRet.billedUrl) { (hentetBillede) in
            
            guard let billede = hentetBillede else {return}
            
            DispatchQueue.main.async {
                self.madRetBillede.image = billede
            }
        }
    }
    // MARK : Delegate
    
    func startForfra() {
        // Vi laver lige en print bare for at se at koden hænger sammen.
        print ("Vi skals vi starte forfra")
        
        performSegue(withIdentifier: "startForfraSegue", sender: nil)
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
