//
//  EventsController.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 2/25/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit
import DropDown
import SwiftyBeaver
import TBEmptyDataSet

class EventsController: UIViewController {

    // MARK: - LET/VAR/IBOUTLET
    
    var isLoading = true
    
    var events = [Event]()
    var zones = [Zone]()
    var selectedEvent: Event?
    var selectedZone: Zone?
    var selectedCategory = ""
    let restaurantsDropdown = DropDown()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var restaurantsButton: UIButton!
    @IBOutlet weak var zoneButton: UIButton!
    
    // MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Eventos"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetDataSource = self
        loadEvents()
        Core.shared.registerCell(at: tableView, named: "EventCell")
        
        setupRestaurantsDropdown()// TODO: Remove, load restaurants.
        
        self.setupCoinsItem()
        
    }
    
    // MARK: - NAVIGATION
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EventsToDetailSegue" {
            
            let detailController = segue.destination as! EventDetailTableController
            detailController.event = selectedEvent
        }
        
        if segue.identifier == "EventsToSearchZone" {
            
            let searchZoneController = segue.destination as! SearchZoneTableController
            searchZoneController.delegate = self
        }
    }
    
    // MARK: - IBACTIONS
    
    @IBAction func selectRestaurant(_ sender: UIButton) {
        restaurantsDropdown.show()
    }

    @IBAction func selectZone(_ sender: UIButton) {
        performSegue(withIdentifier: "EventsToSearchZone", sender: self)
    }
    
    // MARK: - SETUPS
    
    fileprivate func setupRestaurantsDropdown() {
        
        restaurantsDropdown.anchorView = restaurantsButton
        restaurantsDropdown.dataSource = ["Fiestas Aniversarios", "Noticias", "Música en Vivo"]
        
        restaurantsDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.restaurantsButton.setTitle(item, for: .normal)
            self.selectedCategory = item
            self.loadEvents()
        }
        
    }
    
    // MARK: - LOADERS
    
    func loadEvents() {
        
        self.isLoading = true
        self.events.removeAll()
        self.tableView.reloadData()
        
        EventManager().list(zone: selectedZone?.id ?? "", category: selectedCategory) {
            response in
            
            self.isLoading = false
            
            guard let events = response?.result else {
              
                SwiftyBeaver.error("No Event Results")
                self.tableView.reloadData()
                return
            }
            
            self.events = events
            self.tableView.reloadData()
        }
    }
    
}

// MARK: - SearchZoneProtocol

extension EventsController: SearchZoneProtocol {
    
    func addZoneParameter(zone: Zone) {
        zoneButton.setTitle(zone.name, for: .normal)
        selectedZone = zone
        loadEvents()
    }
    
}

// MARK: TABLE VIEW DELEGATE & DATASOURCE

extension EventsController: UITableViewDelegate, UITableViewDataSource {

    // numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    // didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedEvent = events[indexPath.row]
        performSegue(withIdentifier: "EventsToDetailSegue", sender: self)
    }
    
    // heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as? EventCell else { return UITableViewCell() }
        
        cell.event = events[indexPath.row]
        
        return cell
    }
    
}

// MARK: TBEMPTYDATASET

extension EventsController: TBEmptyDataSetDelegate, TBEmptyDataSetDataSource {
    
    // imageForEmptyDataSet
    func imageForEmptyDataSet(in scrollView: UIScrollView) -> UIImage? {
        return #imageLiteral(resourceName: "ico-blank_state")
    }
    
    // titleForEmptyDataSet
    func titleForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        
        let emptyTitle = "¡Lo sentimos!"
        
        let attributes: [NSAttributedStringKey: Any]? = [.font: UIFont(name: "Lato-Black", size: 32) ?? UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor("748bcb") ?? .black]
        
        return NSAttributedString(string: emptyTitle, attributes: attributes)
    }
    
    // descriptionForEmptyDataSet
    func descriptionForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        
        let description = "No hemos encontrado eventos."
        
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

