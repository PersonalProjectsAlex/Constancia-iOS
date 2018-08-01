//
//  User.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 2/20/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import Foundation

struct User: Codable {
    
    let id: String?
    let username: String?
    let email: String?
    let name: String?
    let birthdate: String?
    let gender: String?
    let favoriteTeam: String?
    let totalcoins: String?
    let photo: URL?
    let commerces: [Commerce]?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case username
        case email
        case name
        case birthdate
        case gender
        case favoriteTeam = "favorite_team"
        case totalcoins = "total_coins"
        case photo
        case commerces
    }
}
