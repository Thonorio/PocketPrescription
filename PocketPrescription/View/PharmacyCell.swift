//
//  PharmacyCell.swift
//  PocketPrescription
//
//  Created by Xavier Santos De Oliveira on 04/12/2019.
//  Copyright © 2019 Tomás Honório Oliveira. All rights reserved.
//

import UIKit

class PharmacyCell: UITableViewCell {
    

    @IBOutlet weak var pharmacyName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        }
    
    func cellInit(pharmacy : Pharmacy){
        
        self.pharmacyName.text = pharmacy.name
     /*   self.street.text = pharmacy.subLocality
        self.phoneNumber.text = pharmacy.phoneNumber
        // falta o phone number, mas aqui nao é mostrado
        self.distance.text = "10" // por calcular*/
    }
    
}
