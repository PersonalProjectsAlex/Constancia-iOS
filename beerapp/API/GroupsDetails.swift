//
//  GroupsDetails.swift
//  beerapp
//
//  Created by alex on 2/28/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit


class GroupsDetails: Codable {
    let id: String?
    let token: String?
    let name: String?
    let label: String?
    let members: [User]?
    let reservations: [Reservations]?
    let promotions: [Promotion]?
    
}
