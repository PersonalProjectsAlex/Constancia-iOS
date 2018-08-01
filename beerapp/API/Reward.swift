//
//  Reward.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 2/20/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import Foundation

struct Reward: Codable {
    
    let id: String?
    let name: String?
    let coinsValue: String?
    let token: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case coinsValue = "coins_value"
        case token
    }
}
