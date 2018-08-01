//
//  OnboardingController.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 3/18/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit

class OnboardingPager: UIPageViewController {

    let pageControl = UIPageControl()
    var pages = [TourPageController]()
    var index = 0
    
    // Track the current index
    var currentIndex: Int?
    private var pendingIndex: Int?
    
    let images = ["icon-tour-1", "icon-tour-2", "icon-tour-3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        dataSource = self
        
        pages = [tourPageController(),tourPageController(),tourPageController()]
        
        setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        
        // pageControl
        pageControl.frame = CGRect()
        pageControl.currentPageIndicatorTintColor = UIColor("#919191")
        pageControl.pageIndicatorTintColor = UIColor("#b5b5b5")
        pageControl.numberOfPages = self.pages.count
        pageControl.currentPage = 0
        view.addSubview(self.pageControl)

        // pageControl constraints
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        pageControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 0).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
    }
    
    private func tourPageController() -> TourPageController {
        
        let controller = UIStoryboard(name: "App", bundle: nil)
            .instantiateViewController(withIdentifier: "TourPageControllerID") as! TourPageController
        
        controller.image = UIImage(named: images[index])
        controller.pageTitle = Strings.tourTitles[index]
        controller.pageDescription = Strings.tourDescriptions[index]
        controller.index = index
        
        index += 1
        
        return controller
    }
    
}

extension OnboardingPager: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    // viewControllerBefore
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let tourPageController = viewController as? TourPageController,
            let currentIndex = tourPageController.index, currentIndex > 0 else { return nil }
        
        print("JO: viewControllerBefore: Current Index: \(currentIndex)")
        
        let indexBefore = currentIndex - 1
        
        return pages[indexBefore]
    }
    
    // viewControllerAfter
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let tourPageController = viewController as? TourPageController,
            let currentIndex = tourPageController.index, currentIndex < 2 else { return nil }
        
        print("JO: viewControllerAfter: Current Index: \(currentIndex)")
        
        let indexAfter = currentIndex + 1
        let controller = pages[indexAfter]
        
        return controller
    }
    
    // willTransitionTo
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        let firstPendingController = pendingViewControllers.first as! TourPageController
        pendingIndex = firstPendingController.index
    }
    
    // didFinishAnimating
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            currentIndex = pendingIndex
            if let index = currentIndex {
                pageControl.currentPage = index
            }
        }
    }
}

