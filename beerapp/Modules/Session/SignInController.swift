//
//  SignInViewController.swift
//  App
//
//  Created by Jonathan Solorzano on 1/15/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FacebookCore
import FacebookLogin
import SwiftyBeaver
import AccountKit

class SignInController: UIViewController {
    
    // MARK: - LET/VAR
    
    var recoverPasswordString = "Olvidaste tu contraseña? Recuperala"
    var myMutableString = NSMutableAttributedString()
    
    var accountKit: AKFAccountKit?
    var accountKitController: AKFViewController?
    var facebookUser: FacebookUser?
    
    // MARK: - IBOUTLET
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var forgotPassButton: UIButton!
    
    // MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let inputState = UUID().uuidString
        
        setupForgotPasswordButton()
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)
        
        accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
        accountKitController = accountKit?.viewControllerForEmailLogin(withEmail: nil, state: inputState)
        
        accountKitController?.delegate = self
        accountKitController?.advancedUIManager = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        AppDelegate().window?.rootViewController = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - NAVIGATION
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SignInToDataRegisterSegue" {
            
            let dataRegisterController = segue.destination as! DataRegisterController
            dataRegisterController.facebookUser = facebookUser
        }
    }
    
    // MARK: - SETUP
    
    fileprivate func setupForgotPasswordButton() {
        
        let attributedString = NSMutableAttributedString(string: "Olvidaste tu contraseña? Recuperala", attributes: [
            .font: UIFont(name: "Lato-Regular", size: 12.0)!,
            .foregroundColor: UIColor(white: 1.0, alpha: 1.0)
            ])
        attributedString.addAttributes([
            .font: UIFont(name: "Lato-Bold", size: 12.0)!,
            .foregroundColor: UIColor("55bfcd")
            ], range: NSRange(location: 25, length: 10))
        
        forgotPassButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    // MARK: - IBACTION
    
    @IBAction func signUpWithEmail(_ sender: UIButton) {

        accountKitController?.enableSendToFacebook = true
        
        prepareLoginViewController(accountKitController)
        present(accountKitController as! UIViewController, animated: true, completion: nil)
    }
    
    
    //Login with facebook request
    @IBAction func signUpWithFacebook(_ sender: UIButton) {
        
        let loginManager = LoginManager()
        
        let readPermissions: [ReadPermission] = [ .publicProfile, .email, .userFriends, .custom("user_posts")]
        
        loginManager.logIn(readPermissions: readPermissions, viewController: self) {
            loginResult in
            
            guard case .success = loginResult else { return }

            guard let accessToken = AccessToken.current else { return }
            
            let facebookAPIManager = FacebookAPIManager(accessToken: accessToken)
            
            facebookAPIManager.requestFacebookUser {
                facebookUser in
                
                self.facebookUser = facebookUser
                
                // TODO: Validate if email is registered and signin or signup
            }
        }
    }
    
    @IBAction func signIn(_ sender: LoadingUIButton) {
        
        guard let username = usernameField.text,
            !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                
                App.core.alert(message: Strings.invalidUsernameOrPassword, title: Strings.error, at: self)
                return
        }
        
        guard let password = passwordField.text,
            !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                
                App.core.alert(message: Strings.invalidUsernameOrPassword, title: Strings.error, at: self)
                return
        }
        
        let params: Params = [
            "username": username,
            "password": password
        ]
        
        sender.showLoading()
        
        UserManager().logIn(params: params) {
            response in
            
            guard let uid = response?.id else {
                
                App.core.alert(message: Strings.invalidUsernameOrPassword, title: Strings.error, at: self)
                sender.hideLoading()
                return
            }
            
            UserManager().getUserDetail(uid: uid) {
                userResponse in
                
                guard let user = userResponse?.result else {
                    
                    App.core.alert(message: Strings.invalidUsernameOrPassword, title: Strings.error, at: self)
                    return
                }
                
                UserDefaults.standard.set(uid, forKey: "user_id")
                App.core.currentUser = user
                sender.hideLoading()
                self.performSegue(withIdentifier: "SIgnInToTourController", sender: nil)
            }
        }
    }
    
    // MARK: - HELPER
    
    func prepareLoginViewController(_ loginViewController: AKFViewController?) {
        
        //Costumize the theme
        
        let theme: AKFTheme = AKFTheme.default()
        theme.headerBackgroundColor = UIColor("1C2742") ?? .white
        theme.headerTextColor = UIColor("5ABFCC") ?? .white
        theme.iconColor = UIColor("5ABFCC") ?? .white
        theme.inputTextColor = .white
        theme.inputBackgroundColor = UIColor("1C2742") ?? .white
        theme.backgroundColor = UIColor("1C2742") ?? .white
        theme.statusBarStyle = .default
        theme.textColor = .white
        theme.titleColor = .white
        theme.buttonDisabledBackgroundColor = UIColor("487F86") ?? .white
        theme.buttonBackgroundColor = UIColor("5ABFCC") ?? .white
        
        loginViewController?.theme = theme
        loginViewController?.defaultCountryCode = "SV"
    }
    
}

extension SignInController: AKFViewControllerDelegate {
    
    func viewController(_ viewController: UIViewController!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        Log.debug("Login succcess with AccessToken")
    }
    
    func viewController(_ viewController: UIViewController!, didCompleteLoginWithAuthorizationCode code: String!, state: String!) {
        Log.debug("Login succcess with AuthorizationCode")
    }
    
    private func viewController(_ viewController: UIViewController!, didFailWithError error: NSError!) {
        Log.debug("We have an error \(error)")
    }
    
    func viewControllerDidCancel(_ viewController: UIViewController!) {
        Log.debug("The user cancel the login")
    }
    
}
