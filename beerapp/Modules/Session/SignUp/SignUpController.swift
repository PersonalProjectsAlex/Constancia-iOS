//
//  SignUpViewController.swift
//  App
//
//  Created by Jonathan Solorzano on 1/15/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit
import AccountKit
import SwiftyBeaver
import IQKeyboardManagerSwift

class SignUpController: UIViewController {
    
    // MARK: - Let/Var
    var accountKit = AKFAccountKit(responseType: .accessToken)
    var openRegistrationString = "Si no posees cuenta Registrate"
    var myMutableString = NSMutableAttributedString()
    
    var registerState = Bool()
    
    // MARK: - Outlets
    
    @IBOutlet weak var openRegistrationButton: UIButton!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (accountKit.currentAccessToken != nil && self.registerState == true) {
            // if the user is already logged in, go to the main screen
            SwiftyBeaver.debug("User is already logged")
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "showRegister", sender: self)
                
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }

    // MARK: - Actions
    
    @IBAction func signUp(_ sender: Any) {
        self.registerState = true
        //login with Phone
        let inputState: String = UUID().uuidString
        let viewController: AKFViewController = accountKit.viewControllerForEmailLogin(withEmail: nil, state: inputState)  as! AKFViewController
        viewController.enableSendToFacebook = true
        
        self.prepareLoginViewController(viewController)
        self.present(viewController as! UIViewController, animated: true, completion: nil)
        
    }
    

    // MARK: - Helpers/Initializers/Setups
    
    func setUp(){
        
        self.navigationController?.isNavigationBarHidden = true
        // initialize Account Kit
        if accountKit == nil {
            // may also specify AKFResponseTypeAccessToken
            self.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
        }
        
        Core.shared.setbackground(image: #imageLiteral(resourceName: "signup-background"),view: self.view)
        
        Core.setColorbyStringLength(myMutableString: self.myMutableString, text: self.openRegistrationString, firstcolor: Core.hexStringToUIColor(hex: "#5abfcc"), firstlocation: 20, firstlength: 10, secondcolor: .white, secondlocation: 0, secondlength: 19, button: self.openRegistrationButton)
    }
    
}

