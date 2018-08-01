//
//  PromotionManager.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 2/22/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import Foundation

class PromotionManager: APIManager {
    
    /// Promotions list.
    /// - parameters:
    ///     - completionHandler: Callback with [promotion] value
    func list(completionHandler handler: @escaping (Response<[Promotion]>?) -> Void) {
        
        request(endpoint: Endpoints.PROMOTIONS_LIST, completionHandler: handler, method: .get)
    }
    
    /// Commerces by promotion by location.
    /// - parameters:
    ///     - params: promotion, lat, lon
    ///     - completionHandler: Callback with [commerce] value
    func commercesInPromotionByLocation(params: Params, completionHandler handler: @escaping (Response<[Commerce]>?) -> Void) {
        
        request(endpoint: Endpoints.COMMERCES_BY_PROMOTION, completionHandler: handler, params: params)
    }
    
    /// Get promotions by date.
    /// - parameters:
    ///     - date: day, month
    ///     - completionHandler: Callback with status value
    func promotionsBy(date: String, completionHandler handler: @escaping (Response<[Promotion]>?) -> Void) {
        
        let params: Params = [ "flag": date ]
        
        request(endpoint: Endpoints.PROMOTIONS_BY_DATE, completionHandler: handler, params: params)
    }
    
    /// Apply promotion to client.
    /// - parameters:
    ///     - date: promotion, user
    ///     - completionHandler: Callback with status value
    func applyPromotion(params: Params, completionHandler handler: @escaping (Response<Empty>?) -> Void) {
        
        request(endpoint: Endpoints.APPLY_PROMOTION, completionHandler: handler, params: params)
    }
    
    /// Preorder promotion.
    /// - parameters:
    ///     - params: promotion, user
    ///     - completionHandler: Callback with status value
    func preorder(params: Params, completionHandler handler: @escaping (Response<Empty>?) -> Void) {
        
        request(endpoint: Endpoints.PREORDER_PROMOTION, completionHandler: handler, params: params)
    }
    
    /// Promotion history by user.
    /// - parameters:
    ///     - uid: User ID
    ///     - completionHandler: Callback with [Promotion] value
    func history(uid: String, completionHandler handler: @escaping (Response<[Promotion]>?) -> Void) {
        
        let promotionHistoryEndpoint = "\(Endpoints.PROMOTIONS_HISTORY_BY_USER)/\(uid)"
        
        request(endpoint: promotionHistoryEndpoint, completionHandler: handler, method: .get)
    }
    
    /// Promotion detail.
    /// - parameters:
    ///     - id: Promotion ID
    ///     - completionHandler: Callback with [Promotion] value
    func detailOf(id: String, completionHandler handler: @escaping (Response<[Promotion]>?) -> Void) {
        
        let promotionDetailEndpoint = "\(Endpoints.PROMOTION_DETAIL)/\(id)"
        
        request(endpoint: promotionDetailEndpoint, completionHandler: handler, method: .get)
    }
    
}

