//
//  PagerStripController.swift
//  beerapp
//
//  Created by elaniin on 2/15/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class PagerStripMapController: ButtonBarPagerTabStripViewController {
    
    var searching:Bool! = false
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        settings.style.buttonBarItemBackgroundColor = Core.hexStringToUIColor(hex: "#EDF2FF")
        settings.style.buttonBarBackgroundColor = Core.hexStringToUIColor(hex: "#EDF2FF")
        
        settings.style.selectedBarBackgroundColor = Core.hexStringToUIColor(hex: "#5ABFCC")
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 13)
        settings.style.selectedBarHeight = 3.0
        
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = Core.hexStringToUIColor(hex: "#213363")
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.buttonBarItemBackgroundColor = Core.hexStringToUIColor(hex: "#EDF2FF")
        settings.style.buttonBarItemLeftRightMargin = 0
        settings.style.buttonBarItemLeftRightMargin = 0
        
        super.viewDidLoad()
        self.title = "Comercios"
        setupSearch()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setupCoinsItem()
    }
    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child_1 = UIStoryboard(name: "FIndPlaces", bundle: nil).instantiateViewController(withIdentifier: "FindPlacesControllerID")
        let child_2 = UIStoryboard(name: "FIndPlaces", bundle: nil).instantiateViewController(withIdentifier: "ListPlacesControllerID")
        return [child_1,child_2]
    }
    
}

extension PagerStripMapController: UISearchBarDelegate {
    
    fileprivate func setupSearch() {
        
        // Setup the Search Controller
        searchController.searchBar.delegate = self
        
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let searchBar = searchController.searchBar
        searchBar.placeholder = "Buscar bares o restaurantes"
        searchBar.tintColor = .white
        searchBar.barTintColor = .white
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.blue
            if let backgroundview = textfield.subviews.first {
                
                // Background color
                backgroundview.backgroundColor = .white
                
                // Rounded corner
                backgroundview.layer.cornerRadius = 10;
                backgroundview.clipsToBounds = true;
            }
        }
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        performSegue(withIdentifier: "CommercesToSearchSegue", sender: self)
        return false
    }
    
}


