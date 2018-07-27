//
//  SenderInputViewController.swift
//  Swerve
//
//  Created by Daniel Harris on 27/07/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation
import UIKit


class SenderInputViewController: UIViewController {
    
    @IBOutlet weak var toMotionButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "senderInfoToMotion" {
            let stringTest = "testString"
            let destination = segue.destination as! MotionViewController
            destination.testLabelText = stringTest
        }
        
        
    }
    
    @IBAction func toMotionButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "senderInfoToMotion", sender: self)
    }
    
    
    
}
