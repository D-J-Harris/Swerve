//
//  Storyboard+Utility.swift
//  Swerve
//
//  Created by Daniel Harris on 26/07/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    enum MGType: String {
        case main
        case login
        case spotifylogin
        
        var filename: String {
            return rawValue.capitalized
        }
    }
    
    convenience init(type: MGType, bundle: Bundle? = nil) {
        self.init(name: type.filename, bundle: bundle)
    }
    
    static func initialViewController(for type: MGType) -> UIViewController {
        let storyboard = UIStoryboard(type: type)
        guard let initialViewController = storyboard.instantiateInitialViewController() else {
            fatalError("Couldn't instantiate initial view controller for \(type.filename) storyboard")
        }
        return initialViewController
    }
}
