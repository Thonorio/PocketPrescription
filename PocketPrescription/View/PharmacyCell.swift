//
//  PharmacyCell.swift
//  PocketPrescription
//
//  Created by Xavier Santos De Oliveira on 04/12/2019.
//  Copyright © 2019 Tomás Honório Oliveira. All rights reserved.
//

import UIKit

class PharmacyCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        }
    
    func cellInit(pharmacy : Pharmacy){
        /*
        self.pharmacyNameLabel.text = pharmacy.pharmacyName
        self.pharmacyStreetLabel.text = pharmacy.pharmacyStreet
        self.pharmacyStateLabel.text = pharmacy.pharmacyState
        // falta o phone number, mas aqui nao é mostrado
        self.pharmacyDistanceLabel.text = "10" // por calcular
 */
    }
    
}
