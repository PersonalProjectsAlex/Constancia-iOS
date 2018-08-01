//
//  InidicatorHelper.swift
//  beerapp
//
//  Created by alex on 3/18/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import Foundation
import UIKit


extension UIActivityIndicatorView {
    
    convenience init(activityIndicatorStyle: UIActivityIndicatorViewStyle, color: UIColor, placeInTheCenterOf parentView: UIView) {
        self.init(activityIndicatorStyle: activityIndicatorStyle)
        center = parentView.center
        self.color = color
        parentView.addSubview(self)
    }
}
