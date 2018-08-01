//
//  Controller+Coins.swift
//  beerapp
//
//  Created by elaniin on 2/16/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import Foundation
import UIKit
import HexColors

extension UIViewController {
    
    func setupCoinsItem() {
        
        guard let uid = App.core.currentUser?.id else {
            return
        }
        
        func setup(coins: String) {
            // Attributes
            let pointsAttributes: [NSAttributedStringKey : Any] = [
                NSAttributedStringKey.foregroundColor: UIColor("#55bfcd"),
                NSAttributedStringKey.font: UIFont(name: "Lato-Medium", size: 10.0)!
            ]
            
            let pointsValueAttributes: [NSAttributedStringKey : Any] = [
                NSAttributedStringKey.foregroundColor: UIColor("#bcc5de"),
                NSAttributedStringKey.font: UIFont(name: "Lato-Medium", size: 17.0)!
            ]
            
            // Strings
            let attrPointsString = NSMutableAttributedString(string: "Monedas \n", attributes: pointsAttributes)
            
            let attrPointsValueString = NSMutableAttributedString(string:  "swqs", attributes: pointsValueAttributes)
            
            attrPointsString.append(attrPointsValueString)
            
            // Item
            let button = UIButton(type: .custom)
            
            button.titleLabel?.numberOfLines = 2
            button.titleLabel?.textAlignment = .right
            button.setAttributedTitle(attrPointsString, for: .normal)
            
            let rightItem = UIBarButtonItem(customView: button)
            
            rightItem.customView?.isUserInteractionEnabled = true
            rightItem.customView?.addGestureRecognizer(UITapGestureRecognizer(target: UIApplication.topViewController(), action: #selector(showCoinsDescriptionAlet)))
            
            self.navigationItem.rightBarButtonItem = rightItem
        }
        
        UserManager().summaryOf(uid: uid) { (user) in
            if user?.status == "true"{
                if let coins = user?.result?.totalcoins{
                    setup(coins: coins)
                }
            }
        }
        
        
    }
    
    @objc
    func showCoinsDescriptionAlet() {
        
        print("JO: Cois alert")
        
        //        App.core.alert(message: "Cada lunes recibirás 50 monedas con las que podrás pronosticar. Cada pronóstico tiene un costo de 2 monedas.", title: "Monedas", at: UIApplication.topViewController()!)
    }
    
    
    
}
