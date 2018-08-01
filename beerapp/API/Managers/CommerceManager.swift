//
//  CommerceManager.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 2/21/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import Foundation

class CommerceManager: APIManager {
    
    /// Search commerces.
    /// - parameters:
    ///     - params: name, zone, promotion
    ///     - completionHandler: Callback with [commerce] valueS
    func searchBy(params: Params, completionHandler handler: @escaping (Response<[Commerce]>?) -> Void) {
        
        request(endpoint: Endpoints.SEARCH_COMMERCE, completionHandler: handler, params: params)
    }
    
    /// Nearby commerces.
    /// - parameters:
    ///     - params: lat, lon
    ///     - completionHandler: Callback with [commerce] value
    func nearby(params: Params, completionHandler handler: @escaping (Response<[Commerce]>?) -> Void) {
        
        request(endpoint: Endpoints.NEARBY_COMMERCES, completionHandler: handler, params: params)
    }
    
    /// Rate commerce.
    /// - parameters:
    ///     - commerce: Commerce ID
    ///     - params: user, rating, comment
    ///     - completionHandler: Callback with status value
    func rate(commerce: String, params: Params, completionHandler handler: @escaping (Response<Empty>?) -> Void) {
        
        let rateCommerceEndpoint = "\(Endpoints.RATE_COMMMERCE)/\(commerce)"
        request(endpoint: rateCommerceEndpoint, completionHandler: handler, params: params)
    }
    
    /// Check In Commerce.
    /// - parameters:
    ///     - params: commerce, user
    ///     - completionHandler: Callback with status value
    func checkIn(params: Params, completionHandler handler: @escaping (Response<Empty>?) -> Void) {
        
        request(endpoint: Endpoints.CHECK_IN, completionHandler: handler, params: params)
    }
    
    /// Add to favourites.
    /// - parameters:
    ///     - params: commerce, user
    ///     - completionHandler: Callback with status value
    func addToFavourites(params: Params, completionHandler handler: @escaping (Response<Empty>?) -> Void) {
        
        request(endpoint: Endpoints.ADD_TO_FAV, completionHandler: handler, params: params)
    }
    
    /// Get favourite commerces list.
    /// - parameters:
    ///     - uid: uid
    ///     - completionHandler: Callback with status value
    func getFavouriteList(uid: String, completionHandler handler: @escaping (Response<[Commerce]>?) -> Void) {
        
        let favouriteListEndpoint = "\(Endpoints.FAV_LIST)/\(uid)"
        request(endpoint: favouriteListEndpoint, completionHandler: handler, method: .get)
    }
    
    /// Get promotions by commerce list.
    /// - parameters:
    ///     - params: user
    ///     - id: Commerce ID
    ///     - completionHandler: Callback with status value
    func commercePromotionsDetail(params: Params, id: String, completionHandler handler: @escaping (Response<Commerce>?) -> Void) {
        
        let commerceDetailEndpoint = "\(Endpoints.COMMERCE_DETAIL)/\(id)"
        request(endpoint: commerceDetailEndpoint, completionHandler: handler, params: params)
    }
    
    /// Reclaim reward.
    /// - parameters:
    ///     - params: reward, user, commerce
    ///     - completionHandler: Callback with status & token value
    func apply(params: Params, completionHandler handler: @escaping (Response<Empty>?) -> Void) {
        
        request(endpoint: Endpoints.APPLY_REWARD, completionHandler: handler, params: params)
    }
}

