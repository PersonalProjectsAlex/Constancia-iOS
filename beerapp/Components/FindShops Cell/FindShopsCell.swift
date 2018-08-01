//
//  FindShopsCell.swift
//  beerapp
//
//  Created by elaniin on 2/19/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyBeaver

class FindShopsCell: UITableViewCell {
    
    // MARK: LET/VAR/IBOUTLET
    
    var commerce: Commerce?{
        didSet {
            setupCell()
        }
    }
    
    var promos = [Promotion]() {
        didSet{
            promotionsCollection.reloadData()
        }
    }
    
    @IBOutlet weak var noPromosLabel: UILabel!
    @IBOutlet weak var promotionsCollection: UICollectionView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var logoImageview: UIImageView!
    @IBOutlet weak var kilometersDIstanceLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var fromLabel: UILabel!
    
    var selectedPromotion: Promotion?
    var commerces: Commerce?
    
    override func prepareForReuse() {
        noPromosLabel.isHidden = true
        commerce = nil
        promos = [Promotion]()
    }
    
    // MARK: SETUPS/LOADERS
    
    func setupCell() {
        
        restaurantNameLabel.text = commerce?.name
        addressLabel.text = commerce?.address
        
        if let logo = commerce?.logo, let logoUrl = URL(string: logo) {
            logoImageview.sd_setImage(with: logoUrl, placeholderImage: nil)
        }
        
        scheduleLabel.text = commerce?.schedule  ?? "Sin horario disponible."
       
        if let distance = commerce?.distance?.toDouble() {
            kilometersDIstanceLabel.text = String(format:"%.2f", distance) + " KM"
        }
        
        SwiftyBeaver.debug("There are: \(commerce?.promotions?.count) promos")
        
        promotionsCollection.delegate = self
        promotionsCollection.dataSource = self
        
        promotionsCollection.register(UINib(nibName:"PromotionCell", bundle: nil), forCellWithReuseIdentifier: "PromotionCell")
        
        if let promotions = commerce?.promotions {
            promos = promotions
        }
    }
}

// MARK: COLLECTION VIEW DELEGATE & DATASOURCE

extension FindShopsCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        noPromosLabel.isHidden = false
        if promos.count > 0 { noPromosLabel.isHidden = true }
        return promos.count
    }
    
    // cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromotionCell", for: indexPath) as? PromotionCell else { return UICollectionViewCell() }
        
        cell.promotion = promos[indexPath.row]
        
        return cell
    }

}
