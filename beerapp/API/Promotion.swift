//
//  Promotion.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 2/20/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import Foundation

struct Promotion: Codable {
    
    let id: String?
    let name: String?
    let price: String?
    let type: String?
    let checkintype: String?
    let duration: String?
    let image: String?
    let restriction: String?
    let beginDate: String?
    let endDate: String?
    let applicationDate: String?
    let token: String?
    let status: String?
    
    // Record
    let historyId: String?
    let reserved: String?
    
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case price
        case type
        case checkintype = "checkin_type"
        case duration
        case image
        case restriction
        case beginDate = "begin_date"
        case endDate = "end_date"
        case applicationDate = "application_date"
        case token
        case status
        case historyId = "history_id"
        case reserved
    }
}
