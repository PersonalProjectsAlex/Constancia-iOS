//
//  DataRegisterViewController.swift
//  beerapp
//
//  Created by elaniin on 1/24/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit
import SwiftyBeaver
import Alamofire
import AccountKit
import HexColors

class DataRegisterController: UIViewController{
    
    // MARK: - Let/Var
    
    var facebookUser: FacebookUser?
    
    let constantsMessages = Constants()
    let constantsTitles = Titles()
    var isHighLighted:Bool = false
    var gender = String()
    var birthday = String()
    var userName = String()
    var accountKit: AKFAccountKit!
    var emailAccountKit = String()
    
    // MARK: - Outlets
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var womenButton: UIButton!
    @IBOutlet weak var manButton: UIButton!
    @IBOutlet weak var myTeamtextField: UITextField!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var replypasswordTextfield: UITextField!
    @IBOutlet weak var customNavigationItem: UINavigationItem!
    @IBOutlet weak var backItemButton: UIBarButtonItem!
    @IBOutlet weak var backUIView: UIView!
    @IBOutlet weak var loadButton: LoadingUIButton!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        backUIView.backgroundColor = HexColor("#1C2742")
        self.view.backgroundColor = HexColor("#1C2742")
        // initialize Account Kit
        if accountKit == nil {
            // may also specify AKFResponseTypeAccessToken
            self.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
        }
        
        accountKit.requestAccount { [weak self] (account, error) in
            
            if let error = error { SwiftyBeaver.error(error) }
                
            else if let emailAddress = account?.emailAddress, emailAddress.count > 0 {
                SwiftyBeaver.debug(emailAddress)
                self?.emailAccountKit = emailAddress
                
            }
        }
        
        super.viewDidLoad()
        SetUp()
        usernameTextfield.autocorrectionType = .no
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        accountKit.logOut()
    }
    
    // MARK: - Actions
    
    //Register validations and check
    @IBAction func registerAction(_ sender: Any) {
        
        guard let birthdate = birthdayTextField.text,
            !birthday.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                
                App.core.alert(message: Strings.birthdayEmpty, title: Strings.incompleteFields, at: self)
                return
        }
        
        guard let username = usernameTextfield.text,
        !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            
            App.core.alert(message: Strings.usernameEmpty, title: Strings.incompleteFields, at: self)
            return
        }
        
        guard username.count > 3 else {
            
            App.core.alert(message: Strings.usernameInvalid, title: Strings.incompleteFields, at: self)
            return
        }
        
        guard let name = nameTextfield.text,
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            
            App.core.alert(message: Strings.nameEmpty, title: Strings.incompleteFields, at: self)
            return
        }
        
        guard let password = passwordTextfield.text,
        !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            
            App.core.alert(message: Strings.passwordEmpty, title: Strings.incompleteFields, at: self)
            return
        }
        
        guard let confirmPassword = replypasswordTextfield.text,
            !confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && password == confirmPassword else {
                
                App.core.alert(message: Strings.confirmPasswordInvalid, title: Strings.incompleteFields, at: self)
                return
        }
        
        guard password.count > 5 else {
            
            App.core.alert(message: Strings.passwordInvalid, title: Strings.incompleteFields, at: self)
            return
        }
        
        guard !gender.isEmpty else {
            
            App.core.alert(message: Strings.genderEmpty, title: Strings.incompleteFields, at: self)
            return
        }
        
        
        var saveDate = String()
        let inFormatter = DateFormatter()
        inFormatter.dateFormat = "MM/DD/YYYY"
        
        
        if let trys = inFormatter.date(from: birthdate){
            let outFormatter = DateFormatter()
            outFormatter.dateFormat = "yyyy-MM-dd"
            
            
            let outStr = outFormatter.string(from: trys)
            saveDate = outStr
            print(outStr)
            
        } else {
            saveDate = birthdate
        }
        
        
        let params: Params = [
            "username": username,
            "password": password,
            "fbid": "-",
            "name": name,
            "birthdate": saveDate,
            "gender": gender,
            "favorite_team": myTeamtextField.text ?? "",
            "email": emailAccountKit
        ]
        
        loadButton.showLoading()
        
        UserManager().register(params: params) {
            response in
            
            guard let uid = response?.id, let status = response?.status, !status.isEmpty else{
                print("JO: No User ID")
                self.loadButton.hideLoading()
                return
            }
            
            
            if status  == "Username already exists" {
                
                App.core.alert(message: Strings.usernameExists, title: Strings.error, at: self)
                self.loadButton.hideLoading()
            }
            else if status == "Email already exists" {
                
                App.core.alert(message: Strings.emailExists, title: Strings.error, at: self)
                self.loadButton.hideLoading()
            }
            else if status == "User added succesfully" {
                
                UserDefaults.standard.set(uid, forKey: "user_id")
                self.accountKit.logOut()
                
                UserManager().getUserDetail(uid: uid) {
                    userResponse in
                    
                    self.loadButton.hideLoading()
                    
                    guard let user = userResponse?.result else {
                        
                        App.core.alert(message: Strings.serverError, title: Strings.error, at: self)
                        return
                    }
                    
                    UserDefaults.standard.set(uid, forKey: "user_id")
                    App.core.currentUser = user
                    self.performSegue(withIdentifier: "DataRegisterToTourController", sender: nil)
                }
            }
        }
    }
    
    
    func isValidDate(dateString: String) -> Bool {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        if let _ = dateFormatterGet.date(from: dateString) {
             print("format succeded")
            return true
        } else {
            print("erro with date format")
            return false
        }
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
        sender.text = sender.text?.replacingOccurrences(of: " ", with: "")
    }
    
    //SelectBirthday,action to set a date
    @IBAction func selectBirhtday(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        datePickerView.setYearValidation(year: 18)
        
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    
    //--- Actions with gender
    
    @IBAction func genderFemaleAction(_ sender: UIButton) {
        
        
        
        SwiftyBeaver.debug("women")
        self.gender = "f"
        self.womenButton.backgroundColor = Core.hexStringToUIColor(hex: "#009D9A")
        self.manButton.backgroundColor   = Core.hexStringToUIColor(hex: "#1C2742")
        self.manButton.setTitleColor(Core.hexStringToUIColor(hex: "#009D9A"), for: .normal)
        self.womenButton.setTitleColor(Core.hexStringToUIColor(hex: "#1C2742"), for: .normal)
        
        
        
    }
    
    @IBAction func genderMaleAction(_ sender: Any) {
        
        
        SwiftyBeaver.warning("man")
        self.gender = "m"
        self.manButton.backgroundColor   = Core.hexStringToUIColor(hex: "#009D9A")
        self.womenButton.backgroundColor = Core.hexStringToUIColor(hex: "#1C2742")
        self.womenButton.setTitleColor(Core.hexStringToUIColor(hex: "#009D9A"), for: .normal)
        self.manButton.setTitleColor(Core.hexStringToUIColor(hex: "#1C2742"), for: .normal)
        
    }
    
    
    //--
    
    
    //Back to main function
    
    @IBAction func backtoMain(_ sender: Any) {
        accountKit.logOut()
        
        
        let _ = navigationController?.popToRootViewController(animated: true)
        
    }
    
    
    // MARK: - Helpers/Initializers/Setups
    
    
    
    //General setup
    func SetUp(){
        
        //itembar
        Core.itembarbackground(controller: self, barTint: Core.hexStringToUIColor(hex: "#1C2643"), titleColor: Core.hexStringToUIColor(hex: "#59BCCA"))
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem?.tintColor = Core.hexStringToUIColor(hex: "#59BCCA")
        
        if  self.birthday == "nil"{
            self.birthdayTextField.text =  ""
        }
        
        
        //Check Gender
        if(self.gender == "male" && self.gender.isEmpty == false){
            SwiftyBeaver.warning("man")
            self.gender = "m"
            self.manButton.backgroundColor   = Core.hexStringToUIColor(hex: "#009D9A")
            self.womenButton.backgroundColor = Core.hexStringToUIColor(hex: "#1C2742")
            self.womenButton.setTitleColor(Core.hexStringToUIColor(hex: "#009D9A"), for: .normal)
            self.manButton.setTitleColor(Core.hexStringToUIColor(hex: "#1C2742"), for: .normal)
            
            
        }else if (self.gender == "female" && self.gender.isEmpty == false ){
            SwiftyBeaver.debug("women")
            self.gender = "f"
            self.womenButton.backgroundColor = Core.hexStringToUIColor(hex: "#009D9A")
            self.manButton.backgroundColor   = Core.hexStringToUIColor(hex: "#1C2742")
            self.manButton.setTitleColor(Core.hexStringToUIColor(hex: "#009D9A"), for: .normal)
            self.womenButton.setTitleColor(Core.hexStringToUIColor(hex: "#1C2742"), for: .normal)
            
        }else if(self.gender.isEmpty == true){
            SwiftyBeaver.warning("man")
            self.gender = "m"
            self.manButton.backgroundColor   = Core.hexStringToUIColor(hex: "#009D9A")
            self.womenButton.backgroundColor = Core.hexStringToUIColor(hex: "#1C2742")
            self.womenButton.setTitleColor(Core.hexStringToUIColor(hex: "#009D9A"), for: .normal)
            self.manButton.setTitleColor(Core.hexStringToUIColor(hex: "#1C2742"), for: .normal)
        }
        
        
        //Check birthday
        if self.birthday.description != "" {
            
            
            self.birthdayTextField.text = (self.birthday.description)
            
            
        }else if (self.birthday == "0000-00-00"){
            self.birthdayTextField.text = ""
        }
        
        
    }
    
    //Set te values changes
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        self.birthdayTextField.text = dateFormatter.string(from: sender.date)
        
    }
    
    
    
    
    
}


