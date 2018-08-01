//
//  SuccesPromoController.swift
//  beerapp
//
//  Created by elaniin on 2/26/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//


import UIKit
import SDWebImage

class SuccesPromoController: UIViewController {
    
    var promotion: Promotion?
    var commerceId: String?
    var userId: String?
    var token: String?
    var filter:CIFilter!
    
    @IBOutlet weak var promoimageImageView: UIImageView!
    @IBOutlet weak var qrcodeImageVIew: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.showAnimate()
        
        if let image = promotion?.image, let imageURL = URL(string: image) {
            promoimageImageView.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "example"))
        }
        
        filter = CIFilter(name: "CIQRCodeGenerator")
        
        // NEW STRING FORMAT
        var dataString = ""
        if let token = token, let commerceId = commerceId, let userId = userId, let promotionId = promotion?.id {
            dataString = "\(token)__\(userId)__\(commerceId)__\(promotionId)"
        }
        
        let data = dataString.data(using: String.Encoding.utf8)
        filter.setValue("H", forKey:"inputCorrectionLevel")
        filter.setValue(data, forKey:"inputMessage")
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let image = UIImage(ciImage: filter.outputImage!.transformed(by: transform))
            
            qrcodeImageVIew.image = image
            
        qrcodeImageVIew.sizeToFit()
    }
    
    @IBAction func closePopUp(_ sender: AnyObject) {
        self.removeAnimate()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func showAnimate() {
        
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
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

