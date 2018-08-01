//
//  RewardHistory.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 3/15/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import Foundation

struct RewardHistory: Codable {
    
    let id: String?
    let historyId: String?
    let status: String?
    let name: String?
    let applicationDate: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case historyId = "history_id"
        case status
        case name
        case applicationDate = "application_date"
    }
}
