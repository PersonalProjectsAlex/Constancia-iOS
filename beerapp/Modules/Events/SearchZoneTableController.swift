//
//  SearchZoneTableController.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 3/7/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit

protocol SearchZoneProtocol {
    func addZoneParameter(zone: Zone)
}

class SearchZoneTableController: UITableViewController {

    var delegate: SearchZoneProtocol?
    
    var zones = [Zone]()
    var selectedZone: Zone?
    
    // Search bar
    var searchText: String?
    let searchController = UISearchController(searchResultsController: nil)
    var filteredZones = [Zone]()
    
    // MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Departamentos"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        loadZones()
        setupSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.isActive = true
        navigationItem.hidesSearchBarWhenScrolling = true
    }

    // MARK: - SETUPS
    
    func loadZones(completion: (()->Void)? = nil) {
        
        guard let zones = loadZonesJson(filename: "Zones") else {
            print("JO: No zones")
            return
        }
        
        self.zones = zones
        tableView.reloadData()
    }
    
    fileprivate func setupSearch() {
        
        // Setup the Search Controller
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.isActive = true
        
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let searchBar = searchController.searchBar
        searchBar.placeholder = "Buscar departamento..."
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
        filteredZones = zones.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

}

// MARK: - UISearchBarDelegate

extension SearchZoneTableController: UISearchBarDelegate {
    
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

extension SearchZoneTableController {
    
    // numberOfSections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering() ? filteredZones.count : zones.count
    }
    
    // cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZoneCell", for: indexPath)
        let row = indexPath.row
        
        cell.textLabel?.text = isFiltering() ? filteredZones[row].name : zones[row].name
        
        return cell
    }
    
    // didSelectRowAt
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        
        let row = indexPath.row
        let zone = isFiltering() ? filteredZones[row] : zones[indexPath.row]
        
        delegate?.addZoneParameter(zone: zone)
        _ = navigationController?.popViewController(animated: true)
    }
}
