//
//  EventDetailTableController.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 2/26/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit

class EventDetailTableController: UITableViewController {

    // MARK: LET/VAR/IBOUTLET
    var event: Event?
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEvent()
    }
    
    // MARK: - SETUP/LOADERS
    
    func setupEvent() {
        
        photoImage.sd_setImage(with: event?.image, placeholderImage: nil)
        nameLabel.text = event?.name
    }
    
    // MARK: - IBACTIONS
    
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}

// MARK: - Table view data source
extension EventDetailTableController {
    
    // numberOfSections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath) as? DescriptionCell else {
            return UITableViewCell()
        }
        
        cell.descriptionLabel.text = event?.description
        
        return cell
    }
}
