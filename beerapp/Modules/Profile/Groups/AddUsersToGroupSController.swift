//
//  AddUsersToGroupSController.swift
//  beerapp
//
//  Created by alex on 2/28/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit
import SwiftyBeaver
import HexColors

class AddUsersToGroupSController: UITableViewController {
    
    // MARK: - Let/Var/IBOutlet
    
    var groups: Groups?
    var users = [String]()
    var groupdetail: GroupsDetails?
    var members = [User]()
    var isLoading = true
    let section = ["Miembros por agregar"]
    
    @IBOutlet weak var groupnameTextfield: LinedTextField!
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var addGroupButton: UIButton!
    
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGroupDetails()
        usernameTextfield.autocorrectionType = .no
    }
    
    func setGroupDetails(){
        UserManager().getGroupsDetails(uid: (groups?.id)!) { (details) in
            if details?.status == "true"{
                self.groupnameTextfield.text = (details?.result?.name)!
                self.groupdetail = details?.result
                self.members = (self.groupdetail?.members)!
                
                if self.members.count > 0{
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    
    
    func deleteUserFrom(params: [String:Any]){
        UserManager().removeGroupMember(params: params) { (remove) in
            if remove?.status == "Member deleted from group"{
                self.tableView.reloadData()
            }
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func addMemberToGroup(_ sender: UIButton) {
        if (self.usernameTextfield.text?.isEmpty == false) {
            let params: [String:Any] = ["username": usernameTextfield.text!]
            UserManager().validateUser(params: params) { (validate) in
                
                if validate?.status == "true" {
                    
                    if  self.users.contains(self.usernameTextfield.text!){
                        Core.alert(message: "El usuario ya se encuentra en su lista", title: Titles().somethingWrong, at: self)
                        print("Error")
                        
                    }else{
                        
                        self.users.append(self.usernameTextfield.text!)
                        self.usernameTextfield.text = ""
                        self.tableView.reloadData()
                    }
                    
                }else{
                    Core.alert(message: "El usuario no existe, por favor verifique", title: Titles().somethingWrong, at: self)
                }
            }
        }
    }
    
    @IBAction func createGroup(_ sender: UIButton) {
        
        if self.groupnameTextfield.text?.isEmpty == true{
            Core.alert(message: "Hay datos vacios, por favor verifique", title: Titles().somethingWrong, at: self)
        }
        
        if (self.groupnameTextfield.text?.isEmpty == false && self.users.count != 0) {
            
            let string = self.users.joined(separator: ",").description
            
            let params: [String:Any] = ["users": string,"group": (groups?.id)!]
            
            self.addMembers(params: params)
            
        }
    }
    
    
    // MARK: - Table view data source
    
    //    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //
    //        return self.section[section]
    //    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 3
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            return self.users.count
        } else if(section == 1) {
            return self.members.count
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsCell", for: indexPath) as? GroupsCell else { return UITableViewCell() }
        
        if indexPath.section == 0{
            
            cell.backgroundColor = HexColor("#bcece3")
            cell.nameLabel.backgroundColor = HexColor("#bcece3")
            cell.prefixLabel.backgroundColor = HexColor("#bcece3")
            cell.cellcontentView.backgroundColor = HexColor("#bcece3")
            cell.nameLabel.text = self.users[indexPath.row]
            cell.deleterowButton.tag = indexPath.row
            cell.deleterowButton.addTarget(self, action: #selector(deleteRow(_:)), for: .touchUpInside)
            
        }else if indexPath.section == 1{
            cell.backgroundColor = HexColor("#F8F8F8")
            cell.nameLabel.backgroundColor = HexColor("#F8F8F8")
            cell.prefixLabel.backgroundColor = HexColor("#F8F8F8")
            cell.cellcontentView.backgroundColor = HexColor("#F8F8F8")
            cell.nameLabel.text = members[indexPath.row].username
            cell.deleterowButton.tag = Int(members[indexPath.row].id!)!
            cell.deleterowButton.addTarget(self, action: #selector(deleteUser(_:)), for: .touchUpInside)
        }
        
        return cell
    }
    
    // MARK: - Setup
    
    @objc func deleteRow(_ sender : UIButton) {
        if let button = sender as? UIButton {
            self.users.remove(at: button.tag)
            
            tableView.reloadData()
        }
    }
    
    @objc func deleteUser(_ sender : UIButton) {
        if let button = sender as? UIButton {
            
            let params: [String:Any] = ["group": (groups?.id)!, "user": button.tag.description]
            self.deleteUserFrom(params: params)
            self.setGroupDetails()
        }
    }
    
    func addToGroup(params: [String: Any]){
        
        
        UserManager().addGroupMembers(params: params, completionHandler: { (status) in
            if status?.status == "All users has been added to group"{
                
                self.showSomething(message: "Felicidades se agregaron los nuevos usuarios al grupo", title: Titles().Success, bool: true)
                
            }else if (status?.status == "Some users has been added to group"){
                
                self.showSomething(message: "Se agregaron con exito los usuarios que no existian en su grupo" , title: Titles().Success, bool: true)
                
            }else if (status?.status == "No users has been added to group"){
                
                self.showSomething(message: "Uno o más usuarios ya existen en este grupo", title: Titles().somethingWrong, bool: false)
                
            }
            
            
            
        })
        
    }
    
    func showSomething(message: String, title: String, bool: Bool){
        Core.alert(message: message, title: title, at: self)
        self.usernameTextfield.text = ""
        if bool == true{
            self.users.removeAll()
        }
        self.members.removeAll()
        self.tableView.reloadData()
        self.setGroupDetails()
    }
    
    
    func addMembers(params: [String:Any] ){
        
        
        let okAction = UIAlertAction(title: "Agregar usuarios", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            self.addToGroup(params: params)
            
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            self.groupnameTextfield.becomeFirstResponder()
        }
        Core.shared.customAlert(message: "Agregar usuarios", title: "¿Deseas agregar estos usuarios?", cancel: cancelAction, accept: okAction, at: self)
    }
}


