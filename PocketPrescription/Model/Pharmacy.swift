//
//  Pharmacy.swift
//  PocketPrescription
//
//  Created by Tomás Honório Oliveira on 22/11/2019.
//  Copyright © 2019 Tomás Honório Oliveira. All rights reserved.
//

import Foundation

class Pharmacy {
    
    var pharmacyName: String
    var pharmacyStreet: String
    var pharmacyState: String
    var pharmacyPhoneNumber: UInt64
    
    init(pharmacyName : String,pharmacyStreet : String, pharmacyState : String, pharmacyPhoneNumber : UInt64) {
        
        self.pharmacyName = pharmacyName
        self.pharmacyStreet = pharmacyStreet
        self.pharmacyState = pharmacyState
        self.pharmacyPhoneNumber = pharmacyPhoneNumber
    }
}
