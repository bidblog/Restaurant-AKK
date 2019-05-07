//
//  MenuTableViewController.swift
//  Restaurant-AKK
//
//  Created by Henrik Gregersen on 15/01/2019.
//  Copyright © 2019 bidblog. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController , MenukortDelegate {

    // Parameter til ViewControlleren
    // Fordi vi har kategori laver jeg det som en Force Unwrapped optional
    var parmKategori : String!
    
    // Vi skal have en model til vores datasource
    var madRetter = [MadRet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hvis der er noget  i parmKategori, så ved jeg at vi er kaldt fra en segue i viewDidLoad.
        // Hvis ikke så er der tale om at vi er i restore state tilstand for så sættes parmKategori senere.
        if let _ = parmKategori {
            hentRetterFraServer()
        }
        
        updateUI()
        
    }

    func hentRetterFraServer() {
        // Tænd for netværks indikatoren
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        RestaurantController.shared.hentMenuKort(kategori: parmKategori) { (madRetter) in
            if let hentetMenu = madRetter {
                self.updateUI(med: hentetMenu)
            }
        }
    }
    
    func updateUI() {
        
        guard let _ = parmKategori else {return}
        
        // Vi lige starter med at teste om vores parameter virker
        print ("Overført parameter kategori = \(parmKategori)")
        self.title = parmKategori.capitalized
    }
    
    func updateUI(med madRetter: [MadRet]) {
        
        // Her søger vi så for at sende vores menukort til afvikling på main queue fordi det er HER vi opdaterer brugergrænsefladen
        DispatchQueue.main.async {
            self.madRetter = madRetter
            self.tableView.reloadData()
        
            // Vi skal slukke netværks indikatoren
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return madRetter.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuKortCelle", for: indexPath) as! MadRetTableViewCell

        // Configure the cell...
        let madRet = madRetter[indexPath.row]
      
        cell.madRetNavnLabel.text = madRet.navn
        cell.prisLabel.text = String(format: "Kr: %.2f", madRet.pris)
        
        return cell
    }
    
    // Autolayout driller mor... Den er dum..
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0
    }
    
    // Denne funktion kaldes hver gang en celle skal tegnes.
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let cell = cell as? MadRetTableViewCell else {return}
        
        RestaurantController.shared.hentBillede(fraUrl: madRetter[indexPath.row].billedUrl, medForsinkelse: false) { (billede) in
            
            DispatchQueue.main.async {
                cell.opdaterBillede(medBillede: billede)
            }
        }
    }

    // MARK: - Delegate
    func startForfra() {
        // Vi laver lige en print bare for at se at koden hænger sammen.
        print ("Vi skals vi starte forfra")
        
        performSegue(withIdentifier: "startForfraSegue", sender: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.

        // Her skal vi skrive koden om
        if segue.identifier == "VisMadRetSegue" {
            
            // Vi sikre os at vi har fat i den rigtige menu viewController
            guard let valgtRetViewController = segue.destination as? MadRetViewController else {
                print ("Vi forventede en MadRetViewController ved segue")
                return
            }
            
            // Vi finder madretten fra vores model
            valgtRetViewController.parmMadRet = madRetter[tableView.indexPathForSelectedRow!.row]
            
        }

    }
    
    //MARK: State handling
    
    // Enum keys til save og load state.
    // Formålet er at have eet sted hvor jeg retter state Id navne
    enum Keys : String {
        case madKategori = "madKategori"
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        // HER skal vi gemme det data der skal til for at vores viewcontroller kan starte op fra gemt tilstand.
        
        coder.encode(parmKategori, forKey: Keys.madKategori.rawValue)
        
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        
        // Så dekoder jeg kategorien.
        if let kategori = coder.decodeObject(forKey: Keys.madKategori.rawValue) as? String {
            
            // Så sætter vi parameter variablen som om jeg var kaldt af en segue.
            parmKategori = kategori
            
            // Vi skal opdater UI
            if let madRetter = RestaurantController.shared.stateController.madRetter(forKategori: kategori) {
                self.updateUI(med: madRetter)
            }
        }
    }
}
