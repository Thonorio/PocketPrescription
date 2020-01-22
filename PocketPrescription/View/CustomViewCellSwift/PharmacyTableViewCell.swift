//
//  PharmacyTableViewCell.swift
//  PocketPrescription
//
//  Created by Tomás Honório Oliveira on 27/12/2019.
//  Copyright © 2019 Tomás Honório Oliveira. All rights reserved.
//

import UIKit

class PharmacyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pharmacyName: UILabel!
    @IBOutlet weak var pharmacyLocation: UILabel!
    @IBOutlet weak var pharmacyPhoneNumber: UILabel!
    @IBOutlet weak var pharmacyDistance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func pharmacyInit(_ name: String, _ street: String, _ phoneNumber: String, _ distance: String) {
        self.pharmacyName?.text = name
        self.pharmacyLocation.text = street
        self.pharmacyPhoneNumber.text = phoneNumber
        self.pharmacyDistance.text = distance
    }
}
