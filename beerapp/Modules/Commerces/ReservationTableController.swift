//
//  ReservationTableController.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 3/2/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit
import HexColors
import Presentr
import SDWebImage
import ActionSheetPicker_3_0

class ReservationTableController: UITableViewController {
    
    var groups = [Groups]()
    var commerce: Commerce?
    var selectedGroup: Groups?

    var nameGroups = [String]()
    var idGroup = String()
    var groupsActionSheet: ActionSheetStringPicker?
    
    @IBOutlet weak var logoImage: UIImageView!
    
    // MARK: - IBOUTLETS
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var dayField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var groupButton: UIButton!
    @IBOutlet weak var notesField: UITextView!
    @IBOutlet weak var qtyField: UITextField!
    
    
    // MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGroups()
        setupCommerceData()
        titleField.becomeFirstResponder()
        titleField.autocorrectionType = .no
        
        
        qtyField.contentVerticalAlignment = .center;
        qtyField.textAlignment = .right;
    }
    
    // MARK: - LOADERS
    
    fileprivate func loadGroups() {
        
        guard let uid = App.core.currentUser?.id else {
            print("JO: getUserInfo: No UID")
            return
        }
        
        UserManager().getGroups(uid: uid) {
            groups in
            
            
            if let groupsRes = groups?.result, groups?.status == "true" {
                self.groups = groupsRes
                self.nameGroups.insert("Ninguno", at: 0)
                for i in self.groups{
                    self.nameGroups.append(i.name!)
                }
                
                self.setupGroupActionsSheet()
            }
            
        }
    }
    
    // MARK: - SETUPS
    
    fileprivate func setupCommerceData() {
        
        if let logo = commerce?.logo, let logoUrl = URL(string: logo) {
            logoImage.sd_setImage(with: logoUrl, placeholderImage: nil)
        }
        
        if let address = commerce?.address {
            addressLabel.text = "Dirección: " + address
        }
        
    }
    
    fileprivate func setupGroupActionsSheet() {
                groupsActionSheet = ActionSheetStringPicker(title: "Selecciona una grupo", rows: self.nameGroups, initialSelection: 0, doneBlock: {
            picker, value, index in
            
            
            guard self.nameGroups.count > value  else { return }
            
            let save = self.nameGroups[value]
            
            
            self.groupButton.setTitle(save, for: .normal)
            for i in self.groups {
                if i.name == save {
                    self.qtyField.text = i.members
                    
                }
            }
            
            
            if value == 0{
                
                self.qtyField.isEnabled = true
                self.qtyField.becomeFirstResponder()
                self.qtyField.text = "1"
                print("se mamut")
                
            }else{
                self.qtyField.isEnabled = false
            }
            
        }, cancel: { ActionStringCancelBlock in return }, origin: groupButton)
    }
    
    
    // MARK: - IBACTIONS
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func chooseGroup(_ sender: UIButton) {
        groupsActionSheet?.show()
    }
    
    @IBAction func addReservation(_ sender: UIButton) {
        
        guard let commerceId = commerce?.id else {
            Core.alert(message: "No podemos validar este comrcio.", title: "Comercio Invalido", at: self)
            return
        }
        
        guard let titleR = titleField.text, titleR.count > 0 else {
            
            Core.alert(message: "Ingresa un titulo a la reservacion.", title: "Campos Invalidos", at: self)
            return
        }
        
        guard let day = dayField.text, day.count > 0 else {
            
            Core.alert(message: "Ingresa el dia que quieres reservar.", title: "Campos Invalidos", at: self)
            return
        }
        
        guard let time = timeField.text, time.count > 0 else {
            
            Core.alert(message: "Ingresa la hora a la que quieres reservar.", title: "Campos Invalidos", at: self)
            return
        }
        
        if self.selectedGroup == nil {
            
            Core.alert(message: "Ingresa un grupo valido.", title: "Campos Invalidos", at: self)
            return
        }
        
        guard let peopleCount = qtyField.text, peopleCount.count > 0 else {
            
            Core.alert(message: "Ingresa la cantidad de personas que iran.", title: "Campos Invalidos", at: self)
            return
        }
        
        if self.idGroup.isEmpty == true  {
            
            Core.alert(message: "Ingresa un grupo valido.", title: "Campos Invalidos", at: self)
            return
        }
        guard let uid = App.core.currentUser?.id else {
            return
        }
        
        
        let params: [String: Any] = [
            "created_by": uid,
            "name" : titleR,
            "datetime": "\(day) \(time)",
            "commerce": commerceId,
            "qty": peopleCount.description,
            "notes": notesField.text,
            "group": self.idGroup
        ]
        print(params)
        
        
        makeABook(params: params)
        
    }
    
    @IBAction func chooseDate(_ sender: UITextField) {
        let datePickerView = UIDatePicker()
        
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: .valueChanged)
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        dayField.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func chooseTime(_ sender: UITextField) {
        let datePickerView = UIDatePicker()
        
        datePickerView.datePickerMode = .time
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(self.timePickerValueChanged), for: .valueChanged)
    }
    
    @objc func timePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        
        timeField.text = dateFormatter.string(from: sender.date)
    }
    
    // MARK: - HELPER
    
    func makeABook(params: Params){

        UserManager().addReservation(params: params) {
            book in
            
            if book?.status == "Reservation added succesfully" {

                    if let token = book?.token{
                        
                        self.view.removeFromSuperview()
                        self.dismiss(animated: false, completion: nil)
                        self.showCoinsPoup(token: token)
                    }
                
            }
            else {
                Core.alert(message: "No pudimos registrar tu reservacion.", title: "Lo sentimos", at: self) {
                    action in

                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.crossDissolve
        presenter.dismissOnSwipe = true
        return presenter
    }()
    
    lazy var succesPopup: SuccessReservePopup = {
        
        let popupViewController =  UIStoryboard(name: "FIndPlaces", bundle: nil).instantiateViewController(withIdentifier: "SuccessReservePopupID") as! SuccessReservePopup
        
        return popupViewController
    }()
    
    func showCoinsPoup(token: String) {

        self.dismiss(animated: true, completion: nil)
        presenter.presentationType = .popup
        presenter.transitionType = .crossDissolve
        presenter.dismissTransitionType = nil
        presenter.dismissOnSwipe = true
        succesPopup.modalPresentationStyle =  .popover
        succesPopup.token = token
        if let photo = self.commerce?.photo, let photoUrl = URL(string: photo) {
            succesPopup.image = photoUrl
        }
        
        let window = UIApplication.shared.keyWindow!
        
        window.addSubview(succesPopup.view)
        customPresentViewController(presenter, viewController: succesPopup, animated: true, completion: nil)
        
    }
    
    
}

// MARK: - Table view data source

extension ReservationTableController {
    
    // numberOfSections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    // numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0, 1, 2, 3: return 2
        default: return 1
        }
    }
    
    // heightForRowAt
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
        case 0, 3: return row == 0 ? 45 : 120
        case 1, 2: return 45
        default: return 45
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    
}

