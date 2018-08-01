//
//  UserManager.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 2/21/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import Foundation

class UserManager: APIManager {
    
    /// Register User.
    /// - parameters:
    ///     - params: username, email, password, fbid, name, birthdate, gender, favorite_team
    ///     - completionHandler: Callback with status value
    func register(params: Params, completionHandler handler: @escaping (LoginResponse?) -> Void) {
        
        request(endpoint: Endpoints.REGISTER_USER, completionHandler: handler, params: params)
    }
    
    /// Log In.
    /// - parameters:
    ///     - params: username, password
    ///     - completionHandler: Callback with LoginResponse value
    func logIn(params: Params, completionHandler handler: @escaping (LoginResponse?) -> Void) {
        
        request(endpoint: Endpoints.LOG_IN, completionHandler: handler, params: params)
    }
    
    /// Forgot Password.
    /// - parameters:
    ///     - params: email
    ///     - completionHandler: Callback with status value
    func forgotPassword(params: Params, completionHandler handler: @escaping (Response<Empty>?) -> Void) {
        
        request(endpoint: Endpoints.FORGOT_PASSWORD, completionHandler: handler, params: params)
    }
    
    /// Update Password.
    /// - parameters:
    ///     - params: user, password
    ///     - completionHandler: Callback with status value
    func updatePassword(params: Params, completionHandler handler: @escaping (Response<Empty>?) -> Void) {
        
        request(endpoint: Endpoints.UPDATE_PASSWORD, completionHandler: handler, params: params)
    }
    
    /// User Detail.
    /// - parameters:
    ///     - uid: User ID
    ///     - completionHandler: Callback with user value
    func getUserDetail(uid: String, completionHandler handler: @escaping (Response<User>?) -> Void) {
        
        let userDetailEndpoint = "\(Endpoints.USER_DETAIL)/\(uid)"
        request(endpoint: userDetailEndpoint, completionHandler: handler, method: .get)
    }
    
    
    /// Update profile.
    /// - parameters:
    ///     - uid: User ID
    ///     -username,favorite_team
    ///     - completionHandler: Callback with user value
    func updateProfile(params: Params, uid: String, completionHandler handler: @escaping (Response<Empty>?) -> Void) {
        
        let updateProfile = "\(Endpoints.UPDATE_PROFILE)/\(uid)"
        
        request(endpoint: updateProfile, completionHandler: handler, params: params)
        
    }
    
    /// User Coins In Commerce.
    /// - parameters:
    ///     - commerce: Commerce ID
    ///     - completionHandler: Callback with coins per commerce value
    func getUserCoinsAt(commerce: String, completionHandler handler: @escaping (Response<[CoinsPerCommerce]>?) -> Void) {
        
        let userCoinsEndpoint = "\(Endpoints.USER_COINS_IN_COMMERCE)/\(commerce)"
        request(endpoint: userCoinsEndpoint, completionHandler: handler, method: .get)
    }
    
    /// Buy Reward.
    /// - parameters:
    ///     - params: user, reward
    ///     - completionHandler: Callback with status value
    func buyReward(params: Params, completionHandler handler: @escaping (Response<Empty>?) -> Void) {
        
        request(endpoint: Endpoints.BUY_REWARD, completionHandler: handler, params: params)
    }
    
    /// Validate User.
    /// - parameters:
    ///     - params: username
    ///     - completionHandler: Callback with status value
    func validateUser(params: Params, completionHandler handler: @escaping (Response<
        Empty>?) -> Void) {
        
        request(endpoint: Endpoints.VALIDATE_MEMBER, completionHandler: handler, params: params)
    }
    
    /// Create Group.
    /// - parameters:
    ///     - params: name, created_by
    ///     - completionHandler: Callback with status value
    func createGroup(params: Params, completionHandler handler: @escaping (Response<
    Empty>?) -> Void) {
        
        request(endpoint: Endpoints.CREATE_GROUP, completionHandler: handler, params: params)
    }
    
    /// User Coins In Commerce.
    /// - parameters:
    ///     - uid: User ID
    ///     - completionHandler: Callback with coins per commerce value
    func getUserCoinsAt(uid: String, completionHandler handler: @escaping (Response<[CoinsPerCommerce]>?) -> Void) {
        
        let userCoinsEndpoint = "\(Endpoints.USER_COINS_IN_COMMERCE)/\(uid)"
        request(endpoint: userCoinsEndpoint, completionHandler: handler, method: .get)
    }
    
    
    
    /// Get Groups.
    /// - parameters:
    ///     - uid: Group ID
    ///     - completionHandler: Callback with status value
    func getGroups(uid: String, completionHandler handler: @escaping (Response<[Groups]>?) -> Void) {
        
        let getGroups = "\(Endpoints.GET_GROUPS)/\(uid)"
        
        request(endpoint: getGroups, completionHandler: handler, method: .get)
    }
    
    // Get Groups Details.
    /// - parameters:
    ///     - uid: Group ID
    ///     - completionHandler: Callback with status value
    func getGroupsDetails(uid: String, completionHandler handler: @escaping (Response<GroupsDetails>?) -> Void) {
        
        let getGroupDetail = "\(Endpoints.GET_GROUPS_DETAILS)/\(uid)"
        
        request(endpoint: getGroupDetail, completionHandler: handler, method: .get)
    }
    
    /// Add memebers to group.
    /// - parameters:
    ///     - params: users, group
    ///     - completionHandler: Callback with status value
    func addGroupMembers(params: Params, completionHandler handler: @escaping (Response<Empty>?) -> Void) {
        
        request(endpoint: Endpoints.ADD_MEMBERS_TO_GROUP, completionHandler: handler, params: params)
    }
    
    
    /// Remove memeber from group.
    /// - parameters:
    ///     - params: user, group
    ///     - completionHandler: Callback with status value
    func removeGroupMember(params: Params, completionHandler handler: @escaping (Response<Empty>?) -> Void) {
        
        request(endpoint: Endpoints.REMOVE_GROUP_MEMBER, completionHandler: handler, params: params)
    }
    
    /// User summary info.
    /// - parameters:
    ///     - uid: User ID
    ///     - completionHandler: Callback with status value
    func summaryOf(uid: String, completionHandler handler: @escaping (Response<User>?) -> Void) {
        
        let userSummaryEndpoint = "\(Endpoints.USER_SUMMARY)/\(uid)"
        
        request(endpoint: userSummaryEndpoint, completionHandler: handler, method: .get)
    }
    
    /// User summary detail info.
    /// - parameters:
    ///     - uid: User ID
    ///     - completionHandler: Callback with status value
    func summaryDetailOf(uid: String, completionHandler handler: @escaping (Response<User>?) -> Void) {
        
        let userSummaryEndpoint = "\(Endpoints.USER_SUMMARY_DETAIL)/\(uid)"
        
        request(endpoint: userSummaryEndpoint, completionHandler: handler, method: .get)
    }
    
    /// Add a reservation.
    /// - parameters:
    ///     - params: name, qty, notes, datetime, group, commerce, createby
    ///     - completionHandler: Callback with status value
    func addReservation(params: Params, completionHandler handler: @escaping (Response<Empty>?) -> Void) {
        
        request(endpoint: Endpoints.ADD_RESERVATION, completionHandler: handler, params: params)
    }
    
    /// Reservations made.
    /// - parameters:
    ///     - uid: User ID
    ///     - completionHandler: Callback with status value
    func getReservations(uid: String, completionHandler handler: @escaping (Response<[Reservations]>?) -> Void) {
        
        let getereservationsEndpoint = "\(Endpoints.RESERVATIONS)/\(uid)"
        
        request(endpoint: getereservationsEndpoint, completionHandler: handler, method: .get)
    }
    
    /// Remove memeber from group.
    /// - parameters:
    ///     - params: user, group
    ///     - completionHandler: Callback with status value
    func removeReservation(params: Params, completionHandler handler: @escaping (Response<Empty>?) -> Void) {
        
        request(endpoint: Endpoints.DELETE_RESERVATION, completionHandler: handler, params: params)
    }
    
    /// User rewards history.
    /// - parameters:
    ///     - uid: User ID
    ///     - completionHandler: Callback with reward history values
    func getRewardsHisory(uid: String, completionHandler handler: @escaping (Response<[RewardHistory]>?) -> Void) {
        
        let rewardHisoty = "\(Endpoints.REWARDS_HISTORY)/\(uid)"
        
        request(endpoint: rewardHisoty, completionHandler: handler, method: .get)
    }
    
    /// Add a reservation.
    /// - parameters:
    ///     - params: photo
    ///     - completionHandler: Callback with status value
    func updatePhoto(params: Params, uid: String, completionHandler handler: @escaping (Response<Empty>?) -> Void) {
        
        let updatePhoto = "\(Endpoints.UPDATE_PHOTO)/\(uid)"
        request(endpoint: updatePhoto, completionHandler: handler, params: params)
    }
    
}

