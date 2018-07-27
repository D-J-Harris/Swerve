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
        guard let identifier = segue.identifier else {return}
        
        switch identifier {
        case Constants.Segue.senderInfoToMotion:
            let stringTest = "testString"
            let destination = segue.destination as! MotionViewController
            destination.testLabelText = stringTest
        case Constants.Segue.backFromSender:
            UserService.deleteUserReference(User.current)
            print("testPrint")
        default:
            print("error no correct segue identified")
        }

        
        
    }
    
    @IBAction func toMotionButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: Constants.Segue.senderInfoToMotion, sender: self)
    }
    
    
    
}
