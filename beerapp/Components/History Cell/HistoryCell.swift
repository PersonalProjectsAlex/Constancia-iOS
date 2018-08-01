//
//  HistoryCell.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 3/16/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

    var rewardHistory: RewardHistory? {
        didSet{
            setupCell(forPromo: false)
        }
    }
    
    var promotion: Promotion? {
        didSet{
           setupCell(forPromo: true)
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var stateCircle: RoundedUIView!
    @IBOutlet weak var stateLabel: UILabel!
    
    
    func setupCell(forPromo: Bool) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Your date format
        
        if forPromo {
            nameLabel.text = promotion?.name

            if let applicationDate = promotion?.applicationDate, let date = dateFormatter.date(from: applicationDate) {
                
                dateFormatter.dateFormat = "dd-MM-yyyy"
                dateLabel.text = dateFormatter.string(from: date)
            }
            stateLabel.text = "No Aplicada"
            if let status = promotion?.status, status == "1" {
                stateLabel.text = "Aplicada"
            }
            return
        }
        
        nameLabel.text = rewardHistory?.name
        
        if let applicationDate = rewardHistory?.applicationDate, let date = dateFormatter.date(from: applicationDate) {
            
            dateFormatter.dateFormat = "dd-MM-yyyy"
            dateLabel.text = dateFormatter.string(from: date)
        }
        
        stateLabel.text = "No aplicado"
        if let status = rewardHistory?.status, status == "1" {
            stateLabel.text = "Aplicada"
        }
    }
    
}
