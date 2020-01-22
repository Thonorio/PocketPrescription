//
//  Notification.swift
//  PocketPrescription
//
//  Created by Tomás Honório Oliveira on 17/01/2020.
//  Copyright © 2020 Tomás Honório Oliveira. All rights reserved.
//

import UIKit
import UserNotifications

class Notification: NSObject, UNUserNotificationCenterDelegate  {
    
    static var shared = Notification()
    
    // Create Base Notification
     func createNotification(_ identifier: String,_ title: String, _ subTitle: String, _ interval : Int,_ description : String){
         UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
             switch notificationSettings.authorizationStatus {
                 case .notDetermined:
                 self.requestAuthorization(completionHandler: { (success) in
                     guard success else { return}
                     
                     // Schedule Local Notification
                     self.scheduleLocalNotification(identifier, title, subTitle, 3, description)
                 })
                 case .authorized:
                 // Schedule Local Notification
                 self.scheduleLocalNotification(identifier, title, subTitle, 3, description)
                 case .denied:
                 print("Application Not Allowed to Display Notifications")
                 default: break
             }
         }
     }
     
     // Notification Center
    func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
         // Request Authorization
         UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
         if let error = error {
             print("Request Authorization Failed (\(error), \(error.localizedDescription))")
         }
             completionHandler(success)
         }
     }
     
     private func scheduleLocalNotification(_ identifier: String,_ title: String, _ subTitle: String, _ interval : Int,_ description : String ) {
         // Create Notification Content
         let notificationContent = UNMutableNotificationContent()
         // Configure Notification Content
         notificationContent.title = title
         notificationContent.subtitle = subTitle
         notificationContent.body = description
         // Add Trigger
        print(description)
         let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(interval), repeats: false)
         // Create Notification Request
         let notificationRequest = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: notificationTrigger)
         
         // Add Request to User Notification Center
         UNUserNotificationCenter.current().add(notificationRequest) { (error) in
             if let error = error {
                 print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
             }
         }
     }
    
    func cancelLocalNotification (_ identifier: String) {
         UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
             var identifiers: [String] = []
             for notification:UNNotificationRequest in notificationRequests {
                 if notification.identifier == identifier {
                     identifiers.append(notification.identifier)
                 }
             }
             UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
         }
     }
    
     
     func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
         
         completionHandler([.alert, .badge, .sound])
     }
    
}
