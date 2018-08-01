// NotifcationController.swift
// beerapp
//
// Created by elaniin on 3/14/18.
//Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit
import UserNotifications

class NotifcationController : UIViewController {
    
    @IBAction func allowNotifications(_ sender: UIButton) {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
            (success, error) in
            
            guard success else { return }
            
            DispatchQueue.main.sync {
                self.performSegue(withIdentifier: "NotificationsToTourSegue", sender: self)
            }
        }
    }
    
    @IBAction func allowLater(_ sender: UIButton) {
        performSegue(withIdentifier: "NotificationsToTourSegue", sender: self)
    }
    
}
