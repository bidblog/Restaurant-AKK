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
        
        // Vi lige starter med at teste om vores parameter virker
        print ("Overført parameter kategori = \(parmKategori)")
        self.title = parmKategori.capitalized

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Tænd for netværks indikatoren
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        RestaurantController.shared.hentMenuKort(kategori: parmKategori) { (madRetter) in
            if let hentetMenu = madRetter {
                self.updateUI(med: hentetMenu)
            }
        }
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
        
        /*
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuKortCelle", for: indexPath)
        */
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuKortCelle", for: indexPath) as! MadRetTableViewCell

        // Configure the cell...
        let madRet = madRetter[indexPath.row]
      
        cell.madRetNavnLabel.text = madRet.navn
        cell.prisLabel.text = String(format: "Kr: %.2f", madRet.pris)
        
        /*
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
 
    */
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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


}
