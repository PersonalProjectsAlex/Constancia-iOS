//
//  PopUpViewController.swift
//  PopUp
//
//  Created by Andrew Seeley on 6/06/2016.
//  Copyright © 2016 Seemu. All rights reserved.
//

import UIKit
import Presentr

class PopUpViewController: UIViewController  {

    var commerce: Commerce?

    @IBOutlet weak var coinsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.showAnimate()
    
        UserDefaults.standard.set("checkinmade", forKey: "checkinmade")
        
        let checkinmade = UserDefaults.standard.string(forKey: "checkinmade")
        let idcommerce = UserDefaults.standard.string(forKey: "idcommerce")
        
        if checkinmade != nil{
            DispatchQueue.main.asyncAfter(deadline: .now() + (50*60)) {
                UserDefaults().removeObject(forKey: "checkinmade")
                UserDefaults().synchronize()
            }
        }
        
        if idcommerce != nil{
            DispatchQueue.main.asyncAfter(deadline: .now() + (15*60)) {
                UserDefaults().removeObject(forKey: "idcommerce")
                UserDefaults().synchronize()
            }
        }
        
        if let commerce = commerce {
            
            if let coins = commerce.checkinCoins{
                self.coinsLabel.text = coins + " coins"
            }
            
            self.nameLabel.text = commerce.name
            
        }
        
    }
    
    
    @IBAction func closePopUp(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        self.view.removeFromSuperview()
    }
    
    func showAnimate() {
        
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    

}


extension PopUpViewController: PresentrDelegate {
    
    func presentrShouldDismiss(keyboardShowing: Bool) -> Bool {
        return !keyboardShowing
    }
    
}
