//
//  RecoverPasswordController.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 3/18/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit

class RecoverPasswordController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    
    @IBAction func recoverPassword(_ sender: LoadingUIButton) {
        
        sender.showLoading()
        
        guard let email = emailField.text, App.core.validate(email: email) else {
            
            App.core.alert(message: Strings.emailInvalid, title: Strings.error, at: self)
            return
        }
        
        let params: Params = ["email": email]
        
        UserManager().forgotPassword(params: params) {
            response in
            
            sender.hideLoading()
            
            guard response?.status == "Password updated" else {
                
                App.core.alert(message: Strings.userNotFound, title: Strings.error, at: self)
                return
            }
            
            App.core.alert(message: Strings.passwordChangedSuccessfully, title: Strings.success, at: self)
        }
    }
    
    
}
