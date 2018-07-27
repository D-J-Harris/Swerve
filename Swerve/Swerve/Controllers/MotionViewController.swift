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
    
    var testLabelText: String = "Receiver So No Data"
    @IBOutlet weak var testLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        testLabel.text = testLabelText
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {return}
        
        switch identifier {
        case Constants.Segue.backFromReceiver:
            if User.current.type == Constants.UserDictionary.receiver {
                UserService.deleteUserReference(User.current)
            }
        default:
            print("error no correct segue identified")
        }
    }
    
    
    
}
