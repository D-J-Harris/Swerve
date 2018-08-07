//
//  TutorialPageViewController.swift
//  Swerve
//
//  Created by Daniel Harris on 06/08/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation
import UIKit

class TutorialPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    lazy var subViewControllers: [UIViewController] = {
        return [
            UIStoryboard(name: "Instructions", bundle: .main).instantiateViewController(withIdentifier: "Tutorial1ViewController"),
            UIStoryboard(name: "Instructions", bundle: .main).instantiateViewController(withIdentifier: "Tutorial2ViewController"),
            UIStoryboard(name: "Instructions", bundle: .main).instantiateViewController(withIdentifier: "Tutorial3ViewController"),
            UIStoryboard(name: "Instructions", bundle: .main).instantiateViewController(withIdentifier: "Tutorial4ViewController")
        ]
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        setViewControllers([subViewControllers[0]], direction: .forward, animated: true, completion: nil)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewControllers.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = subViewControllers.index(of: viewController) ?? 0
        if currentIndex <= 0 {
            return nil
        }
        return subViewControllers[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = subViewControllers.index(of: viewController) ?? 0
        if currentIndex >= subViewControllers.count - 1 {
            return nil
        }
        return subViewControllers[currentIndex + 1]
    }
}
