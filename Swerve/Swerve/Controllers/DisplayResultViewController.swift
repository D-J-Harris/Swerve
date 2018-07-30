//
//  DisplayResultViewController.swift
//  Swerve
//
//  Created by Daniel Harris on 29/07/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation
import UIKit

class DisplayResultViewController: UIViewController {
    
    var receivedTextLabelText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        receivedTextLabel.text = receivedTextLabelText
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var receivedTextLabel: UILabel!
    
}
