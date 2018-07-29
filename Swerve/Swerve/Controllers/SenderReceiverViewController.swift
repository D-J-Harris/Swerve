//
//  SenderReceiverViewController.swift
//  Swerve
//
//  Created by Daniel Harris on 27/07/2018.
//  Copyright © 2018 Daniel Harris. All rights reserved.
//

import Foundation
import UIKit


class SenderReceiverViewController: UIViewController {
    
    @IBOutlet weak var senderButton: UIButton!
    @IBOutlet weak var receiverButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {return}
        
        switch identifier {
        case Constants.Segue.senderToSenderInfo:
            UserService.copyUserToSenders(User.current)
            User.current.type = Constants.UserDictionary.sender
        case Constants.Segue.receiverToMotion:
            UserService.copyUserToReceivers(User.current)
            User.current.type = Constants.UserDictionary.receiver
        default:
            print("error no correct segue identified")
        }
    }
    
    
    @IBAction func senderButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: Constants.Segue.senderToSenderInfo, sender: self)
    }
    
    @IBAction func receiverButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: Constants.Segue.receiverToMotion, sender: self)
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
    }
    
    
    
    
}
