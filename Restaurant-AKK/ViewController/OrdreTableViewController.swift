//
//  OrdreTableViewController.swift
//  Restaurant-AKK
//
//  Created by Henrik Gregersen on 15/01/2019.
//  Copyright © 2019 bidblog. All rights reserved.
//

import UIKit

class OrdreTableViewController: UITableViewController, TjenerDelegate {
    

    // Vi skal have en model til vores datasource
    var madRetter = [MadRet]()
    
    // Variabel der indeholder leveringstidsvar vi får fra serveren
    var leveringsMinutter : Int?
    
    // Vi definerer en tjener variabel som er den der skal tage imod vores bestilling
    var menuKortDelegate : MenukortDelegate?
    
    @IBAction func bestilKnapTrykket(_ sender: UIBarButtonItem) {
        
        //Først finder jeg ud af min ordretotal
        let ordreTotal = madRetter.reduce(0.0) { (subtotal, madRet) -> Double in
            return subtotal + madRet.pris
        }
        
        // Samlet køb som tekst
        let samletKoebTekst = String(format: "Kr: %.2f", ordreTotal)
    
        print ("Totalen er \(samletKoebTekst)")
        
        // Vi skal smide en ER DU SIKKER ALERT op
        let alert = UIAlertController(title: "Bekræft din bestilling", message: "Er du sikker på at du vil bestille mad for \(samletKoebTekst)", preferredStyle: .alert)
        
        // Vi laver så den først knap som er en UIAlertAction
        let jaAction = UIAlertAction(title: "Ja", style: .default) { (action) in
            self.bestilMaden()
        }
        // Så sætter vi vores Ja Action på vores alert
        alert.addAction(jaAction)
        
        // Vi laver så den anden knap som er en NEJ knap
        let nejAction = UIAlertAction(title: "Nej", style: .cancel, handler: nil)
        // Så sætter vi vores nej action på vores alert
        alert.addAction(nejAction)
        
        // Så skal vi vise viewcontrolleren
        present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Vi tager fat i vores AppDelegate
        let applikation = UIApplication.shared.delegate as! AppDelegate

        print (applikation.aktuelBestilling)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    func opdaterBadge() {
        // Først finder jeg ud af hvad der skal stå i vores badge. En Badge er en optional streng. Så jeg kan sætte den til nil for at skjule den, eller jeg kan give den en streng værdi.
        let badgeTekst = madRetter.count > 0 ? "\(madRetter.count)" : nil
        
        // Vores tabbar ikon ligger navigationController
        navigationController?.tabBarItem.badgeValue = badgeTekst
    }
    
    // Her laver vi en funktion der sørger for at bestille maden
    func bestilMaden() {
        //TODO: Kod logikken til bestilling af maden
        
        //Vi laver en print så vi kan se at vi kalder koden
        print ("Nu bestiller vi maden")
        
        let madRetNumre = madRetter.map { $0.retNummer }
        
        print (madRetNumre)
        
        RestaurantController.shared.sendBestilling(valgteRetNumre: madRetNumre) { (svarMinutter) in
            // Vi skal sørge for at sende svaret til main tråden fordi vi skal opdatere brugergrænsefladen.
            DispatchQueue.main.async {
                if let minutter = svarMinutter {
                    print ("Der går \(minutter) minutter")
                    // Så kalder vi vores segue.
                    self.leveringsMinutter = minutter
                    self.performSegue(withIdentifier: "ordreBekraeftSegue", sender: nil)
                }
            }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ordreListeCelle", for: indexPath)
        
        // Configure the cell...
        let madRet = madRetter[indexPath.row]
        
        // Udfylder jeg cellens outlets
        cell.textLabel?.text = madRet.navn
        //cell.detailTextLabel?.text = String(madRet.pris)
        
        cell.detailTextLabel?.text = String(format: "Kr: %.2f", madRet.pris)
        
        // VI henter billedet
        RestaurantController.shared.hentBillede(fraUrl: madRet.billedUrl) { (hentetBillede) in
            
            DispatchQueue.main.async {
                // Fordi vi kører asynkront og brugeren kan have scrollet forbi cellen før vi får hentet fra serveren så kontrollere vi lige at vi står på den rigite indexpath.
                // I praksis har det ingen betydning som appen er nu fordi vi kører med en lokal server.
                if let aktueltIndexPath = self.tableView.indexPath(for: cell) {
                    if aktueltIndexPath != indexPath {
                        return
                    }
                }
                
                cell.imageView?.image = hentetBillede
            }
        }
        
        return cell
    }


    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            madRetter.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            // Husk at opdatere badge
            opdaterBadge()
        }
        /*
        else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        */
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Delegate
    func madRetTilOrdren(madRet: MadRet) {
        // Vi har modtaget en madret. Vi gemmer den på vores model. Vi tilføjer den til vores liste.
        madRetter.append(madRet)
        
        // Så tilføjer jeg madretten til det visuelle tableview.
        let placering = IndexPath(row: (madRetter.count - 1), section: 0)
        tableView.insertRows(at: [placering], with: .automatic)
        
        // Så opdatere vi vores badge
        opdaterBadge()
    }
    
    // Her definerer vi menukortDelgate ved at finde frem til det skærmbillede der er aktivt på den anden tabside.
    func definerMenukortDelegate() -> MenukortDelegate? {
        
        // Hvis nogen har defineret sig som delegate til os, så skal vi ikke finde ud af det.
        if menuKortDelegate != nil {
            return menuKortDelegate
        }
        
        // Her går vi gennem hierarkiet for at finde vores menukort og sætter aktuel menukort skærmbillede som delegate.
        if let navController = tabBarController?.viewControllers?.first as? UINavigationController {
            
            // Nu har vi fat i navigation controlleren som er far vil vores menukort  viewcontroller
            if let menuKortController = navController.viewControllers.last as? MenukortDelegate {
                
                // Nu har vi fanget vores MenukortDelegate i form af en eller anden form for viewController.
                // Vi skal ikke gemme den delegerede for så er det den der bruges næste gang og det kan være et forkert skærmbillede.
                //menuKortDelegate = menuKortController
                return menuKortController
            }
        }
        
        return menuKortDelegate
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ordreBekraeftSegue" {
            guard let destination = segue.destination as? BestillingViewController else { return }
            
            destination.minutter = leveringsMinutter
        }
        
    }
    
    
    @IBAction func unwindToOrdreSeddel(_ unwindSegue: UIStoryboardSegue) {
        // let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
        if unwindSegue.identifier == "bekraeftetOKSegue" {
            // Så har brugeren set leveringstidspunktet og jeg kan rydde op
            
            // Først rydder vi data
            madRetter.removeAll()
            
            // Så opdaterer vi viewet
            tableView.reloadData()
            
            // Vores badge opdateres
            opdaterBadge()
            
            // Nulstiller menukortet
            definerMenukortDelegate()?.startForfra()
        }
    }
    

}
