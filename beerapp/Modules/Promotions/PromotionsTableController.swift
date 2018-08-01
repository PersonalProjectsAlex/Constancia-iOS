//
//  PromotionsTableController.swift
//  beerapp
//
//  Created by alex on 2/6/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//
import UIKit
import SwiftyBeaver
import SDWebImage
import HexColors
import TBEmptyDataSet

class PromotionsTableController: UIViewController {
    
    // MARK: - Let/Var
    
    var isLoading = true
    let refresh = UIRefreshControl()
    var promotions = [Promotion]()
    var selectedPromotion: Promotion?
    
    // MARK: - Outlets
    
    @IBOutlet weak var promotionsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.emptyDataSetDataSource = self
        tableView.emptyDataSetDelegate = self
        
        refresh.addTarget(self, action: #selector(setupData), for: .valueChanged)
        refresh.attributedTitle = NSAttributedString(string: "Recargar")
        refresh.tintColor = .lightGray
        tableView.refreshControl = refresh
        
        promotionsSegmentedControl.selectedSegmentIndex = 0
        
        setupData()
    }
    
    @objc func setupData(){
        
        isLoading = true
        promotions.removeAll()
        
        switch promotionsSegmentedControl.selectedSegmentIndex {
        case 0:
            
            self.loadPromotions(by: "today")
            refresh.endRefreshing()
            tableView.reloadData()
        case 1:
            self.loadPromotions(by: "month")
            refresh.endRefreshing()
            tableView.reloadData()
        default: break
        
        
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        loadPromotions(by: "today")
//
//        let getUserID = UserDefaults.standard.string(forKey: "user_id")
//        print("UserID:"+getUserID!)
//        UserManager().summaryOf(uid: getUserID!) { (user) in
//            if user?.status == "true"{
//                if let coins = user?.result?.totalcoins{
//                    self.setupCoinsItem(coins: coins)
//                }
//
//            }
//        }
//    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PromotionsToDetailsPromotions" {
            
            let detailController = segue.destination as! PromotionsDetailsController
            detailController.promotion = selectedPromotion
        }
    }
    
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        
        promotions.removeAll()
        tableView.reloadData()
        isLoading = true
        
        switch promotionsSegmentedControl.selectedSegmentIndex {
        case 0: self.loadPromotions(by: "today")
        case 1: self.loadPromotions(by: "month")
        default: break
        }
    }
    
    
    // MARK: - Helpers/Initializers/Setups
    
    func loadPromotions(by date: String){
        
        promotions.removeAll()
        tableView.reloadData()
        
        PromotionManager().promotionsBy(date: date) {
            response in
            
            self.isLoading = false
            
            guard let promos = response?.result else {
                
                print("JO: No promos")
                self.tableView.reloadData()
                return
            }
            
            self.promotions = promos
            self.tableView.reloadData()
        }
    }
    
}

// MARK: - TABLEVIEW DELEGATE & DATASOURCE
extension PromotionsTableController: UITableViewDelegate, UITableViewDataSource {
    
    // numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.promotions.count
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PromotionsCells", for: indexPath) as? PromotionsCell else { return UITableViewCell() }
        
        cell.promotions = promotions[indexPath.row]
        
        return cell
    }
    
    // didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedPromotion = promotions[indexPath.row]
        performSegue(withIdentifier: "PromotionsToDetailsPromotions", sender: self)
    }
    
}

// MARK: TBEMPTYDATASET
extension PromotionsTableController: TBEmptyDataSetDelegate, TBEmptyDataSetDataSource {
    
    // imageForEmptyDataSet
    func imageForEmptyDataSet(in scrollView: UIScrollView) -> UIImage? {
        return #imageLiteral(resourceName: "ico-blank_state")
    }
    
    // titleForEmptyDataSet
    func titleForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        
        let emptyTitle = "No encontramos datos"
        
        let attributes: [NSAttributedStringKey: Any]? = [.font: UIFont(name: "Lato-Black", size: 30) ?? UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.black]
        
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
        
        if isLoading {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityIndicator.startAnimating()
            return activityIndicator
        }
        
        return nil
    }
    
}
