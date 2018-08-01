//
//  ReservationsDetailController.swift
//  beerapp
//
//  Created by elaniin on 3/7/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import Foundation
//
//  ReservationTableController.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 3/2/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit
import HexColors
import SDWebImage

class ReservationsDetailController: UITableViewController {
    
    var reservations: Reservations?
    var filter:CIFilter!
    
    // MARK: - IBOUTLETS
    @IBOutlet weak var qrcodeImageVIew: UIImageView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var dayField: UITextField!
    @IBOutlet weak var notesField: UITextView!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    
    
    // MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name  = reservations?.name{
            titleField.text = "Titulo: " + name
        
        }
        if let address  = reservations?.commerceaddress{
            addressLabel.text = "Dirección: " + address
            
        }
        
        if let date  = reservations?.reservationdate{
            dayField.text = date
            
        }
        
        if let group  = reservations?.groupname{
            groupLabel.text = group
            
        }
        
        if let qty  = reservations?.qty{
            qtyLabel.text = qty
            
        }
        
        if let notes  = reservations?.notes{
            notesField.text = notes
            
        }else{
            notesField.text = "No se agregaron notas a esta reservación"
        }
        
        if let token = reservations?.token{
            if token != nil{
            filter = CIFilter(name: "CIQRCodeGenerator")
            let data = token.data(using: String.Encoding.utf8)
            filter.setValue("H", forKey:"inputCorrectionLevel")
            filter.setValue(data, forKey:"inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let image = UIImage(ciImage: filter.outputImage!.transformed(by: transform))
            qrcodeImageVIew.image = image
            qrcodeImageVIew.sizeToFit()
            }
        }else{
            print("error")
        }
        
        self.title = "Detalle Reservación"
        

        
        
        
    }
    
    
    
    // MARK: - LOADERS

    
    // MARK: - SETUPS
    
    
    // MARK: - IBACTIONS

    
    


    // MARK: - HELPER
    
    func makeABook(params: Params){
        
        UserManager().addReservation(params: params) {
            book in
            
            if book?.status == "Reservation added succesfully" {
                
                
                
                Core.alert(message: "Reservacion agregada exitosamente." , title: "Hecho!", at: self){
                    action in
                    self.dismiss(animated: true, completion: nil)
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
    
}

// MARK: - Table view data source

extension ReservationsDetailController {
    
    // numberOfSections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    // numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0, 2, 3: return 2
        default: return 1
        }
    }
    
    // heightForRowAt
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
        case 0, 3: return row == 0 ? 50 : 120
        case 1, 2: return 50
        default: return 50
        }
    }
    
}
