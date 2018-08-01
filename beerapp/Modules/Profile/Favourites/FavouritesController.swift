//
//  FavouritesController.swift
//  beerapp
//
//  Created by elaniin on 2/15/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit
import HexColors

protocol FavouriteCommercesToDetail {
    
    func removeFromFavourites()
}

class FavouritesController: UIViewController {
    
    // MARK: - LET/VAR/IBOUTLET
    
    var isLoading = true
    var favourites = [Commerce]()
    var selectedCommerce: Commerce?
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetDataSource = self
        
        App.core.registerCell(at: tableView, named: "FavouritesCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadFavourites()
    }
    
    // MARK: - NAVIGATION
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "FavouritesToCommerceDetailSegue" {
            
            let detailController = segue.destination as! ShopDetailController
            detailController.commerceId = selectedCommerce?.id
            detailController.fromFavouritesDelegate = self
        }
    }
    
    // MARK: - LOADERS, SETUPS
    
    @objc fileprivate func loadFavourites() {
        
        guard let uid = App.core.currentUser?.id else {
            print("JO: No UID")
            return
        }
        
        isLoading = true
        setupCoinsItem()
        favourites.removeAll()
        tableView.reloadData()
        
        CommerceManager().getFavouriteList(uid: uid) {
            response in
            
            if let favourites = response?.result { self.favourites = favourites }
            else { print("JO: No favs") }
            self.isLoading = false
            self.tableView.reloadData()
        }
    }
    
    @objc func removeCommerceFromFavs(_ sender : UIButton) {
        
        print("JO: Removing Fav")
        
        guard let uid = App.core.currentUser?.id else {
            print("JO: getUserInfo: No UID")
            return
        }
        
        let params: Params = ["user": uid, "commerce": sender.tag]
        
        CommerceManager().addToFavourites(params: params) {
            favourite in
            
            sender.isSelected = favourite?.status == "Commerce added to favorites"
            if !sender.isSelected { self.loadFavourites() }
        }
    }

}

extension FavouritesController: FavouriteCommercesToDetail {
    
    func removeFromFavourites() {
        
        print("JO: removeFromFavourites")
        
        loadFavourites()
    }
}

// UITableViewDelegate, UITableViewDataSource

extension FavouritesController: UITableViewDelegate, UITableViewDataSource {
    
    // numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favourites.count
    }
    
    // heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    // didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCommerce = favourites[indexPath.row]
        performSegue(withIdentifier: "FavouritesToCommerceDetailSegue", sender: self)
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavouritesCell", for: indexPath) as? FavouritesCell else { return UITableViewCell() }
        
        cell.commerce = favourites[indexPath.row]
        
        if let commerce = favourites[indexPath.row].id, let commerceTag = Int(commerce) {
            cell.closeButton.tag = commerceTag
        }
        
        cell.closeButton.addTarget(self, action: #selector(removeCommerceFromFavs(_:)), for: .touchUpInside)
        
        return cell
        
    }
    
}
