//
//  SignUpExtension.swift
//  beerapp
//
//  Created by elaniin on 1/22/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import Foundation
import AccountKit
import SwiftyBeaver

extension SignUpController: AKFViewControllerDelegate
{
    // MARK: - Helpers/Initializers/Setups
    
    

    
    func viewController(_ viewController: UIViewController!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        print("Login succcess with AccessToken")
        
        self.performSegue(withIdentifier: "showRegister", sender: self)
        //specify AKFResponseType.AccessToken
        self.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
        accountKit.requestAccount{
            (account, error) -> Void in
            
            //self.accountID.text = account?.accountID
            
                //if the user is logged with email
                //self.labeltype.text = "Email Address"
               // self.phoneornumber.text = account!.emailAddress
                
            SwiftyBeaver.debug("account!.emailAddress")
   
            
        }
    }
    
    
    
    
    func viewController(_ viewController: UIViewController!, didCompleteLoginWithAuthorizationCode code: String!, state: String!) {
        SwiftyBeaver.debug("si estaaaaaaa")
        
    }
    
    private func viewController(_ viewController: UIViewController!, didFailWithError error: NSError!) {
        print("We have an error \(error)")
        
        
        
    }
    
    func viewControllerDidCancel(_ viewController: UIViewController!) {
        print("The user cancel the login")
    }
    
    func prepareLoginViewController(_ loginViewController: AKFViewController) {
        
        loginViewController.delegate = self
        loginViewController.advancedUIManager = nil
        
        //Costumize the theme
        let theme:AKFTheme = AKFTheme.default()
        theme.headerBackgroundColor = Core.hexStringToUIColor(hex: "#1C2742")
        theme.headerTextColor = Core.hexStringToUIColor(hex: "#5ABFCC")
        theme.iconColor = Core.hexStringToUIColor(hex: "#5ABFCC")
        theme.inputTextColor = .white
        theme.inputBackgroundColor = Core.hexStringToUIColor(hex: "#1C2742")
        theme.backgroundColor = Core.hexStringToUIColor(hex: "#1C2742")
        theme.statusBarStyle = .default
        theme.textColor = .white
        theme.titleColor = .white
        theme.buttonDisabledBackgroundColor = Core.hexStringToUIColor(hex: "#487F86")
        theme.buttonBackgroundColor = Core.hexStringToUIColor(hex: "#5ABFCC")
        
        loginViewController.theme = theme
        loginViewController.defaultCountryCode = "SV"
        
        
    }
    

    
}
