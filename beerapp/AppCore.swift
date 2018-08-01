//
//  AppCore.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 2/28/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit

class App {
    
    static let core = App()
    private init() {}
    
    var currentUser: User?
    
    /// Show alert
    func alert(message: String, title: String, at viewController: UIViewController){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
}

/// MARK: - Validations

extension App {
    
    func validate(email: String?) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}

/// MARK: - Table Views

extension App {
    
    /// Register cell at a table view
    func registerCell(at tableView: UITableView, named: String, withIdentifier: String? = nil) {
        let coffeeCellNib = UINib(nibName: named, bundle: nil)
        tableView.register(coffeeCellNib, forCellReuseIdentifier: withIdentifier ?? named)
    }
    
    /// Register header/footer at a table view
    func registerHeaderFooter(at tableView: UITableView, named: String, withIdentifier: String? = nil) {
        let nib = UINib(nibName: named, bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: withIdentifier ?? named)
    }
}

/// MARK: - UIApplication

extension App {
    
    func switchStoryboard(name: String, viewControllerIdentifier id: String, completion: ((Bool) -> Void)? = nil) {
        
        guard let window = UIApplication.shared.keyWindow, window.rootViewController != nil else {
            
            print("JO: No window or root controller")
            return
        }
        
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: id)
        
        window.set(rootViewController: viewController)
    }
}

extension UIWindow {
    
    /// Fix for http://stackoverflow.com/a/27153956/849645
    func set(rootViewController newRootViewController: UIViewController, withTransition transition: CATransition? = nil) {
        
        let previousViewController = rootViewController
        
        if let transition = transition {
            // Add the transition
            layer.add(transition, forKey: kCATransition)
        }
        
        rootViewController = newRootViewController
        
        // Update status bar appearance using the new view controllers appearance - animate if needed
        if UIView.areAnimationsEnabled {
            UIView.animate(withDuration: CATransaction.animationDuration()) {
                newRootViewController.setNeedsStatusBarAppearanceUpdate()
            }
        } else {
            newRootViewController.setNeedsStatusBarAppearanceUpdate()
        }
        
        /// The presenting view controllers view doesn't get removed from the window as its currently transistioning and presenting a view controller
        if let transitionViewClass = NSClassFromString("UITransitionView") {
            for subview in subviews where subview.isKind(of: transitionViewClass) {
                subview.removeFromSuperview()
            }
        }
        if let previousViewController = previousViewController {
            // Allow the view controller to be deallocated
            previousViewController.dismiss(animated: false) {
                // Remove the root view in case its still showing
                previousViewController.view.removeFromSuperview()
            }
        }
    }
}

