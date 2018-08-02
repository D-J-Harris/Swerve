//
//  AlertCentre.swift
//  Swerve
//
//  Created by Daniel Harris on 02/08/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation
import UIKit

public class AlertCentre {
    
    class var shared: AlertCentre {
        struct Static {
            static let instance: AlertCentre = AlertCentre()
        }
        return Static.instance
    }
    
    public func showIDSendAlert(_ id: String, viewController vc: UIViewController) {
        
    }
}
