//
//  PagedTourController.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 3/18/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit

class TourController: UIViewController {

    // MAKR: - IBACTIONS
    
    @IBAction func goToTabBar(_ sender: UIButton) {
        performSegue(withIdentifier: "TourToTabSegue", sender: self)
    }
    
}

