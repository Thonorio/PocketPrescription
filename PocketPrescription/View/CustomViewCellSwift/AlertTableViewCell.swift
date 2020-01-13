//
//  AlertTableViewCell.swift
//  PocketPrescription
//
//  Created by Tomas Honorio on 23/12/2019.
//  Copyright © 2019 Tomás Honório Oliveira. All rights reserved.
//

import UIKit

class AlertTableViewCell: UITableViewCell {

    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var alertState: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func alertViewInit( _ name: String?, _ state: Bool){
        alertLabel.text = name
        //alertState.state = state
    }
    @IBAction func switchNotification(_ sender: Any) {
        if(!alertState.isOn){
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["medication_alert_notification"])
        }
    }
}
