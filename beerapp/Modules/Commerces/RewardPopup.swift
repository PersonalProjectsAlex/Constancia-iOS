//
//  SuccessReservePopup.swift
//  beerapp
//
//  Created by elaniin on 3/8/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import Foundation
import Presentr


class RewardPopup: UIViewController{
    
    var reward: Reward?
    var filter:CIFilter!
    
    
    
    @IBOutlet weak var qrcodeImageVIew: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        
        if let name = reward?.name{
            //titleLabel.text = name
        }
        
        //QR Code
        if let token = reward?.token{
            filter = CIFilter(name: "CIQRCodeGenerator")
            let data = token.data(using: String.Encoding.utf8)
            filter.setValue("H", forKey:"inputCorrectionLevel")
            filter.setValue(data, forKey:"inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let image = UIImage(ciImage: filter.outputImage!.transformed(by: transform))
            qrcodeImageVIew.image = image
            qrcodeImageVIew.sizeToFit()
        }
        
    }

    
    @IBAction func closePopUp(_ sender: AnyObject) {
       self.dismiss(animated: true, completion: nil)
        
    }
    

    
    func removeAnimate() {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    
}


extension RewardPopup: PresentrDelegate {
    
    func presentrShouldDismiss(keyboardShowing: Bool) -> Bool {
        
        return !keyboardShowing
    }
    
}

