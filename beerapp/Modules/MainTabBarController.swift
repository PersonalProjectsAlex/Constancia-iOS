//
//  BaseTabBarController.swift
//  beerapp
//
//  Created by elaniin on 1/29/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    @IBOutlet weak var mainTabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedIndex = 2

        mainTabBar.unselectedItemTintColor = UIColor("31416E")
        mainTabBar.tintColor = UIColor("5EC1CD")
        
    }
    
}
