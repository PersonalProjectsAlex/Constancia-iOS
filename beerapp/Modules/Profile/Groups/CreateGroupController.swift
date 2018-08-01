//
//  CreateGroupController.swift
//  beerapp
//
//  Created by elaniin on 2/26/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit

class CreateGroupController: UITableViewController {
    
    // MARK: - Let/Var/IBOutlet
    
    var groups: Groups?
    var users = [String]()
    var idgroup = String()
    
    @IBOutlet weak var groupnameTextfield: LinedTextField!
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var addGroupButton: UIButton!
    @IBOutlet weak var requestButton: UIButton!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        groupnameTextfield.becomeFirstResponder()
        addGroupButton.isHidden = true
        groupnameTextfield.autocorrectionType = .no
        usernameTextfield.autocorrectionType = .no
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
                        self.addGroupButton.isHidden = false
                        self.tableView.reloadData()
                    }
                    
                }else{
                    Core.alert(message: "El usuario no existe, por favor verifique", title: Titles().somethingWrong, at: self)
                }
            }
        }
    }
    
    @IBAction func createGroup(_ sender: UIButton) {
        
        if self.groupnameTextfield.text?.isEmpty == true || (self.groupnameTextfield.text?.trimmingCharacters(in: .whitespaces).isEmpty)!{
            Core.alert(message: "Nombre de grupo invalido", title: Titles().somethingWrong, at: self)
            self.groupnameTextfield.becomeFirstResponder()
            
        }else if (self.groupnameTextfield.text?.count)! < 4 {
            Core.alert(message: "Nombre de grupo debe contener 4 o maàs caracteres", title: Titles().somethingWrong, at: self)
            self.groupnameTextfield.becomeFirstResponder()
            
        }else if (self.users.count != 0 ) {
            let groupName = groupnameTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let getUserID = UserDefaults.standard.string(forKey: "user_id")
            self.addGroups(groupName: groupName , user: getUserID!)
            
        }
    }
    
    
    
    // MARK: - Setup
    func createGroup(params: [String: Any]){
        UserManager().createGroup(params: params) { (result) in
            if result?.status == "true"{
                
                self.idgroup = (result?.id)!
                
                
                let string = self.users.joined(separator: ",").description
                
                
                // prints "Bob Dan Bryan"
                let params: [String:Any] = ["users": string,"group": self.idgroup]
                UserManager().addGroupMembers(params: params, completionHandler: { (status) in
                    print(status?.status)
                    Core.alert(message: "Felicidades su grupo fue creado con exito", title: Titles().Success, at: self)
                    self.groupnameTextfield.text = ""
                    self.usernameTextfield.text = ""
                    self.groupnameTextfield.isUserInteractionEnabled = true
                    self.users.removeAll()
                    self.tableView.reloadData()
                })
                
            }
        }
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.users.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsCell", for: indexPath) as? GroupsCell else { return UITableViewCell() }
        
        cell.nameLabel.text = users[indexPath.row]
       
        cell.deleterowButton.tag = indexPath.row
        cell.deleterowButton.addTarget(self, action: #selector(deleteRow(_:)), for: .touchUpInside)
        return cell
    }
    
    
    @objc func deleteRow(_ sender : UIButton) {
        if let button = sender as? UIButton {
            self.users.remove(at: button.tag)
            
            tableView.reloadData()
        }
        
        
        
    }
    
    func addGroups(groupName: String, user: String){
        
        
        let okAction = UIAlertAction(title: "Crear", style: UIAlertActionStyle.default) {
            UIAlertAction in
            let getUserID = UserDefaults.standard.string(forKey: "user_id")
            let params: [String:Any] = ["name": groupName,"created_by":getUserID!]
            self.createGroup(params: params)
            self.groupnameTextfield.isUserInteractionEnabled = false
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            self.groupnameTextfield.becomeFirstResponder()
        }
        Core.shared.customAlert(message: "Crear un  grupo", title: "¿Deseas tu nuevo grupo sea llamado de esta manera?\(groupName)", cancel: cancelAction, accept: okAction, at: self)
    }
    
    
}



