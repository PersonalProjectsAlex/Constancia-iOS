//
//  PasswordRecoveryViewController.swift
//  beerapp
//
//  Created by elaniin on 1/19/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit
import AccountKit

class PasswordRecoveryController: UIViewController {
    
    // MARK: - Let/Var
    
    var accountKit: AKFAccountKit!
    // MARK: - Outlets
    
    @IBOutlet weak var passwordTextfield: LinedTextField!
    @IBOutlet weak var replyPasswordTextField: LinedTextField!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Calling my general functions
        self.setUp()
        
        
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
        // initialize Account Kit
        if accountKit == nil {
            // may also specify AKFResponseTypeAccessToken
            self.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
        }
        
        
    }
    
    @IBAction func checkPassword(_ sender: UIButton) {
        if self.passwordTextfield.text?.isEmpty ?? true || (self.passwordTextfield.text?.trimmingCharacters(in: .whitespaces).isEmpty)!{
            
            Core.alert(message: Constants().passwordempty, title: Titles().empty, at: self)
            
        }else if self.replyPasswordTextField.text?.isEmpty ?? true || (self.replyPasswordTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)!{
            
            Core.alert(message: Constants().replypassword, title: Titles().empty, at: self)
            
        }else if self.replyPasswordTextField.text != self.passwordTextfield.text{
            
            Core.alert(message: Constants().samepassword, title: Titles().password, at: self)
            
        }else{
            
            guard let uid = App.core.currentUser?.id else {
                print("JO: getUserInfo: No UID")
                return
            }
            
            let params: [String: Any] = [
                "user": uid,
                "password": self.passwordTextfield.text!
            ]
            UserManager().updatePassword(params: params) { (response) in
                if response?.status == "Password updated succesfully"{
                    Core.alert(message: Constants().successPasswordUpdated, title: Titles().Success, at: self)
                }else{
                     Core.alert(message: Constants().errorPasswordUpdated, title: Titles().somethingWrong, at: self)
                }
            }
        }
    }
    
    
    
    // MARK: - Helpers/Initializers/Setups
    @objc func backAction(_ sender: UIButton) {
        
        print("Back")
        
        let _ = navigationController?.popToRootViewController(animated: true)
    }
}

