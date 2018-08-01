//
//  Zone.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 2/26/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import Foundation

struct Zone: Codable {
    let id: String
    let name: String
}

func loadZonesJson(filename fileName: String) -> [Zone]? {
    
    if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(Response<[Zone]>.self, from: data)
            return jsonData.result
        } catch { print("Load JSON: Error: \(error)") }
    }
    return nil
}
