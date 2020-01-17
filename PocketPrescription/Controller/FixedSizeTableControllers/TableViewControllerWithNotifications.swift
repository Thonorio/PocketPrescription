//
//  TableViewControllerWithNotifications.swift
//  PocketPrescription
//
//  Created by Tomas Honorio on 15/01/2020.
//  Copyright © 2020 Tomás Honório Oliveira. All rights reserved.
//

import UIKit
import UserNotifications

class TableViewControllerWithNotifications: UITableViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure User Notification Center
        UNUserNotificationCenter.current().delegate = self
    }

    // MARK: - Notifications

    internal func createNotification(_ title: String, _ interval : String,_ medicationList : String ){
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
                case .notDetermined:
                    self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return}

                    // Schedule Local Notification
                    self.scheduleLocalNotification(title, interval, medicationList)
                    })
                case .authorized:
                    // Schedule Local Notification
                    self.scheduleLocalNotification(title, interval, medicationList)
                case .denied:
                    print("Application Not Allowed to Display Notifications")
                    default: break
            }
        }
    }

    // Notification Center
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            completionHandler(success)
        }
    }

    private func scheduleLocalNotification(_ title: String, _ interval : String,_ medicationList : String ) {
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()

        // Configure Notification Content
        notificationContent.title = title
        notificationContent.subtitle = interval
        notificationContent.body = medicationList
        
        // Transform the string with the hours into hours in seconds
        let delimiter = " ";
        let numberOfHours = Int((interval.components(separatedBy: delimiter)[0] ))!
        let hoursInSeconds = numberOfHours * 60 * 60
        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(hoursInSeconds), repeats: false)

        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "medication_alert_notification", content: notificationContent, trigger: notificationTrigger)

        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
    

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
    }

}
