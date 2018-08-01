//
//  Response.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 2/20/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import Foundation

/// Response
struct Response<T: Codable>: Codable {
    
    let status: String?
    let id: String?
    let token: String?
    let result: T?
}


struct Empty: Codable {}

struct TokenResponse: Codable {
    let status: String?
    let token: String?
}
