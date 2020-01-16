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
    
    var medicationsSelected: [NSManagedObject] = []
    var medication: NSManagedObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func medicationViewInit(_ imgName: String, _ name: String?){
        //medicationImg.image = UIImage(named: imgName)
        medicationLabel.text = name
        medicationState.isOn = false
    }
    
    @IBAction func switchNotification(_ sender: Any) {
print("ok")
print(medicationsSelected.contains(medication!))
       /* if(medicationsSelected.contains(medication!)){
            medicationState.isOn = true
        }else{
            medicationState.isOn = false
        }*/
        
    }
}
