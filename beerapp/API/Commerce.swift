//
//  Commerce.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 2/20/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import Foundation

struct Commerce: Codable  {
    
    let id: String?
    let name: String?
    let logo: String?
    let photo: String?
    let address: String?
    let lat: String?
    let lon: String?
    let phone: String?
    let schedule: String?
    let baldePrice: String?
    let hielerazoPrice: String?
    let speciality: String?
    let checkinCoins: String?
    let distance: String?
    let isfavorite: String?
    let type: String?
    let promotions: [Promotion]?
    var rewards: [Reward]?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case logo
        case photo
        case address
        case lat
        case lon
        case phone
        case schedule
        case baldePrice = "balde_price"
        case hielerazoPrice = "hielerazo_price"
        case speciality
        case checkinCoins = "checkin_coins"
        case distance
        case isfavorite
        case type
        case promotions
        case rewards
    }
}
