//
//  OrdreSeddel.swift
//  Restaurant-AKK
//
//  Created by Henrik Gregersen on 09/04/2019.
//  Copyright © 2019 bidblog. All rights reserved.
//

import Foundation

struct OrdreSeddel {
    // Et array af madretter på ordresedlen
    var madRetter : [MadRet]
    
    // En initializer som kan lave en ordreseddel ud fra et array af madretter.
    init (madRetter: [MadRet] = []) {
        self.madRetter = madRetter
    }
}
