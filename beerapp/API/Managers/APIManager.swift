//
//  APIManager.swift
//  desafio-movistar-ios
//
//  Created by Jonathan Solorzano on 2/8/18.
//  Copyright © 2018 elaniin. All rights reserved.
//

import Foundation
import Alamofire
import CodableAlamofire

typealias Params = [String: Any]?

class APIManager {
    
    func request<T: Codable>(endpoint: String, completionHandler: @escaping (T?) -> Void, method: HTTPMethod = .post, params: Parameters? = nil, keyPath: String? = nil) {
        
        let url = URL(string: endpoint)!
        let utilityQueue = DispatchQueue.global(qos: .utility)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        print("JO: Endpoint: \(endpoint), \(method)")
        print("JO: Params: \(params as? NSDictionary)")
        
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 15

        Alamofire.request(url, method: method, parameters: params)
            .responseDecodableObject(queue: utilityQueue, keyPath: keyPath, decoder: decoder) { (response: DataResponse<T>) in
                
                print(response)
                
                response.result.ifFailure { print("ERROR: \(response.result.error.debugDescription)") }
                
                DispatchQueue.main.sync {
                    if let object = response.value { completionHandler(object) }
                    else { completionHandler(nil) }
                }
        }
        
    }
    
}
