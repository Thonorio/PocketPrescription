//
//  MedicationTableViewCell.swift
//  PocketPrescription
//
//  Created by Tomas Honorio on 23/12/2019.
//  Copyright © 2019 Tomás Honório Oliveira. All rights reserved.
//

import UIKit
import CoreData

class MedicationTableViewCell: UITableViewCell {

    @IBOutlet weak var medicationImg: UIImageView!
    @IBOutlet weak var medicationLabel: UILabel!
    @IBOutlet weak var medicationInformation: UIButton!
    
    var coreDataContext: NSManagedObjectContext?
    var medication: NSManagedObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func medicationViewInit(_ imgName: String, _ name: String?, _ information: String){
        //medicationImg.image = UIImage(named: imgName)
        medicationLabel.text = name
    }
    
    func saveToCoreData(){
       /* medication!.setValue(alertLabel.text, forKey: "name")
        medication!.setValue(alertState.isOn, forKey: "state")*/
        
        do {
            try coreDataContext!.save()
        } catch {
            print("Failed saving")
        }
    }
}
