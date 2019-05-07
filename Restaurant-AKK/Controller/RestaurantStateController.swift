//
//  RestaurantStateController.swift
//  Restaurant-AKK
//
//  Created by Henrik Gregersen on 07/05/2019.
//  Copyright © 2019 bidblog. All rights reserved.
//

import Foundation

// Vi definerer en kontroller der styrer alt omkring den nødvendige data der skal gemmes ved state.
class RestaurantStateController {
    
    // Hvis jeg står med en Ret ID (retnummer), så skal jeg kunne slå en madret op med et id.
    private var retterMedID = [Int: MadRet]()
    
    // Til vores menukort skal jeg også have en struktur.
    private var retterMedKategori = [String: [MadRet]]()
    
    // Opslags metode til at finde en ret ud fra et retnummer
    func madRet(medId retId: Int) -> MadRet? {
        return retterMedID[retId]
    }
    
    // Opslags metode til at finde alle retter ud fra en given kategori, som skal bruges når vi skal vise menukortet
    func madRetter(forKategori kategori: String) -> [MadRet]? {
        return retterMedKategori[kategori]
    }
    
    // En funktion til at opdatere index over madretters id. (som skal bruges når vi henter state fra der hvor vi bestiller)
    private func opdaterMadRetIdIndex() {
     
        // Giv mig et array over alle madretter for alle kategorier.
        let madRetter = retterMedKategori.flatMap { $0.value }
        
        // Jeg løber arrayet igennem over madretter
        for madRet in madRetter {
            retterMedID[madRet.retNummer] = madRet
        }
    }
    
    // Metode der sørger for at opdaterer vores lokale index med retter for en given kategori. Hver gang vi får et svar fra serveren sørger vi for at kalde denne metode.
    func opdater(kategori: String, medMadretter madRetter : [MadRet]? ) {
        
        // Har vi kategorien gemt i forvejen.
        if let _ = self.madRetter(forKategori: kategori) {
            retterMedKategori.removeValue(forKey: kategori)
        }
        
        // Her har vi fjernet data hvis det var der i forvejen, så nu gemmer vi det nye data
        if let _ = madRetter {
            retterMedKategori[kategori] = madRetter
            
            // Husk at kalde funktion til opdatering af retterMedId
            opdaterMadRetIdIndex()
        }
        
        print("StateController opdateret")
        print(retterMedKategori)
    }
 
    //MARK: saveStateData
    // kopieret fra loadOrdreseddel. Henter state data ind fra disk.
    func restoreState() {
        // Kan vi læse kategori index ind fra fil
        guard let kategoriData = try? Data(contentsOf: RestaurantStateController.filURL) else { return }
        
        // Hvis vi har en fil hentet ind skal vi lave den om fra json til kategori indexet.
        if let hentetKategorier = try? JSONDecoder().decode([String: [MadRet]].self, from: kategoriData) {
            
            retterMedKategori = hentetKategorier
            self.opdaterMadRetIdIndex()
            
            print ("Kategori fil er indlæst")
        }
    }
    
    // Funktion kopierer fra ordreseddel
    // Gemmer kategori data til disk
    func saveState() {
        if let kategoriData = try? JSONEncoder().encode(retterMedKategori) {
            try? kategoriData.write(to: RestaurantStateController.filURL)
            print ("Kategorier er gemt")
        }
    }
    
    // URL til ordreseddel variabel
    static var filURL : URL {
        // URL til brugerns Dokumenter
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let ordreFilUrl = documentURL.appendingPathComponent("kategorier").appendingPathExtension("json")
        
        return ordreFilUrl
    }
}
