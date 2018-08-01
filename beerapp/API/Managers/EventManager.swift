//
//  EventManager.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 2/22/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import Foundation

class EventManager: APIManager {
    
    /// Events list.
    /// - parameters:
    ///     - zone: Zone ID
    ///     - completionHandler: Callback with [Event] value
    func list(zone: String,category: String, completionHandler handler: @escaping (Response<[Event]>?) -> Void) {
        
        request(endpoint: Endpoints.EVENTS, completionHandler: handler, params: ["zone": zone, "category": category])
    }

    /// Event detail.
    /// - parameters:
    ///     - id: Event ID
    ///     - completionHandler: Callback with Event value
    func detail(id: String, completionHandler handler: @escaping (Response<Event>?) -> Void) {
        
        let eventEndpoint = "\(Endpoints.EVENT_DETAIL)/\(id)"
        
        request(endpoint: eventEndpoint, completionHandler: handler, method: .get)
    }

    
}

