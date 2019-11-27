//
//  Medication.swift
//  PocketPrescription
//
//  Created by Tomás Honório Oliveira on 22/11/2019.
//  Copyright © 2019 Tomás Honório Oliveira. All rights reserved.
//

import Foundation
import os

class Medication: NSObject, NSCoding {
    
    var name: String
    var packageQuantity: Int
    var category: String
    var levelOfImportance: LevelOfImportance
        
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("medication")
    
    struct PropertyKey {
        static let name = "name"
        static let packageQuantity = "packageQuantity"
        static let category = "category"
        static let levelOfImportance = "levelOfImportance"
    }
    
    init?(name: String, packageQuantity: Int, category: String, levelOfImportance: LevelOfImportance) {
        self.name = name
        self.packageQuantity = packageQuantity
        self.category = category
        self.levelOfImportance = levelOfImportance
    }

    required convenience init?(coder: NSCoder) {
        guard let name = coder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Medication object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let packageQuantity = coder.decodeInteger(forKey: PropertyKey.packageQuantity)
        
        guard let category = coder.decodeObject(forKey: PropertyKey.category) as? String else {
            os_log("Unable to decode the category for a Medication object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let levelOfImportance = coder.decodeObject(forKey: PropertyKey.levelOfImportance) as? LevelOfImportance else {
            os_log("Unable to decode the levelOfImportance for a Medication object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(name: name, packageQuantity: packageQuantity, category: category, levelOfImportance: levelOfImportance)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: PropertyKey.name)
        coder.encode(packageQuantity, forKey: PropertyKey.packageQuantity)
        coder.encode(category, forKey: PropertyKey.category)
        coder.encode(levelOfImportance, forKey: PropertyKey.levelOfImportance)
    }
    
     private func loadMedication() -> [Medication]? { do {
            let codedData = try Data(contentsOf: Medication.ArchiveURL)
            let medication = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(codedData) as? [Medication]
                os_log("Medication successfully loaded.", log: OSLog.default, type: .debug)
                return medication;
            } catch {
                os_log("Failed to load medication...", log: OSLog.default, type: .error)
                return nil
            }
    }
    
  
}
