//
//  CheckInViewController.swift
//  beerapp
//
//  Created by elaniin on 2/15/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit
import TBEmptyDataSet
import SwiftyBeaver

class CheckInViewController: UIViewController {
    
    // MARK: - LET/VAR/IBOUTLET
    
    var isLoading = true
    let refresh = UIRefreshControl()
    var checkIns = [CoinsPerCommerce]()
    var selectedCommerce: CoinsPerCommerce?
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetDataSource = self
        
        
        Core.shared.registerCell(at: tableView, named: "CheckInCell")
        
        refresh.addTarget(self, action: #selector(setupData), for: .valueChanged)
        refresh.attributedTitle = NSAttributedString(string: "Recargar")
        refresh.tintColor = .lightGray
        tableView.refreshControl = refresh
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupCoinsItem()
        loadCheckIns()
    }
    
    // MARK: - NAVIGATION
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CheckInToCommerceDetailSegue" {
            
            let detailController = segue.destination as! ShopDetailController
            //detailController.commerceId = selectedCommerce?.id
            detailController.commerceId = selectedCommerce?.id
        }
    }
    
    // MARK: - LOADER/SETUP
    
    @objc func setupData(){
        
        isLoading = true
        loadCheckIns()
        refresh.endRefreshing()
        
    }
    
    fileprivate func loadCheckIns() {
        
        isLoading = true
        checkIns.removeAll()
        tableView.reloadData()
        
        guard let uid = App.core.currentUser?.id else {
            print("JO: No UID")
            return
        }
        
        UserManager().getUserCoinsAt(uid: uid) {
            response in
            
            if let checkIns = response?.result {
               self.checkIns = checkIns
            }
            
            self.isLoading = false
            self.tableView.reloadData()
        }
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CheckInViewController: UITableViewDelegate, UITableViewDataSource {
    
    // numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkIns.count
    }
    
    // heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    // didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCommerce = checkIns[indexPath.row]
        performSegue(withIdentifier: "CheckInToCommerceDetailSegue", sender: self)
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CheckInCell", for: indexPath) as? CheckInCell else { return UITableViewCell() }
        
        cell.commerce = checkIns[indexPath.row]
        
        return cell
    }
}

// MARK: TBEMPTYDATASET

extension CheckInViewController: TBEmptyDataSetDelegate, TBEmptyDataSetDataSource {
    
    // imageForEmptyDataSet
    func imageForEmptyDataSet(in scrollView: UIScrollView) -> UIImage? {
        return #imageLiteral(resourceName: "ico-blank_state")
    }
    
    // titleForEmptyDataSet
    func titleForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        
        let emptyTitle = "¡No has hecho check in!"
        
        let attributes: [NSAttributedStringKey: Any]? = [.font: UIFont(name: "Lato-Black", size: 32) ?? UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor("748bcb") ?? .black]
        
        return NSAttributedString(string: emptyTitle, attributes: attributes)
    }
    
    // descriptionForEmptyDataSet
    func descriptionForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        
        let description = "Recuerda que si puedes registrar tu llegada a un comercio haciendo check in."
        
        let attributes: [NSAttributedStringKey: Any]? = [.font: UIFont(name: "Lato-Regular", size: 18) ?? UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor("bcc5de") ?? .black]
        
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
