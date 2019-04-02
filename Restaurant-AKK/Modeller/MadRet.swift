//
//  MadRet.swift
//  Restaurant-AKK
//
//  Created by Henrik Gregersen on 22/01/2019.
//  Copyright © 2019 bidblog. All rights reserved.
//

import Foundation

// BARE EN KOMMENTAR...

struct MadRet : Codable {

    // Det rå format som det ser ud i vore JSON
    /*
    var description : String
    var name : String
    var image_url : String
    var id : Int
    var price : Double
    var category : String
    */
    
    var beskrivelse : String
    var navn : String
    var billedUrl : URL
    var retNummer : Int
    var pris : Double
    var kategori : String
    
    // Her laver vi mapning mellem extern feltnavn og internt feltnavn
    enum CodingKeys : String , CodingKey {
        case beskrivelse = "description"
        case navn = "name"
        case billedUrl = "image_url"
        case retNummer = "id"
        case pris = "price"
        case kategori = "category"
    }
    
    // Fordi vi bruger alle felter i JSON typen skal vi ikke implementere init(from:) når vi har lavet vores feltmapning med enum CodingKeys
}

// Denne model her bruger vi til at få menukortet i
struct MadRetter : Codable {
    let madretter : [MadRet]
    
    enum CodingKeys : String , CodingKey {
        case madretter = "items"
    }
}
