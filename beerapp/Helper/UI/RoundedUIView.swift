//
//  RoundedUIView.swift
//  desafio-movistar-ios
//
//  Created by Jonathan Solorzano on 2/12/18.
//  Copyright © 2018 elaniin. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedUIView: UIView {
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.5 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    var perfectCircle: Bool = false {
        didSet {
            self.layer.cornerRadius = self.frame.size.height / 2
        }
    }
    
}
