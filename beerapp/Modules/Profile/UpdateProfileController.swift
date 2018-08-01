//
//  UpdateProfileControllerTableViewController.swift
//  beerapp
//
//  Created by elaniin on 3/9/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit

class UpdateProfileController: UITableViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var teamTextField: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let uid = App.core.currentUser?.id else {
            print("JO: No UID")
            return
        }
        
        UserManager().summaryOf(uid: uid) {
            response in
            
            if let user = response?.result, response?.status == "true" {
                
                if let username = response?.result?.username{
                    self.usernameTextField.text = username
                }
                if let username = response?.result?.favoriteTeam{
                    self.teamTextField.text = username
                }
                
                
            }
            else {
                print("JO: Invalid user response")
            }
        }
    }
    
    
    @IBAction func editProfile(_ sender: UIButton) {
        
        let username =  self.usernameTextField.text!
        let team = self.teamTextField.text!
        
        
        if username.count < 4 && self.usernameTextField.text!.isEmpty == true{
            Core.alert(message: "Campo de nombre de usuario se encuentra vacio", title: Titles().somethingWrong, at: self)
        }else{
            
            let params: Params = ["username": username, "favorite_team": team]
            
            guard let uid = App.core.currentUser?.id else {
                print("JO: No UID")
                return
            }
            
            UserManager().updateProfile(params: params, uid: uid) {
                update in
                
                if update?.status == "User updated succesfully"{
                    Core.alert(message: "La información fue actualizada exitosamente", title: Titles().Success, at: self)
                }else{
                    Core.alert(message: "Sucedio algo mal", title: Titles().somethingWrong, at: self)
                }
                
            }
        }
        
        
        
        
    }
    


    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
            
            
        default:
            return 0
        }
        
        return 0
    }
}
