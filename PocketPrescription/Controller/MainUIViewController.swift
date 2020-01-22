//
//  MainUIViewController.swift
//  PocketPrescription
//
//  Created by Tomas Honorio on 22/01/2020.
//  Copyright © 2020 Tomás Honório Oliveira. All rights reserved.
//

import UIKit

class MainUIViewController: UITabBarController {

    
    @IBOutlet var homeAlertCount: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 2
    }
}
