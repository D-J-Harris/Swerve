//
//  MotionViewController.swift
//  Swerve
//
//  Created by Daniel Harris on 27/07/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation
import UIKit


class MotionViewController: UIViewController {
    
    var testLabelText: String = "Hello"
    
    @IBOutlet weak var testLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        testLabel.text = testLabelText
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}
