//
//  APIMedicationTableViewCell.swift
//  PocketPrescription
//
//  Created by Tomas Honorio on 18/01/2020.
//  Copyright © 2020 Tomás Honório Oliveira. All rights reserved.
//

import UIKit
import CoreData

protocol MedicationInclusionTableViewCellDelegate {
    func apiMedicationAddToMedications(_ medication: NSManagedObject,_ medicationState: Bool )
}

class APIMedicationTableViewCell: UITableViewCell {

    @IBOutlet weak var medicationImg: UIImageView!
    @IBOutlet weak var medicationLabel: UILabel!
    @IBOutlet weak var medicationState: UISwitch!
    
    var medication: NSManagedObject?
    var delegate: MedicationInclusionTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func medicationViewInit(_ medication: NSManagedObject){
        self.medication = medication
        self.medicationLabel.text = medication.value(forKey: "name") as? String
        self.medicationState.isOn = false
    }
    
    @IBAction func medicationAdd( _ sender: Any) {
        self.delegate?.apiMedicationAddToMedications(medication!, self.medicationState.isOn )
    }
    
}
