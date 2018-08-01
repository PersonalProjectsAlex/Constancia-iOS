//
//  EventCell.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 2/25/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit
import SDWebImage

class EventCell: UITableViewCell {

    var event: Event? {
        didSet {
            setupCell(event: event!)
        }
    }

    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    func setupCell(event: Event) {
        
        photoImage.sd_setImage(with: event.image, placeholderImage: nil)
        titleLabel.text = event.name
        descriptionLabel.text = event.description
        
        var details = ""
        if let date = event.date { details += date }
        if let category = event.category { details += " | \(category)" }
        if let zone = event.zone { details += " | \(zone)" }
        
        detailsLabel.text = details
    }
    
}
