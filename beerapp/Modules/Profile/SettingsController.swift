//
//  SettingsTableViewController.swift
//  beerapp
//
//  Created by elaniin on 2/21/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit
import AccountKit
import HexColors
import UserNotifications
import CoreLocation
import NotificationCenter

class SettingsController: UITableViewController, CLLocationManagerDelegate {
    
    // MARK: - Let/Var
    var accountKit: AKFAccountKit!
    
    // MARK: - Outlets
    
    @IBOutlet weak var switch1: UISwitch!
    @IBOutlet weak var switch2: UISwitch!
    
    @IBOutlet weak var birthdateLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Ajustes"
        tableView.separatorInset = .zero
    
        setupUserData()
        setupCoinsItem()
        
        // initialize Account Kit
        if accountKit == nil {
            // may also specify AKFResponseTypeAccessToken
            self.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
        }
        
        let a = UserDefaults.standard.string(forKey: "switch1")
        let b = UserDefaults.standard.string(forKey: "switch2")
        
        switch1.isOn = a == "on"
        switch2.isOn = b == "on"
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkNotificationsAndLocationStatus), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if accountKit.currentAccessToken != nil {
            
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            let passtoSignUp = storyboard.instantiateViewController(withIdentifier: "PasswordRecoveryControllerID") as! PasswordRecoveryController
            
            self.navigationController!.pushViewController(passtoSignUp, animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        accountKit.logOut()
    }
    // MARK: - Table view data source
    
    // numberOfSections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
 
    
    // MARK: - IBACTIONS
    
    @IBAction func goToSettings(_ sender: UISwitch) {
        if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func closeSession(_ sender: Any) {
        
        UserDefaults().removeObject(forKey: "user_id")
        App.core.currentUser = nil
        
        App.core.switchStoryboard(name: "Session", viewControllerIdentifier: "firstResponderControllerID")
    }
    
    @IBAction func goToRecoveryPassword(_ sender: Any) {
        
        let inputState: String = UUID().uuidString
        let viewController: AKFViewController = accountKit.viewControllerForEmailLogin(withEmail: nil, state: inputState)  as AKFViewController
        viewController.enableSendToFacebook = true
        
        self.prepareLoginViewController(viewController)
        self.present(viewController as! UIViewController, animated: true, completion: nil)
    }
    
    
    
    // MARK: - LOADER/SETUP
    
    func setupUserData() {
        
        guard let user = App.core.currentUser else {
            print("JO: No user")
            return
        }
        
        self.emailLabel.text = user.email
        self.teamLabel.text = user.favoriteTeam
        self.birthdateLabel.text = user.birthdate
    }
    
    @objc func checkNotificationsAndLocationStatus() {
        
        // Notification switch
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            
            DispatchQueue.main.sync {
                self.switch1.isOn = settings.authorizationStatus == .authorized
            }
        }
        
        // Location switch
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                switch2.isOn = false
            case .authorizedAlways, .authorizedWhenInUse:
                switch2.isOn = true
            }
        } else {
            switch2.isOn = false
        }
    }
    
}
