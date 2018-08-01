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

class SignInViewController: UIViewController{
    

    // MARK: - Let/Var
    private let readPermissions: [ReadPermission] = [ .publicProfile, .email, .userFriends, .custom("user_posts") ]

    private let paramsGraph                       = ["fields": "id, name, first_name, last_name, email, gender, birthday"]

    var recoverPasswordString                    = "Olvidaste tu contraseña? Recuperala"

    var myMutableString = NSMutableAttributedString()
    
    // MARK: - Outlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var passwordRecoverTextField: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)
        self.setUp()
        
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // TODO: - Add destinations
    }
    
    // MARK: - Actions
    
    @IBAction func loginFacebook(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: readPermissions, viewController: self, completion: didReceiveFacebookLoginResult)
    }
    
    
    
    @IBOutlet weak var recoverPassword: UIButton!
    
    
    
    
    // MARK: - Helpers/Initializers/Setups
    
    func setUp(){
       Core.setColorbyStringLength(myMutableString: self.myMutableString, text: self.recoverPasswordString, firstcolor: Core.hexStringToUIColor(hex: "#5ABFCC"), firstlocation: 25, firstlength: 10, secondcolor: .white, secondlocation: 0, secondlength: 24, button: self.passwordRecoverTextField)
    }
    
    
    
    private func didReceiveFacebookLoginResult(loginResult: LoginResult) {
        
        switch loginResult {
        case .success:
            didLoginWithFacebook()
        case .failed(_): break
        default: break
        }
    }
    
    private func didLoginWithFacebook() {
        // Successful log in with Facebook
        if let accessToken = AccessToken.current {
            let facebookAPIManager = FacebookAPIManager(accessToken: accessToken)
            facebookAPIManager.requestFacebookUser(completion: { (facebookUser) in
                if let _ = facebookUser.email {
                    let info = "First name: \(facebookUser.firstName!) \n Last name: \(facebookUser.lastName!) \n Email: \(facebookUser.email!)"
                    
                    self.didLogin(method: "Facebook", info: info)
                }
            })
        }
    }
    
    private func didLogin(method: String, info: String) {
        

        if((FBSDKAccessToken.current()) != nil){
            
            let graphRequest = GraphRequest(graphPath: "me", parameters: self.paramsGraph)
            graphRequest.start {
                (urlResponse, requestResult) in
                
                switch requestResult {
                case .failed(let error):
                    print("error in graph request:", error)
                    break
                case .success(let graphResponse):
                    
                    
                    if let responseDictionary = graphResponse.dictionaryValue {
                        print(responseDictionary)
                        let storyboard = UIStoryboard(name: "Session", bundle: nil)
                        let passtoSignUp = storyboard.instantiateViewController(withIdentifier: "DataRegisterViewControllerID") as! DataRegisterViewController
                        passtoSignUp.gender = responseDictionary["gender"] as! String
                        passtoSignUp.birthday = responseDictionary["birthday"] as! String
                        
                        self.present(passtoSignUp, animated: true , completion: nil)
                        
                    }
                }
            }
        }
       
    }
    
    
    
    
    


}
