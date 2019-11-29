//
//  PharmacyViewController.swift
//  PocketPrescription
//
//  Created by Xavier Santos De Oliveira on 29/11/2019.
//  Copyright © 2019 Tomás Honório Oliveira. All rights reserved.
//

import Foundation
import UIKit

class PharmacyViewController: UIViewController {

    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func switchViews(_ sender: UISegmentedControl){
        
        if sender.selectedSegmentIndex == 0{
            firstView.alpha = 1
            secondView.alpha = 0
        }else{
            firstView.alpha = 0
            secondView.alpha = 1
        }
    }

}
