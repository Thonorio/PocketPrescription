//
//  AlertsViewCell.swift
//  PocketPrescription
//
//  Created by Tomás Honório Oliveira on 21/11/2019.
//  Copyright © 2019 Tomás Honório Oliveira. All rights reserved.
//

import UIKit

class AlertViewCell: UITableViewCell {

    @IBOutlet weak var alertName: UILabel!
    @IBOutlet weak var alertState: UISwitch!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}