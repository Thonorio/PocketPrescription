//
//  MedicationInclusionTableViewCell.swift
//  PocketPrescription
//
//  Created by Tomas Honorio on 23/12/2019.
//  Copyright © 2019 Tomás Honório Oliveira. All rights reserved.
//

import UIKit
import CoreData

class MedicationInclusionTableViewCell: UITableViewCell {

    @IBOutlet weak var medicationImg: UIImageView!
    @IBOutlet weak var medicationLabel: UILabel!
    @IBOutlet weak var medicationState: UISwitch!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func medicationViewInit(_ medication: NSManagedObject, _ medicationsSelected: [NSManagedObject]){
        let imageData = medication.value(forKey: "image") as? Data
        if(imageData != nil) {
            self.medicationImg.image = UIImage(data:imageData!,scale:1.0)
        }
        self.medicationLabel.text = medication.value(forKey: "name") as? String
        self.medicationState.isOn = medicationsSelected.contains(medication)
    }
    
}
