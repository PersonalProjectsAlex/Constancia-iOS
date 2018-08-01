//
//  TourPageController.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 3/18/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit

class TourPageController: UIViewController {

    var index: Int?
    var image: UIImage?
    var pageTitle: String?
    var pageDescription: String?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
        titleLabel.text = pageTitle
        descriptionLabel.text = pageDescription
    }
    
}
