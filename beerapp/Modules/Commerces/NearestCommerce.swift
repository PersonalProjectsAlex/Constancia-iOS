//
//  NearestCommerce.swift
//  beerapp
//
//  Created by elaniin on 3/5/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import Foundation



import UIKit
import SDWebImage
import UserNotifications
import Presentr

class NearestCommerceController: UIViewController {
    
    var commerce: Commerce?
    var commerceId: String?
    var promotions = [Promotion]()
    
    @IBOutlet weak var commerceimageImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let image = commerce?.photo, let imageUrl = URL(string: image){
            commerceimageImageView.sd_setImage(with: imageUrl, placeholderImage: nil)
        }
        
        if let name = commerce?.name {
            nameLabel.text = name
        }
        commerceId = commerce?.id?.description
        
        
    }
    
    @IBAction func makeCheckIn(_ sender: UIButton) {
        UserDefaults.standard.set("nearestalreadychecked", forKey: "nearestchecked")
        guard let uid = App.core.currentUser?.id, let commerceId = commerceId else {
            
            print("JO: No user id or commerce id")
            return
        }
        
        let params: Params = ["commerce": commerceId, "user": uid]
        
        CommerceManager().checkIn(params: params) { (check) in
            let checkinmade = UserDefaults.standard.string(forKey: "checkinmade")
            
            
            
            if check?.status == "Check in added" && checkinmade == nil {
                
                self.view.removeFromSuperview()
                self.dismiss(animated: false) {
                    
                    self.checkInButton.isUserInteractionEnabled = true
                    self.commerceDetails(userId: uid, commerceId: commerceId)
                    self.showCoinsPoup()
                }
            }
        }
    }
    
    
    @IBAction func closePopUp(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    // MARK: - POP UPS
    
    let presenter: Presentr = {
        let width = ModalSize.custom(size: 356)
        let height = ModalSize.fluid(percentage: 5)
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: 0))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = .coverVerticalFromTop
        customPresenter.dismissTransitionType = .crossDissolve
        customPresenter.roundCorners = true
        customPresenter.backgroundColor = .black
        customPresenter.backgroundOpacity = 0.5
        customPresenter.dismissOnSwipe = true
        customPresenter.dismissOnSwipeDirection = .top
        return customPresenter
    }()
    
    
    lazy var coinsiewController: PopUpViewController = {
        
        let popupViewController = UIStoryboard(name: "CheckIn", bundle: nil).instantiateViewController(withIdentifier: "PopUpViewControllerID") as! PopUpViewController
        
        return popupViewController
    }()
    
    lazy var remainderiewController: RemainderPopupController = {
        
        let popupViewController =  UIStoryboard(name: "CheckIn", bundle: nil).instantiateViewController(withIdentifier: "RemainderPopupControllerID") as! RemainderPopupController
        
        return popupViewController
    }()
    
    lazy var permanentiewController: PermanentPopupController = {
        
        let popupViewController =  UIStoryboard(name: "CheckIn", bundle: nil).instantiateViewController(withIdentifier: "PermanentPopupControllerID") as! PermanentPopupController
        
        return popupViewController
    }()
    
    func showCoinsPoup() {
        presenter.presentationType = .popup
        presenter.transitionType = .crossDissolve
        presenter.dismissTransitionType = nil
        presenter.dismissOnSwipe = true
        coinsiewController.modalPresentationStyle = .popover
        coinsiewController.commerce = commerce
        let window = UIApplication.shared.keyWindow!
        
        window.addSubview(coinsiewController.view)
        customPresentViewController(presenter, viewController: coinsiewController, animated: true, completion: nil)
        
    }
    
    func showRemainderPopUp(time: String, token: String, promotion: Promotion){
        coinsiewController.view.removeFromSuperview()
        coinsiewController.dismiss(animated: false, completion: nil)
        presenter.presentationType =  .popup
        presenter.transitionType = .crossDissolve
        presenter.dismissTransitionType = nil
        presenter.dismissOnSwipe = false
        remainderiewController.time = time
        remainderiewController.token = token
        remainderiewController.promotion = promotion
        remainderiewController.modalPresentationStyle = .popover
        let window = UIApplication.shared.keyWindow!
        
        window.addSubview(remainderiewController.view)
        
        customPresentViewController(presenter, viewController: coinsiewController, animated: true, completion: nil)
        
    }
    
    func showPermanent(time: String, token: String, promotion: Promotion, commerceId: String, userId: String){
        
        coinsiewController.dismiss(animated: false, completion: nil)
        presenter.presentationType =  .popup
        presenter.transitionType = .crossDissolve
        presenter.dismissTransitionType = nil
        presenter.dismissOnSwipe = false
        permanentiewController.time = time
        permanentiewController.token = token
        permanentiewController.promotion = promotion
        permanentiewController.commerceId = commerceId
        permanentiewController.userId = userId
        permanentiewController.modalPresentationStyle = .popover
        let window = UIApplication.shared.keyWindow!
        
        window.addSubview(permanentiewController.view)
        
        customPresentViewController(presenter, viewController: permanentiewController, animated: true, completion: nil)
        
    }
    
    func commerceDetails(userId: String, commerceId: String){
        
        let params: Params = ["commerce": commerceId, "user": userId]
        
        CommerceManager().commercePromotionsDetail(params: params, id: commerceId) {
            response in
            
            guard let commerce = response?.result else {
                
                print("JO: No commerce data available")
                return
            }
            
            if let promotions = commerce.promotions {
                self.promotions = promotions
            }
            
            for promotion in self.promotions {
                
                print("JO: Promotion \(promotion.id) check in type: \(promotion.checkintype)")
                
                switch promotion.checkintype {
                case "1"?: self.permanentPromotion(at: commerceId, for: userId, with: promotion)
                case "2"?: self.remanentPromotion(at: commerceId, for: userId, with: promotion)
                default: break
                }
            }
            
        }
    }
    
    
    func permanentPromotion(at commerceId: String, for userId: String, with promotion: Promotion){
        
        guard let duration = promotion.duration, let promotionId = promotion.id else { return }
        let durationTime = parseDuration(timeString: duration)
        
        timedNotifications(inSeconds: durationTime*2) {
            success in
            
            guard success else { return }
            
            let timeToDisplay = DispatchTime.now() + self.parseDuration(timeString: duration)
            DispatchQueue.main.asyncAfter(deadline: timeToDisplay) { // change 2 to desired number of seconds
                
                let params: Params = ["commerce": commerceId, "user": userId, "promotion": promotionId]
                
                PromotionManager().applyPromotion(params: params){
                    response in
                    
                    guard let token = response?.token else {
                        print("JO: No token")
                        return
                    }
                    
                    self.showPermanent(time: duration, token: token, promotion: promotion, commerceId: commerceId, userId: userId)
                }
            }
        }
    }
    
    func remanentPromotion(at commerceId: String, for userId: String, with promotion: Promotion) {
        
        guard let duration = promotion.duration, let promotionId = promotion.id else { return }
        let timeToDisplay = DispatchTime.now() + parseDuration(timeString: duration)
        
        DispatchQueue.main.asyncAfter(deadline: timeToDisplay) {
            
            print("Successfully Notified in \(duration)")
            
            let params: Params = ["commerce": commerceId, "user": userId, "promotion": promotionId]
            
            PromotionManager().applyPromotion(params: params){
                response in
                
                if let token = response?.token {
                    self.showRemainderPopUp(time: promotion.duration!, token: token, promotion: promotion)
                }
            }
        }
    }
    
    
    func timedNotifications(inSeconds: TimeInterval, completion: @escaping (_ Success: Bool) -> ()) {
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
        
        let content = UNMutableNotificationContent()
        var  commerceName = String()
        if let name = commerce?.name {
            
            commerceName = name
        }
        
        
        content.title = "Has hecho checkIn en: \( commerceName)"
        
        let request = UNNotificationRequest(identifier: "customNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                completion(false)
            }else {
                completion(true)
            }
        }
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
    
    
}


extension NearestCommerceController: PresentrDelegate {
    
    func presentrShouldDismiss(keyboardShowing: Bool) -> Bool {
        
        return !keyboardShowing
    }
    
}


