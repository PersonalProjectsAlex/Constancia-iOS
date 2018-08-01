//
//  SearchTableController.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 3/4/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit
import HexColors
import SwiftyBeaver
import Alamofire
import TBEmptyDataSet

class SearchTableController: UITableViewController {
    
    var isLoading = false
    var searchOnce = false
    
    var commerces = [Commerce]()
    
    var selectedZone: Zone?
    var selectedPromo: Promotion?
    var selectedCommerce: Commerce?
    
    var searchText = ""
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var zoneButton: UIButton!
    @IBOutlet weak var promotionButton: UIButton!
    
    // MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Buscador"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetDataSource = self
        
        setupSearch()
        
        App.core.registerCell(at: tableView, named: "SearchResultCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
        self.setupCoinsItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.isActive = true
        navigationItem.hidesSearchBarWhenScrolling = false
        
        DispatchQueue.main.async { [unowned self] in
            self.searchController.searchBar.becomeFirstResponder()
            self.searchController.searchBar.text = self.searchText
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.isActive = false
    }
    
    // MARK: - NAVIGATION
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SearchToCommerceDetailSegue" {
            let detailController = segue.destination as! ShopDetailController
            detailController.commerce = selectedCommerce
        }
        
        if segue.identifier == "SearchToZoneSegue" {
            let searchZoneController = segue.destination as! SearchZoneTableController
            searchZoneController.delegate = self
        }
        
        if segue.identifier == "SearchToPromotionsSegue" {
            let searchPromotionController = segue.destination as!
            SearchPromotionTableController
            searchPromotionController.delegate = self
        }
    }
    
    // MARK: - SETUPS
    
    fileprivate func setupSearch() {
        
        // Setup the Search Controller
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.isActive = true
        
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let searchBar = searchController.searchBar
        searchBar.placeholder = "Buscar restaurantes..."
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
    
    
    // MARK: - LOADERS
    
    
    func loadCommerces() {
        
        var params: [String: Any] = [:]
        
        if let zone = selectedZone?.id {
            params["zone"] = zone
        }
        
        if let promotion = selectedPromo?.name {
            params["promotion"] = promotion
        }
        
        params["name"] = searchText
        
        self.isLoading = true
        self.searchOnce = true
        self.tableView.reloadData()
        
        CommerceManager().searchBy(params: params) {
            response in
            
            self.isLoading = false
            
            guard let commerces = response?.result else {
                SwiftyBeaver.error("No commerces")
                self.commerces.removeAll()
                self.tableView.reloadData()
                return
            }
            
            self.commerces = commerces
            self.tableView.reloadData()
        }
    }
    
    // MARK: - IBACTIONS
    
    @IBAction func chooseZone(_ sender: UIButton) {
        performSegue(withIdentifier: "SearchToZoneSegue", sender: self)
    }
    
    @IBAction func choosePromo(_ sender: UIButton) {
        performSegue(withIdentifier: "SearchToPromotionsSegue", sender: self)
    }
    
    
}

// MARK: - SearchZoneProtocol, SearchPromotionProtocol

extension SearchTableController: SearchZoneProtocol, SearchPromotionProtocol {
    
    func addZoneParameter(zone: Zone) {
        
        self.selectedZone = zone
        zoneButton.setTitle(zone.name, for: .normal)
        loadCommerces()
        tableView.reloadData()
    }
    
    func addPromotionParameter(promotion: Promotion) {
        
        self.selectedPromo = promotion
        promotionButton.setTitle(promotion.name, for: .normal)

        loadCommerces()
        tableView.reloadData()
    }
    
}

extension SearchTableController: UISearchControllerDelegate {
    
    func didPresentSearchController(_ searchController: UISearchController) {
        
        print("JO: didPresentSearchController")
        searchController.searchBar.becomeFirstResponder()
    }
    
}

extension SearchTableController: UISearchBarDelegate {
    
    // MARK: - Searching
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    @objc func filterContentForSearchText(_ searchText: String?) {
        
        searchController.isActive = true
        self.commerces.removeAll()
        loadCommerces()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.commerces.removeAll()
        self.tableView.reloadData()
        
        self.searchText = searchText
        // Cancel filterContentForSearchText() excecutions
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(filterContentForSearchText(_:)), object: searchText)
        // Cancel Alamofire requests
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
        
        self.perform(#selector(filterContentForSearchText(_:)), with: self.searchText, afterDelay: 0)
    }
    
}

// MARK: - Table view data source

extension SearchTableController {
    
    // numberOfSections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commerces.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // didSelectRowAt
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCommerce = commerces[indexPath.row]
        performSegue(withIdentifier: "SearchToCommerceDetailSegue", sender: self)
    }
    
    // cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as? SearchResultCell else { return UITableViewCell() }
        
        cell.commerce = commerces[indexPath.row]
        
        return cell
    }
}

// MARK: TBEMPTYDATASET

extension SearchTableController: TBEmptyDataSetDelegate, TBEmptyDataSetDataSource {
    
    // imageForEmptyDataSet
    func imageForEmptyDataSet(in scrollView: UIScrollView) -> UIImage? {
        return searchOnce ? #imageLiteral(resourceName: "ico-blank_state") : nil
    }
    
    // titleForEmptyDataSet
    func titleForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        
        let emptyTitle = "No encontramos datos"
        
        let attributes: [NSAttributedStringKey: Any]? = [.font: UIFont(name: "Lato-Black", size: 22) ?? UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.black]
        
        return searchOnce ? NSAttributedString(string: emptyTitle, attributes: attributes) : nil
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



