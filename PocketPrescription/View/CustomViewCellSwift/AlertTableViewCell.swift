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
    
    func alertViewInit(_ alert: NSManagedObject){
        self.alert = alert
        self.alertLabel.text = alert.value(forKey: "name") as? String
        self.alertState.isOn = alert.value(forKey: "state") as! Bool
    }
    
    @IBAction func switchNotification(_ sender: Any) {
        self.saveToCoreData()
        if(!alertState.isOn){
            Notification.shared.cancelLocalNotification(self.alert!.value(forKey: "identifier") as! String)
        }else{
            var medicationString = ""
            let medications = self.alert!.value(forKey: "medications") as! NSSet
            for medication in medications {
                medicationString += ((medication as AnyObject).value(forKey: "name") as? String  ?? "") + " "
            }
            let description = "Remeber to take: \(medicationString)"
            let hoursInSeconds = timeToSeconds(self.alert!.value(forKey: "repeatInterval") as! String)
            Notification.shared.createNotification(self.alert!.value(forKey: "identifier") as! String, self.alert!.value(forKey: "name") as! String, self.alert!.value(forKey: "repeatInterval") as! String, hoursInSeconds, description
            )
        }
    }
    
    
    func timeToSeconds(_ time: String) -> Int{
        let delimiter = " ";
        let numberOfHours = Int(time.components(separatedBy: delimiter)[0] )!
        let hoursInSeconds = numberOfHours * 60 * 60
        return hoursInSeconds
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
