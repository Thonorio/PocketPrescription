//
//  AddAlertHeaderFooterView.swift
//  PocketPrescription
//
//  Created by Tomás Honório Oliveira on 11/12/2019.
//  Copyright © 2019 Tomás Honório Oliveira. All rights reserved.
//

import UIKit

class AddAlertHeaderFooterView: UITableViewHeaderFooterView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    static let reuseIdentifier: String = String(describing: self)

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
