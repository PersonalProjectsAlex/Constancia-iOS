//
//  Reservations.swift
//  beerapp
//
//  Created by alex on 2/27/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit

class Reservations: Codable {
    let id: String?
    let token: String?
    let name: String?
    let qty: String?
    let reservationdate: String?
    let groupid: String?
    let groupname: String?
    let commercename: String?
    let commerceaddress: String?
    let notes: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case token
        case name
        case qty
        case reservationdate = "reservation_date"
        case groupid = "group_id"
        case groupname = "group_name"
        case commercename = "commerce_name"
        case commerceaddress = "commerce_address"
        case notes
    }
}

