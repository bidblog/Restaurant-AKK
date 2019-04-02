//
//  Kategorier.swift
//  Restaurant-AKK
//
//  Created by Henrik Gregersen on 22/01/2019.
//  Copyright © 2019 bidblog. All rights reserved.
//

import Foundation

// Vi laver en model til at rumme et array af strenge.
/* Refactoret
struct Kategorier : Codable {
    let kategorier : [String]
    
    enum CodingKeys : String, CodingKey {
        case kategorier = "categories"
    }
}
*/

struct MadRetKategorier : Codable {
    let kategorier : [String]
    
    enum CodingKeys : String, CodingKey {
        case kategorier = "categories"
    }
}

