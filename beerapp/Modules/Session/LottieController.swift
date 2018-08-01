//
//  LottieController.swift
//  beerapp
//
//  Created by alex on 2/14/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit
import Lottie
import AccountKit
import HexColors

class LottieController: UIViewController {
   
    var accountKit: AKFAccountKit!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    // MARK: - LIFECYCLE
   
    override func viewDidLoad() {
        super.viewDidLoad()

        let animationView = LOTAnimationView(name: "logo")
        animationView.frame = CGRect(x: 0, y: 20, width: 100, height: 100)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill

        animationView.play()
        animationView.loopAnimation = true
        
        Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(self.splashTimeOut), userInfo: nil, repeats: false)
        
        iconImageView.image = iconImageView.image!.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = .white
        
        self.view.addSubview(animationView)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        splashTimeOut()
    }
    
   
    @objc func splashTimeOut(){

        guard let uid = UserDefaults.standard.string(forKey: "user_id") else {
            print("JO: No UID")
            performSegue(withIdentifier: "LottieToSignInSegue", sender: self)
            return
        }
        
        UserManager().getUserDetail(uid: uid) {
            response in
            
            guard let user = response?.result else {
                print("JO: No user")
                self.performSegue(withIdentifier: "LottieToSignInSegue", sender: self)
                return
            }
            
            print("JO: Loading main screen")
            
            App.core.currentUser = user
            self.performSegue(withIdentifier: "LottieToTabBarSegue", sender: self)
        }
    }
    
}
