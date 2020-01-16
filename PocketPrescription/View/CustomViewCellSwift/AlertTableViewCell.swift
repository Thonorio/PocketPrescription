//
//  AlertTableViewCell.swift
//  PocketPrescription
//
//  Created by Tomas Honorio on 23/12/2019.
//  Copyright © 2019 Tomás Honório Oliveira. All rights reserved.
//

import UIKit
import CoreData

class AlertTableViewCell: UITableViewCell {

    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var alertState: UISwitch!
    
    var coreDataContext: NSManagedObjectContext?
    var alert: NSManagedObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func alertViewInit(_ name: String?, _ state: Bool){
        alertLabel.text = name
        alertState.isOn = state
    }
    
    @IBAction func switchNotification(_ sender: Any) {
        self.saveToCoreData()
        if(!alertState.isOn){
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["medication_alert_notification"])
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
