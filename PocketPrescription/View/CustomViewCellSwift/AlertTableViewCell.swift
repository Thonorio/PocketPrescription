//
//  AlertTableViewCell.swift
//  PocketPrescription
//
//  Created by Tomas Honorio on 23/12/2019.
//  Copyright © 2019 Tomás Honório Oliveira. All rights reserved.
//

import UIKit
import CoreData

protocol AlertTableViewCellDelegate {
    func cancelNotification(_ identifier: String)
}

class AlertTableViewCell: UITableViewCell {

    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var alertState: UISwitch!
    
    
    var delegate: AlertTableViewCellDelegate?
    var coreDataContext: NSManagedObjectContext?
    var alert: NSManagedObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func alertViewInit(_ alert: NSManagedObject){
        self.alert = alert
        self.alertLabel.text = alert.value(forKey: "name") as? String
        self.alertState.isOn = alert.value(forKey: "state") as! Bool
    }
    
    @IBAction func switchNotification(_ sender: Any) {
        self.saveToCoreData()
        if(!alertState.isOn){
            self.delegate?.cancelNotification(self.alert!.value(forKey: "identifier") as! String)
        }
    }
    
    func saveToCoreData(){
        alert!.setValue(alertLabel.text, forKey: "name")
        alert!.setValue(alertState.isOn, forKey: "state")
        
        do {
            try coreDataContext!.save()
        } catch {
            print("Failed saving")
        }
    }
   
}
