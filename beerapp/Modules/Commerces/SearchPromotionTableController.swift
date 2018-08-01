//
//  SearchPromotionTableController.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 3/7/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit
import TBEmptyDataSet

protocol SearchPromotionProtocol {
    func addPromotionParameter(promotion: Promotion)
}

class SearchPromotionTableController: UITableViewController {
    
    var delegate: SearchPromotionProtocol?
    
    var promotions = [Promotion]()
    var selectedPromotion: Promotion?
    var isLoading = true
    
    // Search bar
    var searchText: String?
    let searchController = UISearchController(searchResultsController: nil)
    var filteredPromotions = [Promotion]()
    
    // MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Promociones"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetDataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
        loadPromotions(by: "month")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.isActive = true
        navigationItem.hidesSearchBarWhenScrolling = false
        
        DispatchQueue.main.async { [unowned self] in
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.isActive = false
    }
    
    // MARK: - SETUPS
    
    func loadPromotions(by date: String){
        
        promotions.removeAll()
        tableView.reloadData()
        
        PromotionManager().promotionsBy(date: date) {
            response in
            self.isLoading = false
            
            
            guard let promos = response?.result else {
                self.isLoading = false
                print("JO: No promos")
                self.tableView.reloadData()
                return
            }
            
            self.promotions = promos
            self.tableView.reloadData()
        }
    }
    
    
    
    fileprivate func setupSearch() {
        
        // Setup the Search Controller
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.isActive = true
        
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let searchBar = searchController.searchBar
        searchBar.placeholder = "Buscar promocion..."
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
    
    // MARK: - SEARCHING
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    @objc
    func filterContentForSearchText(_ searchText: String) {
        filteredPromotions = promotions.filter { $0.name?.lowercased().contains(searchText.lowercased()) ?? false }
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
}

extension SearchPromotionTableController: UISearchControllerDelegate {
    
    func didPresentSearchController(_ searchController: UISearchController) {
        
        print("JO: didPresentSearchController")
        searchController.searchBar.becomeFirstResponder()
    }
    
}

// MARK: - UISearchBarDelegate

extension SearchPromotionTableController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchText = searchText
        // Cancel filterContentForSearchText() excecutions
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(filterContentForSearchText(_:)), object: searchText)
        
        if searchText == "" { self.searchText = nil }
        
        self.perform(#selector(filterContentForSearchText(_:)), with: self.searchText, afterDelay: 0)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchText = nil
        self.perform(#selector(filterContentForSearchText(_:)), with: self.searchText, afterDelay: 0)
    }
}

// MARK: - Table view data source

extension SearchPromotionTableController {
    
    // numberOfSections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering() ? filteredPromotions.count : promotions.count
    }
    
    // cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PromotionNameCell", for: indexPath)
        let row = indexPath.row
        
        cell.textLabel?.text = isFiltering() ? filteredPromotions[row].name : promotions[row].name
        
        return cell
    }
    
    // didSelectRowAt
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        
        let row = indexPath.row
        let promo = isFiltering() ? filteredPromotions[row] : promotions[indexPath.row]
        
        delegate?.addPromotionParameter(promotion: promo)
        _ = navigationController?.popViewController(animated: true)
    }
    
}




extension SearchPromotionTableController: TBEmptyDataSetDelegate, TBEmptyDataSetDataSource {
    
    // imageForEmptyDataSet
    func imageForEmptyDataSet(in scrollView: UIScrollView) -> UIImage? {
        return nil
    }
    
    // titleForEmptyDataSet
    func titleForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        
        let emptyTitle = "No encontramos promociones"
        
        let attributes: [NSAttributedStringKey: Any]? = [.font: UIFont(name: "Lato-Black", size: 32) ?? UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.white]
        
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


