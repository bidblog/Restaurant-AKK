//
//  RestaurantController.swift
//  Restaurant-AKK
//
//  Created by Henrik Gregersen on 22/01/2019.
//  Copyright © 2019 bidblog. All rights reserved.
//

import Foundation
import UIKit

class RestaurantController {
    
    // Vi laver en variabel til at holde den delte ordreseddel for den akutelle ordre.
    var aktuelOrdre = OrdreSeddel() {
        // Vi sender en besked hver gang der ændres i vores ordre
        didSet {
            NotificationCenter.default.post(name: Notification.Name(RestaurantController.ordreOpdNotifikationsNavn), object: nil)
        }
    }
    
    let basisUrl = URL(string: "http://localhost:8090/")!
    
    // Funktion der via en GET giver os en liste over kategorier som vi så kan bruge til at hente menukortet.
    public func hentKategorier(completion: @escaping ([String]?) -> Void ) {
        let kategoriURL = basisUrl.appendingPathComponent("categories")
        
        let task = URLSession.shared.dataTask(with: kategoriURL) { (data, respons, error) in
            
            if let serverSvar = data {
                let dekoder = JSONDecoder()
                
                let madRetkategorier = try? dekoder.decode(MadRetKategorier.self, from: serverSvar)
                
                completion(madRetkategorier?.kategorier)
            } else {
                print ("Ingen kategori svar fra serveren")
                if let fejl = error {
                    print (fejl.localizedDescription)
                }
                
                if let serverRespons = respons as? HTTPURLResponse {
                    print ("Server kode: \(serverRespons.statusCode)")
                }
                
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    // Funktion der laver en GET til at give os en liste over madretter inden for en given kategori.
    public func hentMenuKort(kategori: String, completion: @escaping ([MadRet]?) -> Void) {
        
        // Vi bygger en url
        let endPointUrl = basisUrl.appendingPathComponent("menu")
        
        var urlDele = URLComponents(url: endPointUrl, resolvingAgainstBaseURL: true)!
        
        // En Objekt af URL Dele
        urlDele.queryItems = [URLQueryItem(name: "category", value: kategori)]
        
        // giv mig den færdige url med de forskellige parametre
        let menuKortUrl = urlDele.url!
        
        // Vi laver en task
        let task = URLSession.shared.dataTask(with: menuKortUrl) { (data, respons, error) in
            
            // TODO kode selve logikken. Hvad skal der ske med det data vi får retur.
            if let serverSvar = data {
                let dekoder = JSONDecoder()
                
                let madRetter = try? dekoder.decode(MadRetter.self, from: serverSvar)
                
                completion(madRetter?.madretter)
            } else {
                print ("Intet menukort svar fra serveren")
                if let serverRespons = respons as? HTTPURLResponse {
                    print ("Server kode: \(serverRespons.statusCode)")
                }
            }
        }
        
        task.resume()
        
    }
    
    // En funktion til at sende vores bestilling og få en ordrebekræftelse retur
    public func sendBestilling(valgteRetNumre: [Int], completion: @escaping (Int?) -> Void ) {
        
        let bestilURL = basisUrl.appendingPathComponent("order")
        
        // Når vi skal lave en POST skal vi ændre på Http kaldets header og det betyder at vi skal brue et objekt af typen URLRequest
        var request = URLRequest(url: bestilURL)
        
        // Jeg skal fortælle hvilken metode jeg vil anvende:
        // GET = Læst
        // POST = Opret
        // PUT = Opdater
        // DELETE = Slet
        request.httpMethod = "POST"
        
        // Vi skal fortælle hvilket format vores data er i (JSON)
        // det gør vi i HTTP header feltet Content-Type
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Posten forventer et array af heltal med key menuIds
        let data : [String : [Int]] = ["menuIds" : valgteRetNumre]
        
        // data skal laves om til JSON
        let jsonKoder = JSONEncoder()
        let jsonData = try? jsonKoder.encode(data)
        
        // Vi skal udfylde vores Body med vores JSON data
        request.httpBody = jsonData
        
        // Så skal vi have lavet kaldet
        let task = URLSession.shared.dataTask(with: request) { (data, respons, error) in
            // TODO: Hvad skal der ske med svaret
            if let serverSvar = data {
                let dekoder = JSONDecoder()
                
                let bekraeftelse = try? dekoder.decode(OrdreBekraeftelse.self, from: serverSvar)
                
                completion(bekraeftelse?.tilberedningstid)
            } else {
                print ("Ingen ordrebekræftelse fra serveren")
                if let serverRespons = respons as? HTTPURLResponse {
                    print ("Server kode: \(serverRespons.statusCode)")
                }
            }
        }
        
        task.resume()
    }
    
    // En funktion der henter et billede ud fra en url og kalder en completion handler med et UIImage objekt.
    public func hentBillede(fraUrl : URL , completion : @escaping (UIImage?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: fraUrl) { (data, respons, error) in
            
            // Test af om vi har fået data retur
            if let billedData = data {
                if let billed = UIImage(data: billedData) {
                    completion(billed)
                } else {
                    completion(nil)
                }
            }
        }
        
        task.resume()
    }
    
    // En funktion der henter et billede ud fra en url, og venter et antal sekunder (simulerer)  og kalder en completion handler med et UIImage objekt.
    public func hentBillede(fraUrl : URL , medForsinkelse : Bool , completion : @escaping (UIImage?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: fraUrl) { (data, respons, error) in
            
            // Test af om vi har fået data retur
            if let billedData = data {
                if let billed = UIImage(data: billedData) {
                    if medForsinkelse {
                        RestaurantController.simulerForsinkelse(forUrl: fraUrl)
                    }
                    completion(billed)
                } else {
                    completion(nil)
                }
            }
        }
        
        task.resume()
    }
    
    //MARK: Static
    static let shared = RestaurantController()
    
    static func simulerForsinkelse(forUrl : URL) {
        // Her laver vi en forsinkelse på mellem 0 og 4 sekunder
        let pauseSekunder = UInt32.random(in: 0...4)
        print ("Pause i \(pauseSekunder) for \(forUrl)")
        sleep(pauseSekunder)
    }
    
    // Navn på "radiosignal" notifikationsId som sendes når ordre opdateres.
    static let ordreOpdNotifikationsNavn = "dk.eat.just.ordreOpd"
}
