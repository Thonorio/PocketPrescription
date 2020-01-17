//
//  PersonOfTrustTableViewCell.swift
//  PocketPrescription
//
//  Created by Tomas Honorio on 17/01/2020.
//  Copyright © 2020 Tomás Honório Oliveira. All rights reserved.
//

import UIKit
import CoreData

class PersonOfTrustTableViewCell: UITableViewCell {

    @IBOutlet weak var personOfTrustLabel: UILabel!
    @IBOutlet weak var personOfTrustPhoneNumber: UILabel!
    @IBOutlet weak var personOfTrustState: UISwitch!
    
    var coreDataContext: NSManagedObjectContext?
    var personOfTrust: NSManagedObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func personOfTrustViewInit(_ personOfTrust: NSManagedObject){
        self.personOfTrust = personOfTrust
        personOfTrustLabel.text = personOfTrust.value(forKey: "name") as? String
        personOfTrustPhoneNumber.text = String(personOfTrust.value(forKey: "phoneNumber") as! Int)
        personOfTrustState.isOn = personOfTrust.value(forKey: "state") as? Bool ?? false
    }
    
    @IBAction func switchPersonOfTrust(_ sender: Any) {
        self.saveToCoreData()
    }
    
    
    func saveToCoreData(){
        personOfTrust!.setValue(personOfTrustState.isOn, forKey: "state")
        
        do {
            try coreDataContext!.save()
        } catch {
            print("Failed saving")
        }
    }
}
