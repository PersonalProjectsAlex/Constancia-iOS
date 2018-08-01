//
//  PromotionsDetailsController.swift
//  beerapp
//
//  Created by elaniin on 2/23/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyBeaver
import TBEmptyDataSet

class PromotionsDetailsController: UIViewController {
    
    var promotion: Promotion?
    var commerces = [Commerce]()
    var selectedCommerce: Commerce?
    
    var indicator = UIActivityIndicatorView()
    var isState = false
    
    var isLoading = true
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var requestButton: LoadingUIButton!
    @IBOutlet weak var promoImageView: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var promotionNameLabel: UILabel!
    @IBOutlet weak var footerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetDataSource = self
        
        Core.shared.registerCell(at: tableView, named: "ShopCell")

        setupPromotionData()
        loadPromotionCommerces()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PromotionToCommerceSegue" {
            let detailController = segue.destination as! ShopDetailController
            detailController.commerceId = selectedCommerce?.id
        }
    }
    
    fileprivate func setupPromotionData() {
        
        promotionNameLabel.text = promotion?.name
        
        if let price = promotion?.price{
            priceLabel.text = "$\(price)"
        }else{
            priceLabel.text = "$-.--"
        }
        
        
        if let promotion = promotion?.image, let promotionURL = URL(string: promotion) {
            promoImageView.sd_setImage(with: promotionURL, placeholderImage: #imageLiteral(resourceName: "icon-main-ilc"))
        }else{

            promoImageView.image = #imageLiteral(resourceName: "ico-blank_state")
            
        }
    }

    fileprivate func loadPromotionCommerces() {
        
        guard let promotionId = promotion?.id?.description else {
            print("JO: No promotion id.")
            return
        }
        
        let params: Params = [
            "promotion": promotionId,
            "lat": "13.7088404",
            "lon": "-89.2480449"
        ]
        
        isLoading = true

        PromotionManager().commercesInPromotionByLocation(params: params) {
            response in
            
            if let commerces = response?.result {
                
                self.commerces = commerces
                self.footerView.isHidden = !(commerces.count > 0)
            }
            
            self.isLoading = false
            self.tableView.reloadData()
        }
    }
   
    @IBAction func requestPromotion(_ sender: UIButton) {
        
        guard let promotionId = promotion?.id, let promotionType = promotion?.type else {
            
            print("JO: No promotion id.")
            return
        }
        
        guard commerces.count > 0 else {
            
            Core.alert(message: "No hay comercios disponibles.", title: "Lo sentimos", at: self)
            return
        }
        
        guard let uid = App.core.currentUser?.id else {
            print("JO: No UID")
            return
        }
        
        let params: [String: Any] = [
            "promotion": promotionId,
            "user": uid,
            "commerce": commerces[0].id
        ]
        
        sender.isEnabled = false
        requestButton.showLoading()
        
        PromotionManager().applyPromotion(params: params) { (validate) in
            
            self.requestButton.hideLoading()
            
            if validate?.status == "Promotion applied to client"{
                
                let showPopup = UIStoryboard(name: "Promotions", bundle: nil).instantiateViewController(withIdentifier: "SuccessPromoControllerID") as! SuccesPromoController
                
                showPopup.modalPresentationStyle = .popover
                
                showPopup.popoverPresentationController?.sourceRect = CGRect(x: self.view.center.x, y: self.view.center.y, width: 0, height: 0)
                
                showPopup.popoverPresentationController?.sourceView = self.view
                
                showPopup.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                
                showPopup.promotion = self.promotion
                showPopup.commerceId = self.commerces[0].id
                showPopup.userId = uid
                showPopup.token = validate?.token
                self.view.addSubview(showPopup.view)
                sender.isEnabled = true
                
            }else{
                print("JO: Promotion not applied")
            }
        }
    }
    

    @IBAction func closePopUp(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }

}

extension PromotionsDetailsController: UITableViewDelegate, UITableViewDataSource {
    
    // numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commerces.count
    }
    
    // heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    // didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCommerce = commerces[indexPath.row]
        performSegue(withIdentifier: "PromotionToCommerceSegue", sender: self)
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShopCell", for: indexPath) as? ShopCell else { return UITableViewCell() }

        cell.commerce = commerces[indexPath.row]
        
        return cell
    }
    
}

// MARK: TBEMPTYDATASET

extension PromotionsDetailsController: TBEmptyDataSetDelegate, TBEmptyDataSetDataSource {
    
    // imageForEmptyDataSet
    func imageForEmptyDataSet(in scrollView: UIScrollView) -> UIImage? {
        return #imageLiteral(resourceName: "ico-blank_state")
    }
    
    // titleForEmptyDataSet
    func titleForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        
        let emptyTitle = "No hay comercios que tengan esta promocion activa."
        
        let attributes: [NSAttributedStringKey: Any]? = [.font: UIFont(name: "Lato-Black", size: 32) ?? UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.black]
        
        return NSAttributedString(string: emptyTitle, attributes: attributes)
    }
    
    // descriptionForEmptyDataSet
    func descriptionForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        
        let description = ""
        
        let attributes: [NSAttributedStringKey: Any]? = [.font: UIFont(name: "Lato-Regular", size: 18) ?? UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.gray]
        
        return NSAttributedString(string: description, attributes: attributes)
    }
    
    // verticalOffsetForEmptyDataSet
    func verticalOffsetForEmptyDataSet(in scrollView: UIScrollView) -> CGFloat {
        
        if let navigationBar = navigationController?.navigationBar {
            return -navigationBar.frame.height * 0.10
        }
        return 0
    }
    
    // verticalSpacesForEmptyDataSet
    func verticalSpacesForEmptyDataSet(in scrollView: UIScrollView) -> [CGFloat] {
        return [25, 8]
    }
    
    // customViewForEmptyDataSet
    func customViewForEmptyDataSet(in scrollView: UIScrollView) -> UIView? {
        
        print("JO: Empty View")
        
        if isLoading {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityIndicator.startAnimating()
            return activityIndicator
        }
        
        return nil
    }
    
}
