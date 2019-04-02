//
//  KategoriTableViewController.swift
//  Restaurant-AKK
//
//  Created by Henrik Gregersen on 15/01/2019.
//  Copyright © 2019 bidblog. All rights reserved.
//

import UIKit

class KategoriTableViewController: UITableViewController {

    // Vi skal hve en model til vores viewController
    var madRetKategorier = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Tænd for netværks indikatoren
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        RestaurantController.shared.hentKategorier { (kategorier) in
            if let retKategorier = kategorier {
                self.updateUI(med: retKategorier)
            } else {
                
                // Vi skal smide en Ingen svar fra server alert.
                
                let alert = UIAlertController(title: "Server problemer", message: "Server svarer ikke. Har du husket at starte den?", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }

    func updateUI(med madRetKategorier: [String]) {
        // Her sørger vi så for at sende vores liste over kategorier til afvikling på mainQueue fordi det er HER vi opdaterer brugergænsefladen.
        DispatchQueue.main.async {
            self.madRetKategorier = madRetKategorier
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
        return madRetKategorier.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MadRetKategoriCelle", for: indexPath)

        // Configure the cell...
        // Vi udfylder cellens tekst
        cell.textLabel?.text = madRetKategorier[indexPath.row]

        return cell
    }

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "VisMenuSegue" {
            
            // Vi sikre os at vi har fat i den rigtige menu viewController
            guard let menuKortViewController = segue.destination as? MenuTableViewController else {
                print ("Vi forventede en MenuTableViewController ved segue")
                return
            }
            
            // Vi finder kategorien fra vores model
            menuKortViewController.parmKategori = madRetKategorier[tableView.indexPathForSelectedRow!.row]
            
        }
    }
    
    @IBAction func unwindToMenuKortStart(_ unwindSegue: UIStoryboardSegue) {
        // let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }

}
