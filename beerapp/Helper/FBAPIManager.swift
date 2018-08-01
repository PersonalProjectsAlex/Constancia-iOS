//
//  File.swift
//  beerapp
//
//  Created by elaniin on 1/24/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import Foundation
import UIKit
import FacebookCore
import FBSDKLoginKit

let kGraphPathMe = "me"
class FacebookAPIManager {
    
    let accessToken: AccessToken
    
    init(accessToken: AccessToken) {
        self.accessToken = accessToken
    }
    
    func requestFacebookUser(completion: @escaping (_ facebookUser: FacebookUser) -> Void) {
  
        let graphRequest = GraphRequest(graphPath: kGraphPathMe, parameters: ["fields":"id,email,last_name,first_name,picture"], accessToken: accessToken, httpMethod: .GET, apiVersion: .defaultVersion)
        
        graphRequest.start { (response: HTTPURLResponse?, result: GraphRequestResult<GraphRequest>) in
            
            switch result {
            case .success(let graphResponse):
                if let dictionary = graphResponse.dictionaryValue {
                    completion(FacebookUser(dictionary: dictionary))
                }
                break
            default:
                print("Facebook request user error")
            }
        }
    }
    

   
    
}
