//
//  MadRetTableViewCell.swift
//  Restaurant-AKK
//
//  Created by Henrik Gregersen on 19/03/2019.
//  Copyright © 2019 bidblog. All rights reserved.
//

import UIKit

class MadRetTableViewCell: UITableViewCell {

    @IBOutlet weak var madRetImageView: UIImageView!
    
    @IBOutlet weak var madRetNavnLabel: UILabel!
    
    @IBOutlet weak var prisLabel: UILabel!
    
    
    @IBOutlet weak var spinderView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // Vi laver en funktion der styrer visning af billede eller spinner
    func opdaterBillede(medBillede : UIImage?) {
        if let billede = medBillede {
            self.madRetImageView.image = billede
            // Så laver vi en animation hvor vi fader mellem billede og spinner
            self.madRetImageView.alpha = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.madRetImageView.alpha = 1.0
                self.spinderView.alpha = 0
            }) { (_) in
                self.spinderView.startAnimating()
            }
        } else {
            self.madRetImageView.image = nil
            self.madRetImageView.alpha = 0
            self.spinderView.alpha = 1.0
            self.spinderView.startAnimating()
        }
    }
    
}
