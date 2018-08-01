//
//  ReserveStatus.swift
//  beerapp
//
//  Created by elaniin on 3/8/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import Foundation

class ReserveStatus: Codable {

    let token: String?
    
    
    
    private enum CodingKeys: String, CodingKey {
        case token
        
    }
}
