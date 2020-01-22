//
//  Message.swift
//  PocketPrescription
//
//  Created by Tomas Honorio on 22/01/2020.
//  Copyright © 2020 Tomás Honório Oliveira. All rights reserved.
//

import UIKit
import MessageUI

class Message: NSObject, MFMessageComposeViewControllerDelegate{
    func messageUsers(){
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Message Body"
            controller.recipients = ["964338318"]
            controller.messageComposeDelegate = self
            //self.present(controller, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //self.dismiss(animated: true, completion: nil)
    }
}
