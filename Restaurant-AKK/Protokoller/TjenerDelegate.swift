//
//  TjenerDelegate.swift
//  Restaurant-AKK
//
//  Created by Henrik Gregersen on 19/02/2019.
//  Copyright © 2019 bidblog. All rights reserved.
//

import Foundation

// At tilføje madretten til ordren er en opgave vi i bestillingsskærmbilledet uddelegerer (Delegate)
// Typisk vil der stå en fysisk tjener og tage imod en bestilling og skrive det på ordresedlen. Og det er det vi simulere

protocol TjenerDelegate {
    func madRetTilOrdren(madRet : MadRet)
}
