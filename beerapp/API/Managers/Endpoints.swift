//
//  Endpoints.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 2/21/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import Foundation

let BASE_URL = "https://api.toolbox-cloud.com/ilc"
let BASE_URL_T = "https://api.toolboxsv.com/ilc"

struct Endpoints {
    
    // User
    static let REGISTER_USER = "\(BASE_URL)/register"
    static let LOG_IN = "\(BASE_URL)/login"
    static let FORGOT_PASSWORD = "\(BASE_URL)/user/validate-email"
    static let UPDATE_PASSWORD = "\(BASE_URL)/change-password"
    static let USER_DETAIL = "\(BASE_URL)/user/details"
    static let USER_COINS_IN_COMMERCE = "\(BASE_URL)/user/details/check_in"
    static let BUY_REWARD = "\(BASE_URL)/rewards/apply"
    static let USER_SUMMARY = "\(BASE_URL)/summary"
    static let USER_SUMMARY_DETAIL = "\(BASE_URL)/summary/detail"
    static let CREATE_GROUP = "\(BASE_URL)/groups/create"
    static let GET_GROUPS = "\(BASE_URL)/groups/list"
    static let GET_GROUPS_DETAILS = "\(BASE_URL)/groups/detail"
    static let ADD_MEMBERS_TO_GROUP = "\(BASE_URL)/groups/members/add"
    static let REMOVE_GROUP_MEMBER = "\(BASE_URL)/groups/members/delete"
    static let VALIDATE_MEMBER = "\(BASE_URL)/user/validate"
    static let UPDATE_PROFILE = "\(BASE_URL)/update"
    static let UPDATE_PHOTO = "\(BASE_URL)/update-photo"
    static let REWARDS_HISTORY = "\(BASE_URL)/rewards/history"
    static let PROMOTIONS_HISTORY = "\(BASE_URL)/promotions/history"
    
    
    // Commerce
    
    static let SEARCH_COMMERCE = "\(BASE_URL)/commerces/search/1"//TODO: Check 1 val
    static let NEARBY_COMMERCES = "\(BASE_URL)/commerces/nearby"
    static let RATE_COMMMERCE = "\(BASE_URL)/commerces/rate"
    static let CHECK_IN = "\(BASE_URL)/commerces/check_in"
    static let ADD_TO_FAV = "\(BASE_URL)/favorites/set"
    static let FAV_LIST = "\(BASE_URL)/favorites/list"
    static let COMMERCE_DETAIL = "\(BASE_URL)/commerces/detail"
    static let APPLY_REWARD = "\(BASE_URL)/rewards/apply"
    
    // Promotions
    
    static let COMMERCES_BY_PROMOTION = "\(BASE_URL)/promotions/available_commerces"
    static let PROMOTIONS_BY_DATE = "\(BASE_URL)/promotions"
    static let APPLY_PROMOTION = "\(BASE_URL)/promotions/apply"
    static let PREORDER_PROMOTION = "\(BASE_URL)/promotions/pre-order"
    static let PROMOTIONS_HISTORY_BY_USER = "\(BASE_URL)/promotions/history"
    static let PROMOTION_DETAIL = "\(BASE_URL)/promotions/detail"
    static let PROMOTIONS_LIST = "\(BASE_URL)/promotions"
    
    // Events
    
    static let EVENTS = "\(BASE_URL)/events/list"
    static let EVENT_DETAIL = "\(BASE_URL)/events/detail"
    
    //Reservations
    static let RESERVATIONS = "\(BASE_URL)/reservations/list"
    static let ADD_RESERVATION = "\(BASE_URL)/reservations/add"
    static let DELETE_RESERVATION = "\(BASE_URL)/reservations/delete"
    
}
