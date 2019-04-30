//
//  OrdreSeddel.swift
//  Restaurant-AKK
//
//  Created by Henrik Gregersen on 09/04/2019.
//  Copyright © 2019 bidblog. All rights reserved.
//

import Foundation

struct OrdreSeddel : Codable {
    // Et array af madretter på ordresedlen
    var madRetter : [MadRet]
    
    // En initializer som kan lave en ordreseddel ud fra et array af madretter.
    init (madRetter: [MadRet] = []) {
        self.madRetter = madRetter
    }
    
    // Jeg laver en funktion til at tilføje en madret til ordren.
    public mutating func tilføjMadRet(madRet : MadRet) {
        self.madRetter.append(madRet)
    }
    
    // URL til ordreseddel variabel
    static var filURL : URL {
        // URL til brugerns Dokumenter
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let ordreFilUrl = documentURL.appendingPathComponent("ordreSeddel").appendingPathExtension("json")
        
        return ordreFilUrl
    }
}
