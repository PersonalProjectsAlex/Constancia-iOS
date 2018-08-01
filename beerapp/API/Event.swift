//
//  Event.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 2/20/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import Foundation

struct Event: Codable {
    
    let id: String?
    let name: String?
    let description: String?
    let image: URL?
    let category: String?
    let date: String?
    let zone: String?
}
