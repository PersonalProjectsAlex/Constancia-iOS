//
//  PasswordRecoverController.swift
//  beerapp
//
//  Created by elaniin on 2/21/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit
import AccountKit
import SwiftyBeaver

class PasswordRecoverController: UIViewController {
    
    // MARK: - LET/VAR
    
    var accountKit: AKFAccountKit!
    var emailAccountKit = String()
    
    // MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.setUp()
        
        // initialize Account Kit
        self.getAccountkit()
         SwiftyBeaver.debug(emailAccountKit)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        accountKit.logOut()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        accountKit.logOut()
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // TODO: - Add destinations
    }
    
    
    // MARK: - Actions
    func setUp(){
        let backButton = UIButton(type: .custom)
        
        backButton.setTitle("< Regresar", for: .normal)
        backButton.setTitleColor(backButton.tintColor, for: .normal) // You can change the TitleColor
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        Core.itembarbackground(controller: self, barTint: Core.hexStringToUIColor(hex: "#1C2643"), titleColor: Core.hexStringToUIColor(hex: "#59BCCA"))
        self.navigationItem.leftBarButtonItem?.tintColor = Core.hexStringToUIColor(hex: "#59BCCA")
    }
    
    // MARK: - Helpers/Initializers/Setups
    @objc func backAction(_ sender: UIButton) {
        
        print("Back")
        
        let _ = navigationController?.popToRootViewController(animated: true)
    }
    
    
    func getAccountkit(){
        if accountKit == nil {
            // may also specify AKFResponseTypeAccessToken
            self.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
        }
        
        accountKit.requestAccount { [weak self] (account, error) in
            if let error = error {
                SwiftyBeaver.error(error)
            } else {
                
                
                if let emailAddress = account?.emailAddress, emailAddress.count > 0 {
                    SwiftyBeaver.debug(emailAddress)
                    self?.emailAccountKit = emailAddress
                    
                    let params: [String: Any] = [
                        "email": emailAddress
                    ]
                    self?.callForgotPassword(params: params)
                    
                }
            }
        }
    }
    
    
    func callForgotPassword(params: [String: Any]){
        
        UserManager().forgotPassword(params: params) { (response) in
           print(response?.status)
            
            if response?.status == "User not found"{
                Core.alert(message: Constants().userNotFound, title: Titles().somethingWrong, at: self)
            }else if response?.status == "Password updated"{
                Core.alert(message: Constants().successPasswordChange, title: Titles().Success, at: self)
            }
            
          
            
        }
    }
    
}

