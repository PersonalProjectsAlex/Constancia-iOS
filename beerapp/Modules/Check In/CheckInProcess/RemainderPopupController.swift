//
//  RemainderPopupController.swift
//  beerapp
//
//  Created by alex on 3/4/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import Foundation

import UIKit
import SDWebImage
import CountdownLabel
import Presentr

class RemainderPopupController: UIViewController{
    
    var promotion: Promotion?
    var userId: String?
    var commerceId: String?
    
    var time = String()
    var token = String()
    var filter: CIFilter!
    
    @IBOutlet weak var firsrLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    
    @IBOutlet weak var promoImageVIew: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptiontimeLabel: UILabel!
    @IBOutlet weak var timeLabel: CountdownLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        self.showTime(time: self.parseDuration(timeString: self.time))
        
        self.firsrLabel.text = promotion?.name
        
        if let image = promotion?.image {
            promoImageVIew.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "icon-main-ilc"))
        }
        else { promoImageVIew.image = #imageLiteral(resourceName: "ico-blank_state") }
        
        
    }
    
    func showTime(time: TimeInterval){
        timeLabel.setCountDownTime(minutes: time)
        timeLabel.textAlignment = .center
        timeLabel.start()
        timeLabel.timeFormat = "mm:ss"
        timeLabel.textColor = .gray
        timeLabel.font = UIFont(name: "Lato-Medium", size: 40.0)
        timeLabel.countdownDelegate = self
    }
   
    @IBAction func closePopUp(_ sender: AnyObject) {
       self.removeAnimate()
    }
    
    func countdownFinished() {
        debugPrint("countdownFinished at delegate.")
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

extension RemainderPopupController: CountdownLabelDelegate {
}

extension RemainderPopupController: PresentrDelegate {
    
    func presentrShouldDismiss(keyboardShowing: Bool) -> Bool {
        return !keyboardShowing
    }
}
