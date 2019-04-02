//
//  BestilKnap.swift
//  Restaurant-AKK
//
//  Created by Henrik Gregersen on 12/02/2019.
//  Copyright © 2019 bidblog. All rights reserved.
//

import UIKit

class BestilKnap: UIButton {

    // Vi overtyrer normal initializere
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    // Vi overstyrer også krævet initialiser for at storyboard virker..
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // Funktion der laver det visuelle til knappen
    private func setup() {
        // Afrundede hjørner
        layer.cornerRadius = 5.0
        
        // Vi laver skygge til knappen
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset  = CGSize(width: 2, height: 2)
        layer.shadowRadius  = 5
    }
    
    // Funktion der kan animere et klik på knappen
    public func klikAnimation() {
        UIView.animate(withDuration: 0.3) {
            self.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
            self.transform = CGAffineTransform.identity
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
