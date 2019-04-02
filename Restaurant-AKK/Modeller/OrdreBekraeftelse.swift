//
//  OrdreBekraeftelse.swift
//  Restaurant-AKK
//
//  Created by Henrik Gregersen on 22/01/2019.
//  Copyright © 2019 bidblog. All rights reserved.
//

import Foundation

struct OrdreBekraeftelse : Codable {
    let tilberedningstid : Int
    
    enum CodingKeys : String , CodingKey {
        case tilberedningstid = "preparation_time"
    }
}
