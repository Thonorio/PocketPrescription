//
//  MedicationTableViewCell.swift
//  PocketPrescription
//
//  Created by Tomas Honorio on 23/12/2019.
//  Copyright © 2019 Tomás Honório Oliveira. All rights reserved.
//

import UIKit
import CoreData

protocol MedicationTableViewCellDelegate {
    func medicationShowInfoForCell(_ medication: NSManagedObject)
}

class MedicationTableViewCell: UITableViewCell {

    @IBOutlet weak var medicationImg: UIImageView!
    @IBOutlet weak var medicationLabel: UILabel!
    @IBOutlet weak var medicationInformation: UIButton!
    
    var delegate: MedicationTableViewCellDelegate?
    var medication: NSManagedObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func medicationViewInit(_ medication: NSManagedObject){
        let imageData = medication.value(forKey: "image") as? Data
        
        if(imageData != nil){
            self.medicationImg.image = UIImage(data:imageData!,scale:1.0)
        }
        
        self.medication = medication
        self.medicationLabel.text = medication.value(forKey: "name") as? String
    }
    
    @IBAction func medicationShowInfo(_ sender: Any) {
        self.delegate?.medicationShowInfoForCell(medication!)
    }
    
}
