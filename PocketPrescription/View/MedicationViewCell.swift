//
//  MedicationViewCell.swift
//  PocketPrescription
//
//  Created by Tomás Honório Oliveira on 21/11/2019.
//  Copyright © 2019 Tomás Honório Oliveira. All rights reserved.
//

import UIKit

class MedicationViewCell: UITableViewCell {
    
    @IBOutlet weak var medicationImg: UIImageView!
    @IBOutlet weak var medicationName: UILabel!
    @IBOutlet weak var medicationInformation: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("selected")
        // Configure the view for the selected state
    }

}
