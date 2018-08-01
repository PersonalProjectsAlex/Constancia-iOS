//
//  RemainderPopupController.swift
//  beerapp
//
//  Created by alex on 3/4/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit
import SDWebImage
import Presentr

class PermanentPopupController: UIViewController{
    
    var promotion: Promotion?
    var userId: String?
    var commerceId: String?
    
    var time = String()
    var token = String()
    var filter:CIFilter!
    
    @IBOutlet weak var firsrLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    
    @IBOutlet weak var qrcodeImageVIew: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            
            var duration = TimeInterval()
            duration = self.parseDuration(timeString: self.time)
            let time = self.timeString(time: duration).description
            let time2 = self.timeString2(time: duration).description
            firsrLabel.text = time.first?.description
            secondLabel.text = time.last?.description
            thirdLabel.text = time2.first?.description
            fourthLabel.text = time2.last?.description
        
        
        if let name = self.promotion?.name {
            self.descriptionLabel.text = "Llevas \( self.time) minutos desde tu check-in, llamá al mesero y dale este código para que disfrutes de: \(name) ."
        }
        
        // NEW STRING FORMAT
        var dataString = ""
        if let commerceId = commerceId, let userId = userId, let promotionId = promotion?.id {
            dataString = "\(token)__\(userId)__\(commerceId)__\(promotionId)"
            print("JO: QR: \(dataString)")
        }
        
        let data = dataString.data(using: String.Encoding.utf8)
        
        //QR Code
        filter = CIFilter(name: "CIQRCodeGenerator")
        filter.setValue("H", forKey:"inputCorrectionLevel")
        filter.setValue(data, forKey:"inputMessage")
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let image = UIImage(ciImage: filter.outputImage!.transformed(by: transform))
        qrcodeImageVIew.image = image
        qrcodeImageVIew.contentMode = .scaleAspectFill
        qrcodeImageVIew.clipsToBounds = true
    }
    

    func timeString(time:TimeInterval) -> String {
        
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i", minutes)
    }
    
    func timeString2(time:TimeInterval) -> String {
        
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i", seconds)
    }
    
    @IBAction func closePopUp(_ sender: AnyObject) {
        self.removeAnimate()
    }
    
    func parseDuration(timeString:String) -> TimeInterval {
        guard !timeString.isEmpty else {
            return 0
        }
        
        var interval:Double = 0
        
        let parts = timeString.components(separatedBy: ":")
        for (index, part) in parts.reversed().enumerated() {
            interval += (Double(part) ?? 0) * pow(Double(60), Double(index))
        }
        
        return interval
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


extension PermanentPopupController: PresentrDelegate {
    
    func presentrShouldDismiss(keyboardShowing: Bool) -> Bool {
        
        return !keyboardShowing
    }
    
}
