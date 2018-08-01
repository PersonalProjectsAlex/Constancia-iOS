//
//  Core.swift
//  App
//
//  Created by elaniin on 1/15/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import Foundation
import UIKit
import HexColors

//Core will be used to get elements/ functions which don`t neeed to be created for each class
class Core{
    static let shared = Core()
    private init() {}
    
    //MARK: - Alert view
    static func alert(message: String, title: String, at viewController: UIViewController, handler: ((UIAlertAction)->())? = nil){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: handler)
        alertController.addAction(okayAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func customAlert(message: String, title: String, cancel:UIAlertAction, accept:UIAlertAction, at viewController: UIViewController){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        
        // Add the actions
        alertController.addAction(accept)
        alertController.addAction(cancel)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    
    //indicator
    
    
    // CircleImage
    
    func circleimage(imageview: UIImageView){
        imageview.layoutIfNeeded()
        imageview.layer.cornerRadius = imageview.frame.width / 2
        imageview.clipsToBounds = true
        
    }
    
    func buttonImageColor(button:UIButton, color: UIColor, image: UIImage){
        let origImage = image
        let tintedImage = origImage.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = color
    }
    
    //Imagebackground
    func setbackground(image: UIImage, view: UIView){
        let background = image
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        view.sendSubview(toBack: imageView)
    }
    /// MARK: - Validations
    
    
    //MARK: - Hexa string color turn into UIColor
    static func hexStringToUIColor (hex:String) -> UIColor {
        
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    func setImageNavBar(navigationItem:UINavigationItem, image: UIImage){
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        imageView.contentMode = .scaleAspectFit
        
        let image = image
        imageView.image = image
        
        navigationItem.titleView = imageView
    }
    
    func setIndiciatorToLeft(controller:UIViewController, activityIndicator: UIActivityIndicatorView){
        activityIndicator.color = HexColor("#5ABFCC")
        let barButton = UIBarButtonItem(customView: activityIndicator)
        controller.navigationItem.setLeftBarButton(barButton, animated: true)
    }
    
    
    static func setColorbyStringLength( myMutableString:NSMutableAttributedString,text: String,firstcolor:UIColor, firstlocation: Int, firstlength:Int,secondcolor:UIColor, secondlocation: Int, secondlength:Int,button:UIButton){
        var mutable = myMutableString
        mutable = NSMutableAttributedString(string: text, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 12)])
        
        mutable.addAttribute(NSAttributedStringKey.foregroundColor, value: firstcolor, range: NSRange(location:firstlocation,length:firstlength))
        
        mutable.addAttribute(NSAttributedStringKey.foregroundColor, value: secondcolor, range: NSRange(location:secondlocation,length:secondlength))
        
        button.setAttributedTitle(mutable, for: .normal)
    }
    
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    
    /// MARK: - Animations
    
    static func Fade(view:UIView){
        view.alpha = 0
        view.fadeOut(completion: {
            (finished: Bool) -> Void in
            view.fadeIn()
        })
    }
    
    static func Fade2(view:UIView){
        view.transform = view.transform.scaledBy(x: 0.001, y: 0.001)
        
        UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            view.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
        }, completion: nil)
    }
    

    
    //let transition = CATransition()
    //transition.duration = 0.5
    //transition.type = kCATransitionPush
    //transition.subtype = kCATransitionFromRight
    //transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
    
    //Navbar color
    static func itembarbackground(controller: UIViewController, barTint: UIColor, titleColor: UIColor){
        
        controller.navigationController?.navigationBar.barStyle = UIBarStyle.blackOpaque
        controller.navigationController?.navigationBar.isTranslucent = false
        controller.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        controller.navigationController?.navigationBar.shadowImage = UIImage()
        controller.navigationController?.navigationBar.barTintColor  = barTint
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: titleColor]
        controller.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        
    }
    
    /// MARK: - Table Views
    
    /// Register cell at a table view
    func registerCell(at tableView: UITableView, named: String, withIdentifier: String? = nil) {
        let coffeeCellNib = UINib(nibName: named, bundle: nil)
        tableView.register(coffeeCellNib, forCellReuseIdentifier: withIdentifier ?? named)
    }
    
    
    
    
    
    
}

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
        }
    }
}


extension UIView {
    
    
    func fadeIn(duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(duration: TimeInterval = 1.0, delay: TimeInterval = 3.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
}



class MyTableViewCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(0, 16, 0, 16))
    }
}


extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension UIColor {
    
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}


extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}

extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}


//MARK: - UIApplication Extension
extension UIApplication {
    class func topViewwController(viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(controller: nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(controller: presented)
        }
        return viewController
    }
}

