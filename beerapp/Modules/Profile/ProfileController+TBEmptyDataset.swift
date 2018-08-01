//
//  ProfileController+TBEmptyDataset.swift
//  beerapp
//
//  Created by elaniin on 3/1/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import Foundation

import Foundation
import TBEmptyDataSet

extension ProfileController: TBEmptyDataSetDataSource, TBEmptyDataSetDelegate {
    
    // imageForEmptyDataSet
    func imageForEmptyDataSet(in scrollView: UIScrollView) -> UIImage? {
        return #imageLiteral(resourceName: "ico-blank_state")
    }
    
    // titleForEmptyDataSet
    func titleForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        
        let emptyTitle = "No encontramos datos"
        
        let attributes: [NSAttributedStringKey: Any]? = [.font: UIFont(name: "Lato-Black", size: 25) ?? UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor("748bcb") ?? .black]
        
        return NSAttributedString(string: emptyTitle, attributes: attributes)
    }
    
    // descriptionForEmptyDataSet
    func descriptionForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        
        let description = ""
        
        let attributes: [NSAttributedStringKey: Any]? = [.font: UIFont(name: "Lato-Regular", size: 18) ?? UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor("bcc5de") ?? .black]
        
        return NSAttributedString(string: description, attributes: attributes)
    }
    
    func verticalOffsetForEmptyDataSet(in scrollView: UIScrollView) -> CGFloat {
        if let navigationBar = navigationController?.navigationBar {
            return -navigationBar.frame.height * -2.5
        }
        return 0
    }
    
    func verticalSpacesForEmptyDataSet(in scrollView: UIScrollView) -> [CGFloat] {
        return [0, 0]
    }
    
    
    func customViewForEmptyDataSet(in scrollView: UIScrollView) -> UIView? {
        
        func indicator() -> UIActivityIndicatorView {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityIndicator.startAnimating()
            return activityIndicator
        }
        
        switch selectedTab {
        case .coins: return isLoadingData.coins ? indicator() : nil
        case .rewards: return isLoadingData.rewards ? indicator() : nil
        case .promotions: return isLoadingData.promotions ? indicator() : nil
        }
        
    }
}
